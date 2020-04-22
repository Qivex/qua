-- IMPLEMENTATION
local assert = function(bool, message, level)
	message = tostring(message)
	level = tonumber(level)
	if not level or level == 0 then
		level = -1
	end
	if not bool then
		error(message, level + 1)
	end
end


-- EXPORT
return assert
