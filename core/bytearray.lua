-- IMPORT
local Class = require "qua.core.class"
local conv = require "qua.math.convert"


-- IMPLEMENTATION
local ByteArray = Class:extend{
	new = function(self, bytes)
		self._bytes = {}
		self._pointer = 1
		if bytes then
			self:fromBytes(bytes)
		end
	end,
	
	-- From
	fromBytes = function(self, bytes)
		if type(bytes) ~= "table" then
			error("Expected array.", 2)
		end
		for _, byte in pairs(bytes) do
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
	
	fromString = function(self, str)
		if type(hex) ~= "string" then
			error("Expected string.", 2)
		end
		for char in str:gmatch(".") do
			table.insert(self._bytes, string.byte(char))
		end
	end,
	
	-- To
	toHex = function(self, bytes)
		bytes = bytes or self._bytes
		local symbols = "0123456789ABCDEF"
		local result = ""
		for _, byte in pairs(bytes) do
			local first = math.floor(byte / 16)
			local second = byte - first * 16
			result = result .. symbols:sub(first+1, first+1) .. symbols:sub(second+1, second+1)
		end
		return result
	end,
	
	toInt = function(self, bytes)
		return tonumber(self:toHex(bytes), 16)
	end,
	
	toString = function(self, bytes)
		bytes = bytes or self._bytes
		local chars = {}
		for _, byte in pairs(bytes) do
			table.insert(chars, string.char(byte))
		end
		return table.concat(chars, "")
	end,
	
	-- Array Ops
	sub = function(self, start, stop)
		stop = stop or #self._bytes
		if type(start) ~= "number" or type(stop) ~= "number" then
			error("Expected number, number", 2)
		end
		local result = {}
		for pos = start, stop do
			table.insert(result, self._bytes[pos])
		end
		return result
	end,
	
	reset = function(self)
		self._pointer = 1
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
	end,
	
	-- Shortcuts
	nextAsHex = function(self, count)
		local bytes = self:next(count)
		return self:toHex(bytes)
	end,
	
	nextAsInt = function(self, count)
		local bytes = self:next(count)
		return self:toInt(bytes)
	end,
	
	nextAsString = function(self, count)
		local bytes = self:next(count)
		return self:toString(bytes)
	end
}


-- EXPORT
return ByteArray
