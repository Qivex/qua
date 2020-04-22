-- IMPORT
local assert = require "qua.core.assert"
local Drawable = require "qua.ui.drawable"
local Color = require "qua.cc.color"


-- IMPLEMENTATION
local Image = Drawable:extend{	
	new = function(self, position, size)
		assert(type(position) == "table" and type(size) == "table", "Expected table & table", 3)
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		assert(type(self._x) == "number" and type(self._y) == "number", "Expected 2 numbers as position!", 3)
		assert(type(self._width) == "number" and type(self._height) == "number", "Expected 2 numbers as size!", 3)
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
		assert(type(path) == "string", "Expected string!", 2)
		assert(fs.exists(path) and not fs.isDir(path), "File not found!", 2)
		self:clear()
		-- Read content
		local file = fs.open(path, "r")
		local content = file.readAll() .. "\n"
		file.close()
		-- Parse content
		self:fromMultiline(content)
	end,
	
	fromMultiline = function(self, multiline)
		assert(type(multiline) == "string", "Expected string.", 2)
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
					bgcol = Color.fromHex(symbol),
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
