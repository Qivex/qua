-- IMPORT
local Class = require "qua.core.class"
local BitStream = require "qua.core.bitstream"
local HuffmanTree = require "qua.decode.huffman"


-- CONSTANTS
local CODE_LENGTH_SYMBOL_ORDER = {16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15}

local LENGTH_OFFSET = {3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258}
local LENGTH_EXTRA_BITS = {0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0}	-- = floor((i-257)/4 - 1) except 257&285

local DISTANCE_OFFSET = {1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577}		-- = 2^floor(i/2) + 1
local DISTANCE_EXTRA_BITS = {0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13}	-- = floor(i/2 - 1)

--Fixed Literal Tree
local flt_len = {}
for i=  0, 143 do flt_len[i] = 8 end
for i=144, 255 do flt_len[i] = 9 end
for i=256, 279 do flt_len[i] = 7 end
for i=280, 287 do flt_len[i] = 8 end
local FIXED_LITERAL_TREE = HuffmanTree()
FIXED_LITERAL_TREE:fromLengths(flt_len)

--Fixed Distance Tree
local fdt_len = {}
for i=0,31 do fdt_len[i] = 5 end
local FIXED_DISTANCE_TREE = HuffmanTree()
FIXED_DISTANCE_TREE:fromLengths(fdt_len)

--local MAX_CODE_LENGTH = 15

-- TODO: Error-Messages


-- IMPLEMENTATION
local DeflateBlock = Class:extend{	
	new = function(self, stream)
		self._stream = stream
	end,
	
	setOutput = function(self, output)
		self._output = output
	end,
	
	deflate = function(self)
		local stream = self._stream
		-- Read block-header
		self._last = stream:bits(1, true)
		local blocktype = stream:bits(2, true)
		print(blocktype)
		-- Select required decoding method
		if blocktype == 0 then
			self:_stored()
		elseif blocktype == 1 then
			self:_fixed()
		elseif blocktype == 2 then
			self:_dynamic()
		else
			error("Invalid blocktype found: " .. blocktype, 2)
		end
	end,
	
	isLast = function(self)
		return (self._last == 1)
	end,
	
	_stored = function(self)
		print("Stored block (currently untested)")
		local stream = self._stream
		-- Skip to next byte boundary
		stream:clearBuffer()	
		-- Read LEN & NLEN
		local LEN = stream:bits(16, true)
		local NLEN = stream:bits(16, true)
		-- Copy bytes
		for i=1, LEN do
			table.insert(self._output, stream:bits(8, true))
		end
	end,
	
	_fixed = function(self)
		self:_internalDeflate(FIXED_LITERAL_TREE, FIXED_DISTANCE_TREE)
	end,
	
	_dynamic = function(self)
		local stream = self._stream
		-- Read info of dynamic trees
		local HLIT   = stream:bits(5, true)
		local HCDIST = stream:bits(5, true)
		local HCLEN  = stream:bits(4, true)
		-- Read lengths for code-length tree
		local clt_len = {}
		for i, symbol in pairs(CODE_LENGTH_SYMBOL_ORDER) do
			if i <= (HCLEN + 4) then
				clt_len[symbol] = stream:bits(3, true)
			end
		end
		-- Build code-length tree
		local codeLengthTree = HuffmanTree()
		codeLengthTree:fromLengths(clt_len)
		-- Decode remaining lengths (using code-length tree)
		local seq_len = {}	-- Sequential lengths (of both trees)
		local index = 0
		while index < (HLIT + 257) + (HCDIST + 1) do
			local symbol = codeLengthTree:findNextSymbolIn(stream)
			if symbol < 16 then	-- Length value
				local length = symbol
				seq_len[index] = length
				index = index + 1
			else				-- Repeated lengths
				local length, repetitions = 0, 0
				if symbol == 16 then
					length = seq_len[index - 1]
					repetitions = stream:bits(2, true) + 3
				elseif symbol == 17 then
					repetitions = stream:bits(3, true) + 3
				elseif symbol == 18 then
					repetitions = stream:bits(7, true) + 11
				end
				while repetitions > 0 do
					seq_len[index] = length
					repetitions = repetitions - 1
					index = index + 1
				end
			end
		end
		-- Split combined lengths
		local lit_len, dist_len = {}, {}
		for symbol, length in pairs(seq_len) do
			if symbol <= 285 then
				lit_len[symbol] = length
			else
				dist_len[symbol - 286] = length
			end
		end
		-- Build the other 2 trees
		local literalTree = HuffmanTree()
		literalTree:fromLengths(lit_len)
		local distanceTree = HuffmanTree()
		distanceTree:fromLengths(dist_len)
		-- Decode
		self:_internalDeflate(literalTree, distanceTree)
	end,
	
	_internalDeflate = function(self, literalTree, distanceTree)
		local stream = self._stream
		repeat
			local symbol = literalTree:findNextSymbolIn(stream)
			if symbol < 256 then		-- Literal
				-- Insert literal value
				table.insert(self._output, symbol)
			elseif symbol > 256 then	-- Copy
				-- Read missing information from stream
				local length_symbol = symbol
				local length_extra = stream:bits(LENGTH_EXTRA_BITS[length_symbol - 256], true) or 0	-- Read length extra bits (0-5)
				local dist_symbol = distanceTree:findNextSymbolIn(stream)							-- Read distance symbol
				local dist_extra = stream:bits(DISTANCE_EXTRA_BITS[dist_symbol + 1], true) or 0		-- Read distance extra bits (0-13)
				-- Calculate real length & distance
				local length = LENGTH_OFFSET[length_symbol - 256] + length_extra
				local distance = DISTANCE_OFFSET[dist_symbol + 1] + dist_extra
				-- Execute copy
				self:_copy(length, distance)
			end
		until symbol == 256				-- End of block
	end,
	
	_copy = function(self, length, distance)
		local output = self._output
		for i=1, length do
			table.insert(output, output[#output - distance + 1])
		end
	end
}

local deflate = function(input)
	local stream = BitStream(input, "little")
	local output = {}	-- Array of bytes (as ints)
	repeat
		local block = DeflateBlock(stream)
		block:setOutput(output)
		block:deflate()
	until block:isLast()
	return output
end


-- EXPORT
return deflate
