-- IMPORT
local assert = require "qua.core.assert"
local Class = require "qua.core.class"
local Screen = require "qua.ui.screen"
local Side = require "qua.cc.side"


-- IMPLEMENTATION
local Display = Class:extend{
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
		self._screens = {}
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
	
	getNewScreen = function(self)
		return Screen({1,1}, {self:getMonitor().getSize()})
	end,
	
	addScreen = function(self, name, screen)
		assert(type(name) == "string" and Class.isA(screen, Screen), "Expected string & qua.ui.screen!", 2)
		assert(self._screens[name] == nil, "This display already has a screen called '" .. name .. "'!", 2)
		self._screens[name] = screen
	end,
	
	getScreen = function(self, name)
		assert(type(name) == "string", "Expected string!", 2)
		assert(self._screens[name] ~= nil, "No screen called '" .. name .. "'!", 2)
		return self._screens[name]
	end,
	
	getCurrentScreen = function(self)
		return self._activeScreen
	end,
	
	selectScreen = function(self, name)
		local screen = self:getScreen(name)
		if screen ~= self._activeScreen then
			self._activeScreen = screen
			self:update()
		end
	end,
	
	update = function(self)
		self:clear()
		local screen = self:getCurrentScreen()
		if screen then
			screen:draw(self:getMonitor())
		end
	end,
	
	click = function(self, x, y)
		local screen = self:getCurrentScreen()
		if screen then
			screen:click(x, y)
		end
	end
}


-- EXPORT
return Display
