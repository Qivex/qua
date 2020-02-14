-- IMPORT
local ByteArray = require "qua.core.bytearray"
local BitArray = require "qua.core.bitarray"
local deflate = require "qua.decode.deflate"


-- IMPLEMENTATION
local decode = function(input)
	local header = BitArray(true)
	header:fromHex(input:sub(1, 4))
	-- Analyze header
	local method = header:nextAsInt(4, true)
	local window = header:nextAsInt(4, true)
	header:nextAsInt(5, true)	-- check-bytes
	local dict = header:nextAsInt(1)
	if method ~= 8 then
		error("Undefined compression method '" .. method .. "', only deflate (8) allowed.", 2)
	end
	if window > 7 then
		error("Window size '" .. 2^(window+8) .. "' out of range, only 256-32768 allowed.", 2)
	end
	if tonumber(input:sub(1, 4), 16) % 31 ~= 0 then
		error("Checksum validation for zlib header failed.", 2)
	end
	local start = 5
	if dict == 1 then
		start = 13
	end
	-- Decode data using deflate
	local output = deflate.decode(input:sub(start, -9))
	-- Validate output using Adler32
	local checkbytes = ByteArray()
	checkbytes:fromBytes(output)
	local s1, s2 = 1, 0
	for i=1, #output do
		s1 = (s1 + checkbytes:next()[1]) % 65521
		s2 = (s2 + s1) % 65521
	end
	if tonumber(input:sub(-8), 16) ~= (65536 * s2 + s1) then
		error("Adler32 checksum validation for decoded data failed.", 2)
	end
	return output
end


-- EXPORT
return {
	decode = decode
}