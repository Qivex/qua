-- CONSTANTS
local PAINT_CHARS = "0123456789abcdef"
local PAINT_LOOKUP = {}
local color = 1
for code in PAINT_CHARS:gmatch(".") do
	PAINT_LOOKUP[char] = color
	color = color * 2
end


-- IMPLEMENTATION
local decode = function(symbol)
	return PAINT_LOOKUP[symbol]
end

local encode = function(color)
	local pos = math.log(color) / math.log(2) + 1
	return PAINT_CHARS:sub(pos, pos)
end


-- EXPORT
return {
	decode = decode,
	encode = encode
}
