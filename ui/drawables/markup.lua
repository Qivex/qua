-- IMPORT
local assert = require "qua.core.assert"
local Drawable = require "qua.ui.drawable"
local Color = require "qua.cc.color"


-- CONSTANTS
local CODE_SYMBOL = "&"
local CODE_SEQUENCE = "<AND>"


-- IMPLEMENTATION
local Markup = Drawable:extend{
	new = function(self, text, position)
		self:setText(text)
		self:setPos(position)
	end,
	
	setText = function(self, text)
		assert(type(text) == "string", "Expected string!", 2)
		self._text = text
	end,
	
	getText = function(self)
		return self._text
	end,
	
	setPos = function(self, position)
		assert(type(position) == "table", "Expected table!", 2)
		self._pos_x, self._pos_y = unpack(position)
		assert(type(self._pos_x) == "number" and type(self._pos_y) == "number", "Expected 2 numbers as position!", 2)
	end,
	
	getPos = function(self)
		return self._pos_x, self._pos_y
	end,
	
	draw = function(self, monitor)
		monitor.setCursorPos(self._pos_x, self._pos_y)
		local script = "0f" .. self._text .. CODE_SYMBOL	-- Workaround for greedy/lazy matching
		for codeA, codeB, text in script:gmatch("(%w)(%w)(.-)" .. CODE_SYMBOL) do
			-- Translate encoded info
			local textcolor = Color.fromHex(codeA:lower())
			local backcolor = Color.fromHex(codeB:lower())
			text = text:gsub(CODE_SEQUENCE, CODE_SYMBOL)
			-- Write text
			monitor.setTextColor(textcolor)
			monitor.setBackgroundColor(backcolor)
			monitor.write(text)
		end
	end
}


-- EXPORT
return Markup
