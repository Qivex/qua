-- IMPORT
local Class = require "qua.core.class"
local Window = require "qua.ui.drawables.window"


-- IMPLEMENTATION
local Screen = Class:extend{
	new = function(self, pos, size)	-- TODO: Support for not-fullscreen
		self._pos = pos
		self._size = size
		self._static = {}
		self._dynamic = {}
	end,
	
	addStatic = function(self, drawable)
		table.insert(self._static, drawable)
	end,
	
	addDynamic = function(self, drawable)
		table.insert(self._dynamic, drawable)
	end,
	
	draw = function(self, monitor)
		-- Initialize windows
		if #self._dynamic == 0 then
			self._back_window = Window({1, 1}, self._size)
			self._main_window = Window(self._pos, self._size)
			self._background = self._back_window:getFakeMonitor()
			self._foreground = self._main_window:getFakeMonitor()
			-- Draw background first
			self:addDynamic(self._back_window)
		end
		-- Draw newly added statics onto background
		for _, drawable in pairs(self._static) do
			drawable:draw(self._background)
		end
		self._static = {}	-- ... only once
		-- Call all dynamic draw-functions
		for _, drawable in pairs(self._dynamic) do
			drawable:draw(self._foreground)
		end
		-- Draw window
		self._main_window:draw(monitor)
	end,
	
	setDisplay = function(self, display)
		self._display = display
		-- Fullscreen (soon redundant)
		self._pos = {1, 1}
		self._size = {display:getMonitor().getSize()}
	end,
	
	render = function(self)
		if not self._display then
			error("Can't render screen without display!", 2)
		end
		self:draw(self._display:getMonitor())
	end,
	
	click = function(self, x, y)
		for _, drawable in pairs(self._dynamic) do
			-- if clickable
				-- drawable:click(x, y) -- only drawable itself can know when it should react
		end
	end
}


-- EXPORT
return Screen
