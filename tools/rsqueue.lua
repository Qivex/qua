-- IMPORT
local Class = require "qua.core.class"


-- IMPLEMENTATION
local RedstoneQueue = Class:extend{
	new = function(self)
		self._queue = {}
	end,
	
	add = function(self, side, output)
		for valid in pairs({"front", "back", "top", "bottom", "left", "right"}) do
			if side == valid then
				table.insert(self._queue, {side, output})
				return
			end
		end
		error("Invalid side.", 2)
	end,
	
	execNext = function(self)
		local action = table.remove(self._queue)
		if action then
			local side, output = unpack(action)
			if type(output) == "boolean" then
				rs.setOutput(side, output)
			elseif type(output) == "number" then
				rs.setBundledOutput(side, output)
			end
		end
		return (#self._queue >= 1)
	end
}


-- EXPORT
return RedstoneQueue
