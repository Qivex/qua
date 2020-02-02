-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local Window = Class:extend{
	new = function(self, pos, size)
		self._pos = pos
		self._size = size
		self._pixels = {}
		self._cursor = {
			pos = {1,1},
			col = {colors.white, colors.black}
		}
	end,
	
	getFakeMonitor = function(self)
		-- Wrapped monitor is called with dot, but access to "self" required
		-- Solved like in https://www.lua.org/pil/16.4.html
		return {
			write = function(text)
				self:_write(text)
			end,
			getCursorPos = function()
				return unpack(self._cursor.pos)
			end,
			setCursorPos = function(x, y)
				if type(x) == "number" and type(y) == "number" then
					self._cursor.pos = {x, y}
				else
					error("Expected number, number", 2)
				end
			end,
			getSize = function()
				return unpack(self._size)
			end,
			setTextColor = function(col)
				self:_setColor(1, col)
			end,
			setBackgroundColor = function(col)
				self:_setColor(2, col)
			end
		}
	end,
	
	draw = function(self, monitor)
		for index, pixel in pairs(self._pixels) do
			local pixel_x = index % self._size[1]
			local pixel_y = (index - pixel_x) / self._size[1] + 1
			local x = pixel_x + self._pos[1] - 1
			local y = pixel_y + self._pos[2] - 1
			monitor.setCursorPos(x, y)
			monitor.setTextColor(pixel.col)
			monitor.setBackgroundColor(pixel.bg)
			monitor.write(pixel.text)
		end
	end,
	
	_write = function(self, text)
		-- Prepare input to mimic term.write()
		if type(text) == "number" then
			text = tostring(text)
			-- Somehow term.write() adds ".0" to ints
			if not text:find("%.0$") then
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
			local x, y = unpack(self._cursor.pos)
			-- Can't draw outside of window
			if 0 < x and x <= self._size[1] and 0 < y and y <= self._size[2] then
				local pixel = {
					text = char
					col = self._cursor.col[1]
					bg = self._cursor.col[2]
				}
				self._pixels[(y-1) * self._size[1] + x] = pixel	-- 1D-array (avoid nesting)
			end
			self._cursor.pos[1] = x + 1
		end
	end,
	
	_setColor = function(self, i, color)
		if type(color) ~= "number" then
			error("Expected number", 2)
		end
		if color < 0 then
			error("Colour out of range", 2)
		end
		self._cursor.col[i] = color
	end
}


-- EXPORT
return Window