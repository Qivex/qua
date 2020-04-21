-- IMPORT
local Class = require "qua.core.class"


-- CONSTANTS
local EXAMPLE_USAGE = 'Example usage:\nfunction example(...)\n  local expected = {"string", "number"}\n  local name, size = fromArgs({...}, expected)\nend'


-- IMPLEMENTATION
local buildErrorMessage = function(index, expected, received)
	local msg = "Expected " .. expected .. " as arg #" .. index .. " - was " .. type(received)
end

local fromArgs = function(args, expected_types)
	if type(args) ~= "table" or type(expected_types) ~= "table" then
		error(EXAMPLE_USAGE, 2)
	end
	
	local errors = {}
	for index, expected in pairs(expected_types) do
		
		local received = args[index]
		if type(expected) == "string" then		-- for string types
			if not type(received) == expected then
				table.insert(errors, buildErrorMessage(index, expected, received))
			end
		elseif type(expected) == "table" then	-- for classes
			if not (type(received) == "table" and received.isA and received:isA(Screen)) then
		else
			error("Only string typenames or Classes allowed!", 2)
		end
		
		
	end
	
	if #errors > 0 then
		error(table.concat(errors, "\n"), 3)
	end
	return args
end


-- EXPORT
return fromArgs
