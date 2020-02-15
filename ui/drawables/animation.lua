-- IMPORT
local Drawable = require "qua.ui.drawable"


-- IMPLEMENTATION
local Animation = Drawable:extend{	
	new = function(self, loop)
		self._loop = loop
		self._animation = {}
	end,
	
	draw = function(self, monitor)
		local drawable = table.remove(self._animation, 1)
		drawable:draw(monitor)
		if self._loop then
			self:addFrame(drawable)
		end
	end,
	
	addFrame = function(self, drawable)
		table.insert(self._animation, drawable)
	end
}