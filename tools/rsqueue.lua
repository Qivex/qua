-- IMPORT
local assert = require "qua.core.assert"
local Class = require "qua.core.class"
local Side = require "qua.cc.side"


-- CONSTANTS
local COOLDOWN = 0.5


-- IMPLEMENTATION
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
		assert(Side.isValidSide(side), "Invalid side.", 2)
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
