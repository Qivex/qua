-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local Button = Class:extend{
	new = function(self, caption, pos, size, txcol, bgcol, action, args)
		self._box = Box(pos, size, bgcol)
		-- Calculate position of text
		local x, y = unpack(self._box:getPos())
		local w, h = unpack(self._box:getSize())
		local txpos = {
			x - 1 + math.floor((w - string.len(caption or "") / 2),
			y - 1 + math.ceil(h / 2)
		}
		self._text = Text(caption, txpos, txcol, bgcol)
		self._action = action
		self._args = args
	end,
	
	draw = function(self, monitor)
		-- Write Text
		monitor.setCursorPos(
			self._pox_x - 1 + math.floor((self._width - string.len(self._caption)) / 2),
			self._pox_y - 1 + math.ceil(self._height / 2)
		)
		monitor.write(self._caption)
		
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