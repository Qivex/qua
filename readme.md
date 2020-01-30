# QUA

## Disclaimer
This project is in a very early stage, everything might be subject to change. Only use code shown here for basic testing.


## Info
`qua` is a Lua-API for the Minecraft modification "ComputerCraft" (hereafter referred to as "CC").
The API attempts to simplify the use of common elements (modules, OO, communication, GUI etc.) by wrapping or replacing included CC-APIs.
Its main goal is to replace the now outdated [Lycodon-API][1] and improve usability and functionality.

### Notable features (to be expanded):
- `require`-function (**not** included in CC)
- Prototype based object-orientation
- Decoding of common binary file formats (zip & images) for use in CC


## Setup
1. Download the API
	- Currently only file-by-file
	- Script to download all files on [Pastebin][2]
2. Include the following command in your startup:
```
shell.run("apis/qua/core/require")
```
3. Import modules using `require`:
```
local Class = require "qua.core.class"
```


## Modules
|Module	|Description				|Notes (Current state)					|
|---	|---						|---									|
|core	|Important core features	|Used by most other modules				|
|math	|Small helper functions		|Convert bytes into hex/bin/string		|
|decode	|File formats & protocols	|Compression (zlib), file formats (PNG)	|
|crypt	|Checksums & encryption		|CRC, Adler32							|


## ToDo:
- Download-Helper to download entire repo (vs. `http.get()` for every file)
- More modules (especially GUI-features from first Lycodon-API)
- Complete documentation for each module
- Basic examples


[1]: http://lycodon.com/forum/thread/998-lycodon-computercraft-api/
[2]: https://pastebin.com/7CHhZA8w