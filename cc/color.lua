-- IMPORT
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

local isValidColor = function(color)
	-- Color must be number
	if type(color) ~= "number" then
		return false
	end
	-- Anything inside interval is valid
	if color >= 1 and color < 65536 then
		return true
	else
		return false
	end
end

local fromHex = function(symbol)
	assert(type(symbol) == "string", "Expected string!", 2)
	assert(symbol:len() == 1, "Expected a single char!", 2)
	return PAINT_LOOKUP[symbol]	-- Can return nil (intentional)
end

local toHex = function(color)
	assert(isValidColor(color), "Invalid color!", 2)
	local base = math.log(color) / math.log(2)	-- simulates 'math.log2(color)'
	return PAINT_CHARS:sub(base + 1, base + 1)
end


-- EXPORT
return {
	isValidColor = isValidColor,
	fromHex = fromHex,
	toHex = toHex
}
