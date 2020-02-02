-- IMPLEMENTATION
_G.QUA_CONFIG = {}

local set = function(key, value)
	_G.QUA_CONFIG[key] = value
end

local get = function(key)
	return _G.QUA_CONFIG[key]
end


-- EXPORT
return {
	set = set,
	get = get
}
