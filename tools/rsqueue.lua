-- IMPORT
local Class = require "qua.core.class"


-- CONSTANTS
local VALID_SIDES = {"front", "back", "top", "bottom", "left", "right"}
local COOLDOWN = 0.55


-- IMPLEMENTATION
local isValidSide = function(side)
	for _, valid in pairs(VALID_SIDES) do
		if side == valid then
			return true
		end
	end
	return false
end

local RedstoneQueue = Class:extend{
	new = function(self)
		self._queue = {}
		self._cooldown = nil
	end,
	
	cooldownTimer = function(self)
		return self._cooldown
	end,
	
	hasMore = function(self)
		return #self._queue > 0
	end,
	
	add = function(self, side, output)
		if not isValidSide(side) then
			error("Invalid side.", 2)
		end
		table.insert(self._queue, {side, output})
		self:_startCooldownTimer()
	end,
	
	execDelayed = function(self)
		local action = table.remove(self._queue, 1)
		if action then
			local side, output = unpack(action)
			if type(output) == "boolean" then
				rs.setOutput(side, output)
			elseif type(output) == "number" then
				rs.setBundledOutput(side, output)
			end
			self._cooldown = nil
			if self:hasMore() then
				self:_startCooldownTimer()
			end
		end
	end,
	
	_startCooldownTimer = function(self)
		-- Don't start new cooldown if already tracked
		self._cooldown = self._cooldown or os.startTimer(COOLDOWN)
	end
}


-- EXPORT
return RedstoneQueue
