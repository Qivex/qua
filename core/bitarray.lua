-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local BitArray = Class:extend{
	new = function(self, isLittleEndian)
		self._is_little_endian = isLittleEndian or false
		self._bits = {}		-- big-endian & MSB
		self._buffer = {}
		self._pointer = 1
	end,
	
	fromBits = function(self, array)
		if type(array) ~= "table" then
			error("Expected array.", 2)
		end
		for _, bit in pairs(array) do
			if bit == 0 or bit == 1 then
				table.insert(self._bits, bit)
			else
				error("Invalid bit value in input.", 2)
			end
		end
	end,
	
	fromHex = function(self, hex)
		if type(hex) ~= "string" then
			error("Expected hexadecimal string.", 2)
		end
		for byte in hex:gmatch("..") do
			local int = tonumber(byte, 16)
			for e=7, 0, -1 do
				local div = 2^e
				if int / div >= 1 then
					table.insert(self._bits, 1)
					int = int - div
				else
					table.insert(self._bits, 0)
				end
			end
		end
	end,
	
	next = function(self, count, reversed)
		count = tonumber(count) or 1
		reversed = reversed or false
		local result = {}
		for i=1, count do
			-- Fill buffer
			if #self._buffer == 0 then
				local start, stop, step = 0, 7, 1
				if self._is_little_endian then
					start, stop, step = stop, start, -step
				end
				for i=start, stop, step do
					local pos = self._pointer + i
					if pos > #self._bits then
						break
					else
						table.insert(self._buffer, self._bits[pos])
					end
				end
				self._pointer = self._pointer + 8
			end
			-- Add bit
			local next_bit = table.remove(self._buffer, 1)
			if reversed then
				table.insert(result, 1, next_bit)
			else
				table.insert(result, next_bit)
			end
		end
		return result
	end,
	
	nextAsInt = function(self, count, reversed)
		local bits = self:next(count, reversed)
		return tonumber(table.concat(bits, ""), 2)
	end,
	
	skip = function(self)
		-- Skip to next byte-border
		self._buffer = {}
	end,
	
	reset = function(self)
		self._buffer = {}
		self._pointer = 1
	end
}


-- EXPORT
return BitArray