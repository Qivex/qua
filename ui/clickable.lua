-- IMPORT
local Drawable = require "qua.ui.drawable"


-- IMPLEMENTATION
local Clickable = Drawable:extend{
	new = function(self)
		error("Can't create abstract Clickable.", 2)
	end,
	
	click = function(self, x, y)
		error("The function 'Clickable:click(x,y)' is required for Clickables!", 2)
	end
}


-- EXPORT
return Clickable