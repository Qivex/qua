-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local Drawable = Class:extend{
	new = function(self)
		error("Can't create abstract Drawable.", 2)
	end,
	
	draw = function(self, monitor)
		error("The function 'Drawable:draw(monitor)' is required for Drawables!", 2)
	end
}


-- EXPORT
return Drawable