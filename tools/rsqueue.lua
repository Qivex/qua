-- IMPORT
local Class = require "qua.core.class"


-- CONSTANTS
local VALID_SIDES = {"front", "back", "top", "bottom", "left", "right"}
local COOLDOWN = 0.5


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
		if self:cooldownTimer() or self:hasMore() then
			-- Delay (last too close or wrong order)
			table.insert(self._queue, {side, output})
		else
			-- Execute
			self:_exec(side, output)
			self:_startCooldownTimer()
		end
	end,
	
	execDelayed = function(self)
		local action = table.remove(self._queue, 1)
		if action then
			self:exec(unpack(action))
			if self:hasMore() then
				self:_startCooldownTimer()
			else
				self._cooldown = nil
			end
		end
	end,
	
	_exec = function(self, side, output)
		if type(output) == "boolean" then
			rs.setOutput(side, output)
		elseif type(output) == "number" then
			rs.setBundledOutput(side, output)
		end
	end,
	
	_startCooldownTimer = function(self)
		-- Don't start new cooldown if already tracked
		self._cooldown = self._cooldown or os.startTimer(COOLDOWN)
	end
}


-- EXPORT
return RedstoneQueue
