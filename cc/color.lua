-- IMPORT
local assert = require "qua.core.assert"


-- CONSTANTS
local PAINT_CHARS = "0123456789abcdef"


-- IMPLEMENTATION
local PAINT_LOOKUP = {}
local col = 1
for code in PAINT_CHARS:gmatch(".") do
	PAINT_LOOKUP[code] = color
	col = col * 2
end

local isValidColor = function(col)
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
end

local fromHex = function(symbol)
	assert(type(symbol) == "string", "Expected string!", 2)
	assert(symbol:len() == 1, "Expected a single char!", 2)
	return PAINT_LOOKUP[symbol]	-- Can return nil (intentional)
end

local toHex = function(col)
	assert(isValidColor(col), "Invalid color!", 2)
	local base = math.log(col) / math.log(2)	-- simulates 'math.log2(col)'
	return PAINT_CHARS:sub(base + 1, base + 1)
end


-- EXPORT
return {
	isValidColor = isValidColor,
	fromHex = fromHex,
	toHex = toHex
}
