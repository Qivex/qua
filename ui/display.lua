-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local Display = Class:extend{
	new = function(self, side, scale)
		if peripheral.getType(side) == "monitor" then
			self._monitor = peripheral.wrap(side)
			self._monitor.setTextScale(scale)
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
	
	addScreen(self, name, screen)
		if self._screens[name] ~= nil then
			error("This display already has a screen called'" .. name .. "'!", 2)
		end
		self._screens[name] = screen
		screen:setDisplay(self)
	end,
	
	getScreen(self, name, screen)
		if self._screens[name] == nil then
			error("No screen called '" .. name .. "'!", 2)
		end
		return self._screens[name]
	end,
	
	getCurrentScreen(self)
		return self._activeScreen
	end,
	
	selectScreen(self, name)
		local screen = self:getScreen(name)
		self._activeScreen = screen
		screen:render()
	end
}


-- EXPORT
return Display
