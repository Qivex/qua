-- IMPORT
local Drawable = require "qua.ui.drawable"
local AT = require "qua.tools.array"


-- IMPLEMENTATION
local validateColor = function(color)
	if type(color) ~= "number" then
		error("Expected number", 3)
	end
	if color < 0 then
		error("Colour out of range", 3)
	end
end

local Window = Drawable:extend{
	new = function(self, position, size)
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		-- Init
		self._pixels = {}
		self._cursor = {
			x = 1,
			y = 1,
			color = colors.white,
			backcolor = colors.black
		}
	end,
	
	getFakeMonitor = function(self)
		-- Wrapped monitor is called with dot, but access to "self" required
		-- Solved like in https://www.lua.org/pil/16.4.html
		return {	-- Functions behave like term-API
			write = function(text)
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
					local x, y = self._cursor.x, self._cursor.y
					-- Only draw inside window
					if 0 < x and x <= self._width and 0 < y and y <= self._height then
						local pixel = {
							text = char,
							color = self._cursor.color,
							backcolor = self._cursor.backcolor
						}
						local index = AT.to1D(self._width, x, y)
						self._pixels[index] = pixel
					end
					self._cursor.x = x + 1
				end
			end,
			
			clear = function()
				for i=1, self._width * self._height do
					self._pixels[i] = {
						text = " ",
						color = self._cursor.color,
						backcolor = self._cursor.backcolor
					}
				end
			end,
			
			clearLine = function()
				local y = self._cursor.y
				for i=(y-1) * self._width + 1, y * self._width do
					self._pixels[i] = {
						text = " ",
						color = self._cursor.color,
						backcolor = self._cursor.backcolor
					}
				end
			end,
			
			getCursorPos = function()
				return self._cursor.x, self._cursor.y
			end,
			
			setCursorPos = function(x, y)
				if type(x) == "number" and type(y) == "number" then
					self._cursor.x = x
					self._cursor.y = y
				else
					error("Expected number, number", 2)
				end
			end,
			
			getSize = function()
				return self._width, self._height
			end,
			
			setTextColor = function(color)
				validateColor(color)
				self._cursor.color = color
			end,
			
			setBackgroundColor = function(color)
				validateColor(color)
				self._cursor.backcolor = color
			end
		}
	end,
	
	draw = function(self, monitor)
		for index, pixel in pairs(self._pixels) do
			AT.from1D(self._width, index)
			monitor.setCursorPos(
				x + (self._x - 1),
				y + (self._y - 1)
			)
			monitor.setTextColor(pixel.color)
			monitor.setBackgroundColor(pixel.backcolor)
			monitor.write(pixel.text)
		end
	end
}


-- EXPORT
return Window