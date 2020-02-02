-- IMPLEMENTATION
local conf = _G["QUA_CONFIG"]
conf = {}

local set = function(key, value)
	conf[key] == value
end

local get = function(key)
	return conf[key]
end


-- EXPORT
return {
	set = set,
	get = get
}
