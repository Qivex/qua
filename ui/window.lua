-- IMPORT
local assert = require "qua.core.assert"
local Class = require "qua.core.class"
local Drawable = require "qua.ui.drawable"
local Color = require "qua.cc.color"


-- IMPLEMENTATION
local validateColor = function(color)
	assert(type(color) == "number", "Expected number", 3)
	assert(Color.isValidColor(color), "Color out of range", 3)
end

local Cursor = Class:extend{
	new = function(self)
		self._x = 1
		self._y = 1
		self._textcolor = colors.white
		self._backcolor = colors.black
	end,
	
	getPos = function(self)
		return self._x, self._y
	end,
	
	setPos = function(self, x, y)
		self._x = x
		self._y = y
	end,
	
	setTextCol = function(self, color)
		self._textcolor = color
	end,
	
	setBackCol = function(self, color)
		self._backcolor = color
	end,
	
	write = function(self, pixelarray, char)
		pixelarray[self._y][self._x] = {
			ch = char,
			fg = self._textcolor,
			bg = self._backcolor
		}
	end
}

local Window = Drawable:extend{
	new = function(self, position, size)
		assert(type(position) == "table" and type(size) == "table", "Expected table & table", 3)
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		assert(type(self._x) == "number" and type(self._y) == "number", "Expected 2 numbers as position!", 3)
		assert(type(self._width) == "number" and type(self._height) == "number", "Expected 2 numbers as size!", 3)
		-- Init
		self._cursor = Cursor()
		self._pixels = {}
		for y=1, self._height do
			self._pixels[y] = {}
			for x=1, self._width do
				self._cursor:setPos(x, y)
				self._cursor:write(self._pixels, " ")
			end
		end
	end,
	
	getFakeMonitor = function(self)
		-- Wrapped monitor is called with dot, but access to "self" required
		-- Solved like in https://www.lua.org/pil/16.4.html
		local fm = {}
		
		-- Functions mimic term-API to allow for term.redirect()
		fm.write = function(text)
			-- Prepare input to mimic term.write()
			if type(text) == "number" then
				text = tostring(text)
				-- Somehow term.write() adds ".0" to ints
				if not text:find("%.") then
					text = text .. ".0"
				end
			elseif type(text) == "string" then
				text = text:gsub("\t", " ")		-- Tab recognized
				text = text:gsub("[\r\n]", "?")	-- CR & LF not
			else
				return
			end
			-- Iterate through chars
			for char in text:gmatch(".") do
				local x, y = self._cursor:getPos()
				-- Only draw inside window
				if 0 < x and x <= self._width and 0 < y and y <= self._height then
					self._cursor:write(self._pixels, char)
				end
				self._cursor:setPos(x+1, y)
			end
		end
		
		fm.clear = function()
			for y=1, self._height do
				for x=1, self._width do
					self._cursor:setPos(x, y)
					self._cursor:write(self._pixels, " ")
				end
			end
		end
		
		fm.clearLine = function()
			local _, y = self._cursor:getPos()
			for x=1, self._width do
				self._cursor:setPos(x, y)
				self._cursor:write(self._pixels, " ")
			end
		end
		
		fm.getCursorPos = function()
			return self._cursor:getPos()
		end
		
		fm.setCursorPos = function(x, y)
			assert(type(x) == "number" and type(y) == "number", "Expected number, number", 2)
			self._cursor:setPos(math.floor(x), math.floor(y))
		end
		
		fm.setCursorBlink = function(bool)
			assert(type(bool) == "boolean", "Expected boolean", 2)
			-- Way to complicated to implement for multiple windows,
			-- so it does nothing for now.
		end
		
		fm.isColor = function()
			return true
		end
		
		fm.getSize = function()
			return self._width, self._height
		end
		
		fm.scroll = function(amount)
			assert(type(amount) == "number", "Expected number", 2)
			-- Shortcut
			if math.abs(amount) >= self._height then
				fm.clear()
				return
			end
			-- Actual scrolling
			if amount >= 1 then
				self._cursor:setPos(1, self._height)
				for i=1, amount do
					table.remove(self._pixels, 1)
					table.insert(self._pixels, {})
					fm.clearLine()
				end
			elseif amount <= -1 then
				self._cursor:setPos(1, 1)
				for i=1, -amount do
					table.remove(self._pixels)
					table.insert(self._pixels, 1, {})
					fm.clearLine()
				end
			end
		end
		
		fm.setTextColor = function(color)
			validateColor(color)
			self._cursor:setTextCol(color)
		end
		
		fm.setBackgroundColor = function(color)
			validateColor(color)
			self._cursor:setBackCol(color)
		end
		
		fm.setTextScale = function(scale)
			assert(type(scale) == "number" and scale >= 0.5 and scale <= 5, "Expected number in range 0.5-5!", 2)
			-- Empty function, so accidental call doesn't raise an Error
		end
		
		-- Aliases
		fm.isColour = fm.isColor
		fm.setTextColour = fm.setTextColor
		fm.setBackgroundColour = fm.setBackgroundColor
		
		return fm
	end,
	
	draw = function(self, monitor)
		for y, row in pairs(self._pixels) do
			for x, pixel in pairs(row) do
				monitor.setCursorPos(
					x + (self._x - 1),
					y + (self._y - 1)
				)
				monitor.setTextColor(pixel.fg)
				monitor.setBackgroundColor(pixel.bg)
				monitor.write(pixel.ch)
			end
		end
	end
}


-- EXPORT
return Window
