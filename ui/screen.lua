-- IMPORT
local Class = require "qua.core.class"
local Window = require "qua.ui.drawable.window"


-- IMPLEMENTATION
local Screen = Class:extend{
	new = function(self)
		self._static = {}
		self._dynamic = {}
	end,
	
	setDisplay = function(self, display)
		self._display = display
		-- No shared Screens between Displays - new background on change
		local static_window = Window({1,1}, {display:getSize()})
		self:addDynamic(static_window)
		self._background = static_window:getFakeMonitor()
	end,
	
	addStatic = function(self, drawable)
		table.insert(self._static, drawable)
	end,
	
	addDynamic = function(self, drawable)
		table.insert(self._dynamic, drawable)
	end,
	
	render = function(self)
		if not self._display then
			error("Can't render screen without display!", 2)
		end
		-- Draw newly added statics onto background
		for _, drawable in pairs(self._static) do
			drawable:draw(self._background)
		end
		self._static = {}	-- ... only once
		-- Call all dynamic draw-functions
		local monitor = self._display:getMonitor()
		for _, drawable in pairs(self._dynamic) do
			drawable:draw(monitor)
		end
	end
}


-- EXPORT
return Screen
