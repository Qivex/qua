-- IMPORT
local Class = require "qua.core.class" 


-- IMPLEMENTATION
local Text = Class:extend{
	new = function(self, text, pos, txcol, bgcol)
		self:setText(text)
		self:setPos(pos)
		self:setTextColor(txcol)
		self:setBackgroundColor(bgcol)
	end,
	
	setText = function(self, text)
		self._text = text or ""
	end,
	
	getText = function(self)
		return self._text
	end,
	
	setPos = function(self, pos)
		self._pos_x = pos[1] or 1
		self._pos_y = pos[2] or 1
	end,
	
	getPos = function(self)
		return self._pos_x, self._pos_y
	end,
	
	setTextColor = function(self, color)
		self._txcol = color or colors.white
	end,
	
	getTextColor = function(self)
		return self._txcol
	end,
	
	setBackgroundColor = function(self, color)
		self._bgcol = color or colors.black
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
return Text