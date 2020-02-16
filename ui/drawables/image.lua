-- IMPORT
local Drawable = require "qua.ui.drawable"
local AT = require "qua.tools.array"
local CT = require "qua.tools.color"


-- IMPLEMENTATION
local Image = Drawable:extend{	
	new = function(self, pos, size)
		self._pos = pos
		self._size = size
		-- 1D arrays!
		self._bgcol = {}
		self._txcol = {}
		self._token = {}
	end,
	
	fromPaint = function(self, path)
		if fs.exists(path) and not fs.isDir(path) then
			self._bgcol, self._txcol, self._token = {}, {}, {}
			-- Read content
			local file = fs.open(path, "r")
			local content = file.readAll() .. "\n"
			file.close()
			-- Parse content
			local rows = {}
			for row in content:gmatch("(.*)\n") do
				table.insert(rows, row)
			end
			local width = math.max(unpack(rows))
			for y, row in pairs(rows) do
				local x = 1
				for colorcode in row:gmatch(".") do
					local index = AT.to1D(width, x, y)
					self._bgcol[index] = CT.decode(colorcode)
					x = x + 1
				end
			end
		else
			error("File not found.", 2)
		end
	end,
		
	draw = function(self, monitor)	
		local pos_x, pos_y = unpack(self._pos)
		for index, bgcol in pairs(self._bgcol) do
			local token = self._token[index] or " "
			local txcol = self._txcol[index]
			local x, y = AT.from1D(index)
			monitor.setCursorPos(pos_x + x, pos_y + y)
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