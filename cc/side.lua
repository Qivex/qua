-- IMPORT
local Class = require "qua.core.class"
local assert = require "qua.core.assert"


-- CONSTANTS
local VALID_SIDES = {"front", "back", "top", "bottom", "left", "right"}


-- IMPLEMENTATION
local Side = Class:extend{
	new = function(self, side)
		assert(self.isValidSide(side), "Invalid side!", 3)
		self._side = side
	end,
	
	__tostring = function(self)
		return self._side
	end,
	
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
	end,
	
	allValidSides = function()
		return VALID_SIDES
	end
}


-- EXPORT
return Side
