-- IMPORT
local Class = require "qua.core.class"
local assert = require "qua.core.assert"


-- CONSTANTS
local PAINT_CHARS = "0123456789abcdef"


-- IMPLEMENTATION
local PAINT_LOOKUP = {}
local color = 1
for code in PAINT_CHARS:gmatch(".") do
	PAINT_LOOKUP[code] = color
	color = color * 2
end

local Color = Class:extend{
	new = function(self, col)
		assert(self.isValidColor(col), "Invalid color!", 3)
		self._color = col
	end,
	
	__tonumber = function(self)
		return self._color
	end,
	
	isValidColor = function(col)
		-- Color must be number
		if type(col) ~= "number" then
			return false
		end
		-- Anything inside interval is valid
		if col >= 1 and col < 65536 then
			return true
		else
			return false
		end
	end,
	
	fromHex = function(symbol)
		assert(type(symbol) == "string", "Expected string!", 2)
		assert(symbol:len() == 1, "Expected a single char!", 2)
		return PAINT_LOOKUP[symbol]	-- Can return nil (intentional)
	end,
	
	toHex = function(col)
		assert(self.isValidColor(col), "Invalid color!", 2)
		local base = math.log(col) / math.log(2)	-- simulates 'math.log2(col)'
		return PAINT_CHARS:sub(base + 1, base + 1)
	end
}


-- EXPORT
return Color
