# QUA

## Disclaimer
This project is in a very early stage, everything might be subject to change. Only use for basic testing.


## Info
`qua` is a Lua-API for the Minecraft modification "ComputerCraft" (hereafter referred to as "CC").
The API attempts to simplify the use of common elements (modules, OO, communication, GUI etc.) by wrapping or replacing included CC-APIs.
Its main goal is to replace the now outdated [Lycodon-API][1] and improve usability and functionality.

### Notable features (to be expanded):
- `require`-function (**not** included in CC)
- Prototype based object-orientation
- Shortcuts for common operations
- Simple UI with support for multiple views per monitor & nested screens


## Setup
1. Download the API into folder "apis/qua"
	- Currently only file-by-file
	- Script to download all files on [Pastebin][2]
2. Include the following command in your startup:
```
shell.run("apis/qua/require")
```
3. Import modules using `require`:
```
local Class = require "qua.core.class"
```


## Modules
|Module	|Description					|Notes (Current state)						|
|---	|---							|---										|
|core	|Important core features		|Used by most other modules					|
|cc		|Classes specific for CC		|Color & Side								|
|ui		|Everything drawn on a term		|Basic UI elements and containers			|
|tools	|Small helpers to shorten code	|Array index conversion, RS-delay-queue		|


## ToDo:
- Serialization
- Peripherals (Sensor & Printer)
- Support for binary filetypes (PNG, ZIP)
- Advanced Image Processing (Rescaling, Dithering, more than 16 colors)


[1]: http://lycodon.com/forum/thread/998-lycodon-computercraft-api/
[2]: https://pastebin.com/7CHhZA8w