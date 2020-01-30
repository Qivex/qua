--[[
Qua-API for Lycodon
File:	qua/core/class.lua
By:		Qivex

Inspired by:
https://moonscript.org/reference/#the-language/object-oriented-programming
]]

-- TODO: Clone, Metaevents


-- Implementations:

local constructor_wrapper = function(class, ...)
	local instance = {}
	-- Redirect undefined lookups into prototype
	setmetatable(instance, class.__proto)
	-- Call user-implemented constructor on creation
	if type(instance.new) == "function" then
		instance:new(...)
	end
	return instance
end


local extend = function(class, extension)
	if type(extension) ~= "table" then
		error("Class extension must be a table, was " .. type(extension) .. ".", 2)
	end
	local subclass = {
		__proto = extension,
		__parent = class
	}
	subclass.__proto.__class = subclass
	-- Proto-Chain
	subclass.__proto.__index = subclass.__proto
	setmetatable(subclass.__proto, class.__proto)
	-- Class-Chain
	setmetatable(subclass, {
		-- "__index = class.__proto" would chain along protos, not classes => own func
		__index = function(class, key)
			local val = rawget(class.__proto, key)
			if val == nil then
				local parent = rawget(class, "__parent")
				if parent then
					return parent[key]
				end
			else
				return val
			end
		end,
		__call = constructor_wrapper
	})
	return subclass
end


-- Export:

local Class = {}
Class.__proto = {}

Class.__proto.__name = "qua.core.class"
Class.__proto.__class = Class
Class.__proto.__index = Class.__proto
Class.__proto.extend = extend

setmetatable(Class, {
	__index = Class.__proto,
	__call = constructor_wrapper
})

return Class
