local BASE_URL = "https://raw.githubusercontent.com/Qivex/qua/master/"
local BASE_PATH = "apis/qua"

local files = {
	"/require",
	"/core/bitstream",
	"/core/class",
	"/core/config",
	"/core/shortcuts",
	"/decode/deflate",
	"/decode/huffman",
	"/math/convert",
	"/ui/display",
	"/ui/screen",
	"/ui/drawable/window"
}

for _, path in pairs(files) do
	local url = BASE_URL .. path .. ".lua"
	local path = BASE_PATH .. path
	local dir = path:match("^(.*)/.-$")
	if not fs.isDir(dir) then
		fs.makeDir(dir)
	end
	if fs.exists(path) then
		fs.delete(path)
	end
	http.request(url)
	local event, url, response = os.pullEvent()
	if event == "http_success" then
		local content = response.readAll()
		response.close()
		local file = fs.open(path, "w")
		file.write(content)
		file.close()
	else
		error("Failure: Not found or interrupted - try again.")
	end
end

local file = fs.open("startup", "a")
file.write("shell.run('apis/qua/require')")
file.close()
