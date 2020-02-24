-- IMPORT
local Drawable = require "qua.ui.drawable"
local AT = require "qua.tools.array"
local CT = require "qua.tools.color"


-- IMPLEMENTATION
local Image = Drawable:extend{	
	new = function(self, pos, size)
		self._pos = pos
		self._size = size
		self:clear()
	end,
	
	clear = function(self)
		-- 1D arrays!
		self._bgcol = {}
		self._txcol = {}
		self._token = {}
	end,
	
	fromPaint = function(self, path)
		if fs.exists(path) and not fs.isDir(path) then
			self:clear()
			-- Read content
			local rows = {}
			local file = fs.open(path, "r")
			local line = file.readLine()
			while line do
				table.insert(rows, line)
				line = file.readLine()
			end
			file.close()
			-- Parse content
			local width, height = unpack(self._size)
			for y, row in pairs(rows) do
				if y > height then
					break
				end
				local x = 1
				for colorcode in row:gmatch(".") do
					if x > width then
						break
					end
					local index = AT.to1D(width, x, y)
					self._bgcol[index] = CT.decode(colorcode)
					x = x + 1
				end
			end
		else
			error("File not found.", 2)
		end
	end,
	
	setLayer = function(self, layer, data)
		if layer ~= "bgcol" and layer ~= "txcol" and layer ~= "chars" then
			error("Undefined layer: Only 'bgcol', 'txcol' or 'chars'", 2)
		end
		local arr = self:convertMultiline(data)
		if layer ~= "chars" then
			for index, colorcode in pairs(arr) do
				arr[index] = CT.decode(colorcode)
			end
		end
		self._layers[name] = arr
	end
	
	convertMultiline = function(self, multiline)
		if type(multiline) ~= "string" then
			error("Expected string.", 2)
		end
		local result = {}
		local width, height = unpack(self._size)
		local y = 1
		for row in multiline:gmatch("(.-)\n") do
			if y > height then
				break
			end
			local x = 1
			for symbol in row:gmatch(".") do
				if x > width then
					break
				end
				local index = AT.to1D(width, x, y)
				result[index] = symbol
				x = x + 1
			end
			y = y + 1
		end
		return result
	end
	
	draw = function(self, monitor)
		local width = self._size[1]
		local pos_x, pos_y = unpack(self._pos)
		for index, bgcol in pairs(self._bgcol) do
			local token = self._token[index] or " "
			local txcol = self._txcol[index]
			local x, y = AT.from1D(width, index)
			monitor.setCursorPos(
				x + (pos_x - 1),
				y + (pos_y - 1)
			)
			monitor.setBackgroundColor(bgcol)
			if txcol then
				monitor.setTextColor(txcol)
			end
			monitor.write(token)
		end
	end
}


-- EXPORT
return Image