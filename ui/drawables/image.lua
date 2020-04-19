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
		local emptyPixel = {
			bgcol = 2^15,	-- black
			txcol = 0,		-- white
			symbol = ""
		}
		local pixels = {}
		for i=1, self._width * self._height do
			table.insert(pixels, emptyPixel)
		end
		self._pixels = pixels
	end,
	
	fromPaint = function(self, path)
		if fs.exists(path) and not fs.isDir(path) then
			self:clear()
			-- Read content
			local file = fs.open(path, "r")
			local content = file.readAll() .. "\n"
			file.close()
			-- Parse content
			self._pixels = convertMultiline(content)
		else
			error("File not found.", 2)
		end
	end,
	
	convertMultiline = function(self, multiline)
		if type(multiline) ~= "string" then
			error("Expected string.", 2)
		end
		local result = {}
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
				local index = self._width * (y - 1) + x
				result[index].bgcol = CT.decode(symbol)
				x = x + 1
			end
			y = y + 1
		end
		return result
	end,
	
	draw = function(self, monitor)
		local x, y = 1, 1
		for _, pixel in pairs(self._pixels) do
			if x = self._width then
				x = 1
				y = y + 1
			else
				x = x + 1
			end
			monitor.setCursorPos(
				x + (self._x - 1),
				y + (self._y - 1)
			)
			monitor.setBackgroundColor(pixel.bgcol)
			monitor.setTextColor(pixel.txcol)
			monitor.write(pixel.symbol)
		end
	end
}


-- EXPORT
return Image