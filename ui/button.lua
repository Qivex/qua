-- IMPORT
local Clickable = require "qua.ui.clickable"
local Box = require "qua.ui.box"
local Label = require "qua.ui.label"


-- IMPLEMENTATION
local Button = Clickable:extend{
	new = function(self, caption, pos, size, txcol, bgcol)
		self._box = Box(pos, size, bgcol)
		self._label = Label(caption, pos, txcol, bgcol)
		self:_centerLabel()
	end,
	
	_centerLabel = function(self)
		local x, y = self._box:getPos()
		local w, h = self._box:getSize()
		local length = string.len(self._label:getText())
		self._label:setPos({
			x + math.floor((w - length) / 2),
			y + math.floor((h - 1) / 2)
		})
	end,
	
	setCaption = function(self, caption)
		self._label:setText(caption)
		self:_centerLabel()
	end,
	
	getCaption = function(self)
		return self._label:getText()
	end,
	
	setPos = function(self, pos)
		self._box:setPos(pos)
		self:_centerLabel()
	end,
	
	getPos = function(self)
		return self._box:getPos()
	end,
	
	setSize = function(self, size)
		self._box:setSize(size)
		self:_centerLabel()
	end,
	
	getSize = function(self)
		return self._box:getSize()
	end,
	
	setTextColor = function(self, color)
		self._label:setTextColor(color)
	end,
	
	getTextColor = function(self)
		return self._label:getTextColor()
	end,
	
	setBackgroundColor = function(self, color)
		self._box:setColor(color)
		self._label:setBackgroundColor(color)
	end,
	
	getBackgroundColor = function(self)
		return self._label:getBackgroundColor()
	end,
	
	setAction = function(self, method, ...)
		-- Args could include self => impossible in constructor
		if type(method) ~= "function" then
			error("First parameter must be a function!", 2)
		end
		self._action = method
		self._args = {...}
	end,
	
	draw = function(self, monitor)
		self._box:draw(monitor)
		self._label:draw(monitor)
	end,
	
	click = function(self, click_x, click_y)
		local w, h = self._box:getSize()
		local x, y = self._box:getPos()
		if x <= click_x and click_x < x + w and y <= click_y and click_y < y + h then
			if self._action then
				self._action(unpack(self._args))
			end
		end
	end

}


-- EXPORT
return Button
