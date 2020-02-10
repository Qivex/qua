-- IMPORT
local Class = require "qua.core.class"
local Window = require "qua.ui.drawables.window"


-- IMPLEMENTATION
local Screen = Class:extend{
	new = function(self, pos, size)	-- TODO: Support for not-fullscreen
		self._pos = pos,
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
		-- Initialize background
		if not self._background then
			local bg_window = Window(self._pos, self._size)
			self._background = bg_window:getFakeMonitor()
			self:addDynamic(bg_window)	-- Draw background first
		end
		-- Draw newly added statics onto background
		for _, drawable in pairs(self._static) do
			drawable:draw(self._background)
		end
		self._static = {}	-- ... only once
		-- Call all dynamic draw-functions
		for _, drawable in pairs(self._dynamic) do
			drawable:draw(monitor)
		end
	end,
	
	setDisplay = function(self, display)
		self._display = display
		-- Fullscreen
		self._pos = {1, 1}
		self._size = {monitor.getSize()}
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
