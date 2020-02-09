-- IMPORT
local Class = require "qua.core.class"
local Box = require "qua.ui.drawable.box"
local Text = require "qua.ui.drawable.text"


-- IMPLEMENTATION
local Button = Class:extend{
	new = function(self, caption, pos, size, txcol, bgcol)
		self._box = Box(pos, size, bgcol)
		-- Calculate position of text
		local x, y = self._box:getPos()
		local w, h = self._box:getSize()
		local txpos = {
			x + math.floor((w - string.len(caption or "")) / 2),
			y + math.floor((h - 1) / 2)
		}
		self._text = Text(caption, txpos, txcol, bgcol)
	end,
	
	draw = function(self, monitor)
		self._box:draw(monitor)
		self._text:draw(monitor)
	end,
	
	setAction = function(method, ...)
		-- Args could include self => impossible in constructor
		self._action = method
		self._args = {...}
	end,
	
	click = function(self)
		if type(self._action) == "function" then
			if self._args == nil then
				self._action()
			else
				self._action(unpack(self._args))
			end
		end
	end

}


-- EXPORT
return Button