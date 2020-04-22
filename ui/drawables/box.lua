-- IMPORT
local assert = require "qua.core.assert"
local Drawable = require "qua.ui.drawable"
local Color = require "qua.cc.color"


-- IMPLEMENTATION
local Box = Drawable:extend{
	new = function(self, position, size, color)
		self:setPos(position)
		self:setSize(size)
		self:setColor(color)
	end,
	
	setPos = function(self, position)
		assert(type(position) == "table", "Expected table!", 2)
		self._pos_x, self._pos_y = unpack(position)
		assert(type(self._pos_x) == "number" and type(self._pos_y) == "number", "Expected 2 numbers as position!", 2)
	end,
	
	getPos = function(self)
		return self._pos_x, self._pos_y
	end,
	
	setSize = function(self, size)
		assert(type(size) == "table", "Expected table!", 2)
		self._width, self._height = unpack(size)
		assert(type(self._width) == "number" and type(self._height) == "number", "Expected 2 numbers as size!", 2)
	end,
	
	getSize = function(self)
		return self._width, self._height
	end,
	
	setColor = function(self, color)
		assert(Color.isValidColor(color), "Expected valid color!", 2)
		self._col = color
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
