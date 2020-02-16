-- IMPLEMENTATION
local to1D = function(width, x, y)
	return (y-1) * width + x
end

local from1D = function(width, index)
	local y = math.ceil(index / width)
	local x = index - (y-1) * width
	return x, y
end


-- EXPORT
return {
	to1D = to1D,
	from1D = from1D
}
