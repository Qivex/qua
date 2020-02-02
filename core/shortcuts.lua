-- IMPLEMENTATION
local fromArgs = function(args, defaults)
	local vars = {}
	local isNamed = #args == 1 and type(args[1]) == "table"
	local pos = 1
	for key, default_value in pairs(defaults) do
		if isNamed and args[1][key] then
			vars[key] = args[1][key]
		else
			vars[key] = args[pos] or default_value
		end
		pos = pos + 1
	end
	return vars
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
