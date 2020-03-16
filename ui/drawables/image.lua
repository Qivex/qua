-- IMPORT
local Drawable = require "qua.ui.drawable"
local AT = require "qua.tools.array"
local CT = require "qua.tools.color"


-- IMPLEMENTATION
local Image = Drawable:extend{	
	new = function(self, position, size)
		if type(position) ~= "table" or type(size) ~= "table" then
			error("Expected {x,y}, {width, height}", 2)
		end
		self._x, self._y = unpack(position)
		self._width, self._height = unpack(size)
		self:clear()
	end,
	
	clear = function(self)
		-- 1D arrays!
		self._layers = {
			bgcol = {},
			txcol = {},
			chars = {}
		}
	end,
	
	fromPaint = function(self, path)
		if fs.exists(path) and not fs.isDir(path) then
			self:clear()
			-- Read content
			local rows = {}
			local file = fs.open(path, "r")
			local content = file.readAll() .. "\n"
			file.close()
			-- Parse content
			self:setLayer("bgcol", content)
		else
			error("File not found.", 2)
		end
	end,
	
	setLayer = function(self, layer, data)
		if layer ~= "bgcol" and layer ~= "txcol" and layer ~= "chars" then
			error("Undefined layer: Only 'bgcol', 'txcol' or 'chars'", 2)
		end
		local pixels = self:convertMultiline(data)
		if layer ~= "chars" then
			local colors = {}
			for index, colorcode in pairs(pixels) do
				colors[index] = CT.decode(colorcode)
			end
			pixels = colors
		end
		self._layers[layer] = pixels
	end,
	
	convertMultiline = function(self, multiline)
		if type(multiline) ~= "string" then
			error("Expected string.", 2)
		end
		local result = {}
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
				local index = AT.to1D(self._width, x, y)
				result[index] = symbol
				x = x + 1
			end
			y = y + 1
		end
		return result
	end,
	
	draw = function(self, monitor)
		local bgcol = self._layers.bgcol
		local txcol = self._layers.txcol
		local chars = self._layers.chars
		-- Only draw on defined background (transparency!)
		for index in pairs(bgcol) do
			local x, y = AT.from1D(self._width, index)
			monitor.setCursorPos(
				x + (self._x - 1),
				y + (self._y - 1)
			)
			monitor.setBackgroundColor(bgcol[index] or colors.black)
			monitor.setTextColor(txcol[index] or colors.white)
			monitor.write(chars[index] or " ")
		end
	end
}


-- EXPORT
return Image