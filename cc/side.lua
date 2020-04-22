-- CONSTANTS
local VALID_SIDES = {"front", "back", "top", "bottom", "left", "right"}


-- IMPLEMENTATION
isValidSide = function(side)
	-- Side must be string
	if type(side) ~= "string" then
		return false
	end
	-- Only 6 valid options
	for _, valid in pairs(VALID_SIDES) do
		if side == valid then
			return true
		end
	end
	return false
end


-- EXPORT
return {
	isValidSide = isValidSide,
	allValidSides = VALID_SIDES
}
