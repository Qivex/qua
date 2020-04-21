-- IMPORT
local Class = require "qua.core.class"
local Screen = require "qua.ui.screen"


-- IMPLEMENTATION
local Display = Class:extend{
	new = function(self, side, scale)
		side = side or "term"
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
		if type(name) ~= "string" or not Class.isA(screen, Screen) then
			error("Expected string & qua.ui.screen!", 2)
		end
		if self._screens[name] ~= nil then
			error("This display already has a screen called '" .. name .. "'!", 2)
		end
		self._screens[name] = screen
	end,
	
	getScreen = function(self, name)
		if type(name) ~= "string" then
			error("Expected string!", 2)
		end
		if self._screens[name] == nil then
			error("No screen called '" .. name .. "'!", 2)
		end
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
		if screen ~= nil then
			screen:click(x, y)
		end
	end
}


-- EXPORT
return Display
