
local num2bin = function(num, endian)
	local binary = ""
	-- Highest exponent
	local exp = 0
	while 2^(exp+1) <= num do
		exp = exp + 1
	end
	-- Find binary summands
	local next_bit
	while exp >= 0 do
		local div = 2^exp
		if num / div >= 1 then
			next_bit = "1"
			num = num - div
		else
			next_bit = "0"
		end
		if endian == "big" then
			binary = binary .. next_bit
		elseif endian == "little" then
			binary = next_bit .. binary
		end
		exp = exp - 1
	end
	return binary
end


local hex2bits = function(hex)
	local output = {}
	for byte in hex:gmatch("..") do
		local binary = num2bin(tonumber(byte, 16), "big")
		-- tonumber() crops starting zeros
		-- Extend to 8 chars (because bytewise shift!)
		binary = string.rep("0", 8 - binary:len()) .. binary
		table.insert(output, binary)
	end
	return table.concat(output, "")
end


return {
	num2bin = num2bin,
	hex2bits = hex2bits
}
