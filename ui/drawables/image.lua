-- IMPORT
local Drawable = require "qua.ui.drawable"
local AT = require "qua.tools.array"
local CT = require "qua.tools.color"


-- IMPLEMENTATION
local Image = Drawable:extend{	
	new = function(self, position, size)
		--[[
		if type(position) ~= "table" or type(size) ~= "table" then
			error("Expected {x,y}, {width, height}", 2)
		end
		]]
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		self:clear()
	end,
	
	clear = function(self)
		self._pixels = {}
		for x=1, self._width do
			self._pixels[x] = {}
			for y=1, self._height do
				self._pixels[x][y] = {}
			end
		end
	end,
	
	fromPaint = function(self, path)
		if fs.exists(path) and not fs.isDir(path) then
			self:clear()
			-- Read content
			local file = fs.open(path, "r")
			local content = file.readAll() .. "\n"
			file.close()
			-- Parse content
			self:convertMultiline(content)
		else
			error("File not found.", 2)
		end
	end,
	
	convertMultiline = function(self, multiline)
		if type(multiline) ~= "string" then
			error("Expected string.", 2)
		end
		local index = 1
		-- Parse text
		local y = 1
		for row in multiline:gmatch("(.-)\n") do
			if y > self._height then
				break
			end
			local x = 1
			for symbol in row:gmatch(".") do
				if x > self._width then
					break
				end
				self._pixels[x][y] = {
					bgcol = CT.decode(symbol),
					symbol = " "
				}
				x = x + 1
			end
			y = y + 1
		end
	end,
	
	draw = function(self, monitor)
		for x, column in pairs(self._pixels) do
			for y, pixel in pairs(column) do
				if pixel.bgcol then
					monitor.setCursorPos(
						x + (self._x - 1),
						y + (self._y - 1)
					)
					monitor.setBackgroundColor(pixel.bgcol or colors.black)
					monitor.setTextColor(pixel.txcol or colors.white)
					monitor.write(pixel.symbol or "")
				end
			end
		end
	end
}


-- EXPORT
return Image