-- IMPORT
local Class = require "qua.core.class"

-- TODO: More robust (checks), Insert+Remove

-- IMPLEMENTATION
local BitStream = Class:extend{
	new = function(self, str, endian)
		-- Bits
		self._array = {}	-- is big-endian & MSB first
		for bit in str:gmatch(".") do
			if bit == "1" or bit == "0" then
				table.insert(self._array, tonumber(bit))
			else
				error("Invalid Char in source of BitStream (neither 1 nor 0)", 2)
			end
		end
		-- Fill up last byte
		while #self._array % 8 ~= 0 do
			table.insert(self._array, 0)
		end
		-- Endian
		if endian == "big" or endian == "little" then
			self._endian = endian
		else
			error("Endian must be 'big' or 'little'!", 2)
		end
		
		self:reset()
	end,
	
	read = function(self, amount, reversed)
		local bits, next_bit = {}, 0
		while #bits < amount do
			-- Fill buffer
			if #self._buffer == 0 then
				self._buffer = self:nextByte()
			end
			if not self._buffer then
				return false
			end
			-- Read bit from buffer
			next_bit = table.remove(self._buffer, 1)
			-- Insert bit into output
			if reversed then
				table.insert(bits, 1, next_bit)
			else
				table.insert(bits, next_bit)
			end
		end
		return bits
	end,
	
	-- shortcut for int
	bits = function(self, amount, reversed)
		return tonumber(table.concat(self:read(amount, reversed), ""), 2)
	end,
	
	nextByte = function(self)
		if self._nextByte * 8 >= #self._array then
			return false
		end
		local bits, next_bit = {}, 0
		for i=1, 8 do
			next_bit = self._array[8 * self._nextByte + i]
			if self._endian == "big" then
				table.insert(bits, next_bit)
			elseif self._endian == "little" then
				table.insert(bits, 1, next_bit)
			end
		end
		self._nextByte = self._nextByte + 1		-- MSB-to-LSB
		return bits
	end,
	
	clearBuffer = function(self)
		self._buffer = {}
	end,
	
	reset = function(self)
		self._nextByte = 0
		self._buffer = {}
	end
}


-- EXPORT
return BitStream
