-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local Drawable = Class:extend{
	new = function(self)
		error("Can't create abstract Drawable.", 2)
	end,
	
	draw = function(self, monitor)
		error("Can't draw abstract Drawable.", 2)
	end,
	
	isClickable = function(self)
		return self._clickable or false
	end
}


-- EXPORT
return Drawable