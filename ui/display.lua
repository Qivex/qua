-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local Display = Class:extend{
	new = function(self, side, scale)
		if side == "term" then
			self._monitor = term
		elseif peripheral.getType(side) == "monitor" then
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
	
	addScreen = function(self, name, screen)
		if self._screens[name] ~= nil then
			error("This display already has a screen called'" .. name .. "'!", 2)
		end
		self._screens[name] = screen
		screen:setDisplay(self)
	end,
	
	getScreen = function(self, name, screen)
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
		self._activeScreen = screen
		self:clear()
		screen:render()
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
