-- IMPORT
local Class = require "qua.core.class"
local conv = require "qua.math.convert"


-- CONSTANTS
local BITWISE_LEFT_SHIFT = bit.lshift or bit.blshift


-- IMPLEMENTATION
local HuffmanTree = Class:extend{
	new = function(self)
		self._lookup = {}
		self._max_len = 0
	end,
	
	fromLengths = function(self, lengths)
		-- Step 1: count occurrences
		local len_count = {}
		for symbol, length in pairs(lengths) do
			len_count[length] = (len_count[length] or 0) + 1
			if length > self._max_len then
				self._max_len = length
			end
		end
		len_count[0] = 0
		-- Step 2: get start codes
		local next_code = {}
		local code = 0
		for length = 1, self._max_len do
			code = code + (len_count[length - 1] or 0)
			code = BITWISE_LEFT_SHIFT(code, 1)
			next_code[length] = code
		end
		-- Step 3: generate codes
		for symbol, length in pairs(lengths) do
			if length and length > 0 then
				local code = next_code[length]
				-- Convert to string (leading zeroes)
				local code_str = conv.num2bin(code, "big")
				local missing = length - code_str:len()
				if missing ~= 0 then
					-- Add leading zeroes
					code_str = string.rep("0", missing) .. code_str
				end
				-- Save for lookup
				self._lookup[code_str] = symbol
				next_code[length] = code + 1
			end
		end
	end,
	
	decode = function(self, code)
		if code:len() > self._max_len then
			error("Code too long or unknown code.")
		end
		-- Decode using lookup
		local result = self._lookup[code]
		if result then
			return result
		end
		return false
	end
}


-- EXPORT
return HuffmanTree
