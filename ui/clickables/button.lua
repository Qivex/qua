-- IMPORT
local Clickable = require "qua.ui.clickable"
local Box = require "qua.ui.drawables.box"
local Text = require "qua.ui.drawables.text"


-- IMPLEMENTATION
local Button = Clickable:extend{
	new = function(self, caption, pos, size, txcol, bgcol)
		self._box = Box(pos, size, bgcol)
		self._text = Text(caption, pos, txcol, bgcol)
		self:_centerText()
	end,
	
	_centerText = function(self)
		local x, y = self._box:getPos()
		local w, h = self._box:getSize()
		local length = string.len(self._text:getText())
		self._text:setPos({
			x + math.floor((w - length) / 2),
			y + math.floor((h - 1) / 2)
		})
	end,
	
	setCaption = function(self, caption)
		self._text:setText(caption)
		self:_centerText()
	end,
	
	getCaption = function(self)
		return self._text:getText()
	end,
	
	setPos = function(self, pos)
		self._box:setPos(pos)
		self:_centerText()
	end,
	
	getPos = function(self)
		return self._box:getPos()
	end,
	
	setSize = function(self, size)
		self._box:setSize(size)
		self:_centerText()
	end,
	
	getSize = function(self)
		return self._box:getSize()
	end,
	
	setTextColor = function(self, color)
		self._text:setTextColor(color)
	end,
	
	getTextColor = function(self)
		return self._text:getTextColor()
	end,
	
	setBackgroundColor = function(self, color)
		self._box:setColor(color)
		self._text:setBackgroundColor(color)
	end,
	
	getBackgroundColor = function(self)
		return self._text:getBackgroundColor()
	end,
	
	setAction = function(self, method, ...)
		-- Args could include self => impossible in constructor
		self._action = method
		self._args = {...}
	end,
	
	draw = function(self, monitor)
		self._box:draw(monitor)
		self._text:draw(monitor)
	end,
	
	click = function(self, click_x, click_y)
		local w, h = self._box:getSize()
		local x, y = self._box:getPos()
		if x <= click_x and click_x < x + w and y <= click_y and click_y < y + h then
			if type(self._action) == "function" then
				if self._args == nil then
					self._action()
				else
					self._action(unpack(self._args))
				end
			end
		end
	end

}


-- EXPORT
return Button