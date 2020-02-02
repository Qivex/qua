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
		self._background = Window({1,1}, {display.getSize()})
		self._foreground = Window({1,1}, {display.getSize()})
		self._foreground:addDynamic(self._background)
	end,
	
	addStatic = function(self, drawable)
		table.insert(self._static, drawable)
	end,
	
	addDynamic = function(self, drawable)
		table.insert(self._dynamic, drawable)
	end,
	
	render = function(self)
		if not self._display then
			error("Can't draw screen without display!", 2)
		end
		-- Draw newly added statics onto background
		local bg_mon = self._background:getFakeMonitor()
		for _, drawable in pairs(self._static) do
			drawable:draw(bg_mon)
		end
		self._static = {}	-- ... only once
		-- Call all dynamic draw-functions
		local fg_mon = self._foreground:getFakeMonitor()
		for _, drawable in pairs(self._dynamic) do
			drawable:draw(fg_mon)
		end
		-- TODO: Draw finished window onto display
	end
}


-- EXPORT unfinished
-- return Screen
