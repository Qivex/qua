-- IMPORT
local Clickable = require "qua.ui.clickable"
local Window = require "qua.ui.drawables.window"


-- IMPLEMENTATION
local Screen = Clickable:extend{
	new = function(self, position, size)
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		-- Hold all elements to be drawn
		self._statics = {}
		self._dynamics = {}
		self._clickables = {}
		-- Initialize windows
		self._dynamic_window = Window({self._x, self._y}, {self._width, self._height})
		self._static_window = Window({1, 1}, {self._width, self._height})
		-- Everything static equals first layer of dynamic window
		self:addDynamic(self._static_window)
	end,
	
	getSize = function(self)
		return self._width, self._height
	end,
	
	addStatic = function(self, drawable)
		table.insert(self._statics, drawable)
		if drawable:isA(Clickable) then
			table.insert(self._clickables, drawable)
		end
	end,
	
	addDynamic = function(self, drawable)
		table.insert(self._dynamics, drawable)
		if drawable:isA(Clickable) then
			table.insert(self._clickables, drawable)
		end
	end,
	
	draw = function(self, monitor)
		local foreground = self._dynamic_window:getFakeMonitor()
		local background = self._static_window:getFakeMonitor()
		-- Draw newly added statics onto background
		for _, drawable in pairs(self._statics) do
			drawable:draw(background)
		end
		self._statics = {}	-- ... only once
		-- Call all dynamic draw-functions
		foreground.setBackgroundColor(colors.black)
		foreground.clear()
		for _, drawable in pairs(self._dynamics) do
			drawable:draw(foreground)
		end
		-- Draw dynamic window
		self._dynamic_window:draw(monitor)
	end,
	
	click = function(self, x, y)
		if x >= self._x and x < (self._x + self._width) and y >= self._y and y < (self._y + self._height) then
			-- Notify all Clickables (only they know their click-area)
			for _, clickable in pairs(self._clickables) do
				clickable:click(x - self._x + 1, y - self._y + 1)
			end
		end
	end
}


-- EXPORT
return Screen
