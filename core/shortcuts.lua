-- IMPLEMENTATION
local fromArgs = function(args, defaults)
	local vars = {}
	local pos = 1
	for name, default_value in pairs(defaults) do
		local argument = args[pos]
		if (#args == 1 and type(args[1]) == "table") then	-- assume "named" arguments
			argument = args[1][name]
		end
		vars[pos] = argument or default_value
		pos = pos + 1
	end
	return unpack(vars)
end

local isIn = function(value, array)
	if type(array) ~= "table" then
		error("Second parameter must be iterable.", 2)
	end
	for _, entry in pairs(array) do
        if (value == entry) then
            return true
        end
    end
    return false
end


-- EXPORT
return {
	fromArgs = fromArgs,
	isIn = isIn
}
