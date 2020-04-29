-- IMPORT
local assert = require "qua.core.assert"
local Side = require "qua.cc.side"
local MultiScreen = require "qua.ui.multiscreen"


-- IMPLEMENTATION
local Display = MultiScreen:extend{
	new = function(self, side, scale)
		-- Defaults
		side = side or "term"
		scale = scale or 1
		assert(Side.isValidSide(side) or side == "term", "Expected valid side!", 3)
		assert(type(scale) == "number" and scale >= 0.5 and scale <= 5, "Expected number in range 0.5-5!", 3)
		-- Decide which term to use
		if side == "term" then
			self._monitor = term
		elseif peripheral.getType(side) == "monitor" then
			self._monitor = peripheral.wrap(side)
			self._monitor.setTextScale(scale or 1)
		else
			self._monitor = term
		end
		-- Super
		MultiScreen.new(self, {1, 1}, {self:getSize()})
	end,
	
	selectScreen = function(self, name)
		MultiScreen.selectScreen(self, name)
		self:update()
	end,
	
	getMonitor = function(self)
		return self._monitor
	end,
	
	getSize = function(self)
		return self._monitor.getSize()
	end,
	
	clear = function(self)
		local mon = self._monitor
		mon.setTextColor(colors.white)
		mon.setBackgroundColor(colors.black)
		mon.clear()
		mon.setCursorPos(1, 1)
	end,
	
	update = function(self)
		self:draw(self._monitor)
	end
}


-- EXPORT
return Display
