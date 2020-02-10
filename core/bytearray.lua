-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local ByteArray = Class:extend{
	new = function(self)
		self._bytes = {}
		self._pointer = 1
	end,
	
	fromArray = function(self, array)
		if type(array) ~= "table" then
			error("Expected array.", 2)
		end
		for _, byte in pairs(array) do
			if type(byte) == "number" and 0 <= byte and byte <= 255 then
				table.insert(self._bytes, byte)
			else
				error("Invalid byte value in input.", 2)
			end
		end
	end,
	
	fromHex = function(self, hex)
		if type(hex) ~= "string" then
			error("Expected hexadecimal string.", 2)
		end
		for byte in hex:gmatch("..") do
			table.insert(self._bytes, tonumber(byte, 16))
		end
	end,
	
	toHex = function(self)
		local values = "0123456789ABCDEF"
		local result = ""
		for _, byte in pairs(self._bytes) do
			local first = math.floor(byte / 16)
			local second = byte - first * 16
			result = result .. values:sub(first+1, first+1) .. values:sub(second+1, second+1)
		end
		return result
	end,
	
	toString = function(self)
		local chars = {}
		for _, byte in pairs(self._bytes) do
			table.insert(chars, string.char(byte))
		end
		return table.concat(chars, "")
	end,
	
	sub = function(self, start, stop)
		if type(start) ~= "number" or type(stop) ~= "number" then
			error("Expected number, number", 2)
		end
		local result = {}
		for pos = start, stop do
			table.insert(result, self._bytes[pos])
		end
		return result
	end,
	
	next = function(self, count)
		count = tonumber(count) or 1
		local result = {}
		for i=1, count do
			if self._pointer > #self._bytes then
				break
			else
				table.insert(result, self._bytes[self._pointer])
			end
			self._pointer = self._pointer + 1
		end
		return result
	end
}


-- EXPORT
return ByteArray
