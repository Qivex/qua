-- IMPORT
local Drawable = require "qua.ui.drawable"
local Window = require "qua.ui.drawables.window"


-- IMPLEMENTATION
local Screen = Drawable:extend{
	_clickable = true,
	
	new = function(self, pos, size)
		self._pos = pos
		self._size = size
		self._static = {}
		self._dynamic = {}
		self._clickable = {}
		-- Initialize windows
		self._back_window = Window({1, 1}, self._size)
		self._main_window = Window(self._pos, self._size)
		self._background = self._back_window:getFakeMonitor()
		self._foreground = self._main_window:getFakeMonitor()
		self:addDynamic(self._back_window)
	end,
	
	getSize = function(self)
		return unpack(self._size)
	end,
	
	addStatic = function(self, drawable)
		table.insert(self._static, drawable)
		if drawable:isClickable() then
			table.insert(self._clickable, drawable)
		end
	end,
	
	addDynamic = function(self, drawable)
		table.insert(self._dynamic, drawable)
		if drawable:isClickable() then
			table.insert(self._clickable, drawable)
		end
	end,
	
	draw = function(self, monitor)
		-- Draw newly added statics onto background
		for _, drawable in pairs(self._static) do
			drawable:draw(self._background)
			-- add to clickables
		end
		self._static = {}	-- ... only once
		-- Call all dynamic draw-functions
		for _, drawable in pairs(self._dynamic) do
			drawable:draw(self._foreground)
		end
		-- Draw window
		self._main_window:draw(monitor)
	end,
	
	click = function(self, x, y)
		local w,h = self:getSize()
		local pos_x, pos_y = unpack(self._pos)
		if pos_x <= x and x < pos_x + w and pos_y <= y and y < pos_y + h then
			-- Notify all Clickables (only they know their click-area)
			for _, clickable in pairs(self._clickable) do
				clickable:click(x, y)
			end
		end
	end
}


-- EXPORT
return Screen
