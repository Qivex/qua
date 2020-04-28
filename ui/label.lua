-- IMPORT
local assert = require "qua.core.assert"
local Drawable = require "qua.ui.drawable"
local Color = require "qua.cc.color"


-- IMPLEMENTATION
local Label = Drawable:extend{
	new = function(self, text, position, txcol, bgcol)
		self:setText(text)
		self:setPos(position)
		self:setTextColor(txcol or colors.white)
		self:setBackgroundColor(bgcol or colors.black)
	end,
	
	setText = function(self, text)
		assert(type(text) == "string", "Expected string!", 2)
		self._text = text
	end,
	
	getText = function(self)
		return self._text
	end,
	
	setPos = function(self, position)
		assert(type(position) == "table", "Expected table!", 2)
		self._pos_x, self._pos_y = unpack(position)
		assert(type(self._pos_x) == "number" and type(self._pos_y) == "number", "Expected 2 numbers as position!", 2)
	end,
	
	getPos = function(self)
		return self._pos_x, self._pos_y
	end,
	
	setTextColor = function(self, color)
		assert(Color.isValidColor(color), "Expected valid color!", 2)
		self._txcol = color
	end,
	
	getTextColor = function(self)
		return self._txcol
	end,
	
	setBackgroundColor = function(self, color)
		assert(Color.isValidColor(color), "Expected valid color!", 2)
		self._bgcol = color
	end,
	
	getBackgroundColor = function(self)
		return self._bgcol
	end,
	
	draw = function(self, monitor)
		monitor.setTextColor(self._txcol)
		monitor.setBackgroundColor(self._bgcol)
		monitor.setCursorPos(self._pos_x, self._pos_y)
		monitor.write(self._text)
	end
}


-- EXPORT
return Label
