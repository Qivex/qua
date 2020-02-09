-- IMPORT
local Class = require "qua.core.class"
local Box = require "qua.ui.drawable.box"
local Text = require "qua.ui.drawable.text"


-- IMPLEMENTATION
local Button = Class:extend{
	new = function(self, caption, pos, size, txcol, bgcol, action, args)
		self._box = Box(pos, size, bgcol)
		-- Calculate position of text
		local x, y = self._box:getPos()
		local w, h = self._box:getSize()
		local txpos = {
			x + math.floor((w - string.len(caption or "")) / 2),
			y + math.floor((h - 1) / 2)
		}
		self._text = Text(caption, txpos, txcol, bgcol)
		self._action = action
		self._args = args
	end,
	
	draw = function(self, monitor)
		self._box:draw(monitor)
		self._text:draw(monitor)
	end,
	
	click = function(self)
		local action = self._action
		local args = unpack(self._args)
		if type(action) == "function" then
			action(args)
		end
	end

}


-- EXPORT
return Button