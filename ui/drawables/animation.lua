-- IMPORT
local Drawable = require "qua.ui.drawable"


-- IMPLEMENTATION
local Animation = Drawable:extend{	
	new = function(self, loop)
		self._loop = loop
		self._animation = {}
		self._current = nil
	end,
	
	draw = function(self, monitor)
		local drawable = table.remove(self._animation, 1) or self._current
		if drawable then
			self._current = drawable
			drawable:draw(monitor)
		end
		-- Add frame back to end if looped
		if self._loop then
			self:addFrame(drawable)
		end
	end,
	
	addFrame = function(self, drawable)
		table.insert(self._animation, drawable)
	end,
	
	getLength = function(self)
		return #self._animation
	end
}


-- EXPORT
return Animation