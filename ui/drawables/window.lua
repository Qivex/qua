-- IMPORT
local Drawable = require "qua.ui.drawable"


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
	new = function(self, pos, size)
		self._pos_x = pos[1]
		self._pos_y = pos[2]
		self._width = size[1]
		self._height = size[2]
		-- Init
		self._pixels = {}
		self._cursor = {
			pos_x = 1,
			pos_y = 1,
			col = colors.white,
			bg = colors.black
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
					local x, y = self._cursor.pos_x, self._cursor.pos_y
					-- Only draw inside window
					if 0 < x and x <= self._width and 0 < y and y <= self._height then
						local pixel = {
							text = char,
							col = self._cursor.col,
							bg = self._cursor.bg
						}
						-- 1D-array (avoid nesting)
						self._pixels[(y-1) * self._width + x] = pixel	
					end
					self._cursor.pos_x = x + 1
				end
			end,
			
			clear = function()
				for i=1, self._width * self._height do
					self._pixels[i] = {
						text = " ",
						col = self._cursor.col,
						bg = self._cursor.bg
					}
				end
			end,
			
			clearLine = function()
				local y = self._cursor.pos_y
				for i=(y-1) * self._width + 1, y * self._width do
					self._pixels[i] = {
						text = " ",
						col = self._cursor.col,
						bg = self._cursor.bg
					}
				end
			end,
			
			getCursorPos = function()
				return self._cursor.pos_x, self._cursor.pos_y
			end,
			
			setCursorPos = function(x, y)
				if type(x) == "number" and type(y) == "number" then
					self._cursor.pos_x = x
					self._cursor.pos_y = y
				else
					error("Expected number, number", 2)
				end
			end,
			
			getSize = function()
				return self._width, self._height
			end,
			
			setTextColor = function(color)
				validateColor(color)
				self._cursor.col = color
			end,
			
			setBackgroundColor = function(color)
				validateColor(color)
				self._cursor.bg = color
			end
		}
	end,
	
	draw = function(self, monitor)
		for index, pixel in pairs(self._pixels) do
			local pixel_y = math.ceil(index / self._width)
			local pixel_x = index - (pixel_y - 1) * self._width
			local x = pixel_x + (self._pos_x - 1)
			local y = pixel_y + (self._pos_y - 1)
			monitor.setCursorPos(x, y)
			monitor.setTextColor(pixel.col)
			monitor.setBackgroundColor(pixel.bg)
			monitor.write(pixel.text)
		end
	end
}


-- EXPORT
return Window