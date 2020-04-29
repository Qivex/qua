-- IMPORT
local assert = require "qua.core.assert"
local Class = require "qua.core.class"
local Clickable = require "qua.ui.clickable"
local Screen = require "qua.ui.screen"


-- IMPLEMENTATION
local MultiScreen = Clickable:extend{
	new = function(self, position, size)
		assert(type(position) == "table" and type(size) == "table", "Expected table & table", 3)
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		assert(type(self._x) == "number" and type(self._y) == "number", "Expected 2 numbers as position!", 3)
		assert(type(self._width) == "number" and type(self._height) == "number", "Expected 2 numbers as size!", 3)
		self._screens = {}
	end,
	
	getNewScreen = function(self, name)
		local new_screen = Screen({self._x, self._y}, {self._width, self._height})
		if name then
			assert(type(name) == "string", "Screen name must be string!", 2)
			self:addScreen(name, new_screen)
		end
		return new_screen
	end,
	
	addScreen = function(self, name, screen)
		assert(type(name) == "string" and Class.isA(screen, Screen), "Expected string & qua.ui.screen!", 2)
		assert(self._screens[name] == nil, "This multiscreen already has a screen called '" .. name .. "'!", 2)
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
		end
	end,
	
	draw = function(self, monitor)
		local screen = self:getCurrentScreen()
		if screen then
			screen:draw(monitor)
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
return MultiScreen
