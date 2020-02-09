-- IMPORT
local Class = require "qua.core.class" 


-- IMPLEMENTATION
local Box = Class:extend{
	new = function(self, pos, size, color)
		self:setPos(pos)
		self:setSize(size)
		self:setColor(color)
	end,
	
	setPos = function(self, pos)
		self._pos_x = pos[1] or 1
		self._pos_y = pos[2] or 1
	end,
	
	getPos = function(self)
		return self._pos_x, self._pos_y
	end,
	
	setSize = function(self, size)
		self._width = size[1] or 1
		self._height = size[2] or 1
	end,
	
	getSize = function(self)
		return self._width, self._height
	end,
	
	setColor = function(self, color)
		self._col = color or colors.red
	end,
	
	getColor = function(self)
		return self._col
	end,
	
	draw = function(self, monitor)
		monitor.setBackgroundColor(self._col)
		for i = 0, self._height - 1 do
			monitor.setCursorPos(self._pos_x, self._pos_y + i)
			monitor.write(string.rep(" ", self._width))
		end
	end
}


-- EXPORT
return Box