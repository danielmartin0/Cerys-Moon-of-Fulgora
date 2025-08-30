local lib = require("lib")
local common = require("common")

if not storage.cerys then
	return
end

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

local reactor = storage.cerys.reactor
if
	reactor
	and reactor.entity
	and reactor.entity.valid
	and reactor.entity.name == "cerys-fulgoran-reactor-wreck-cleared"
then
	reactor.entity.minable_flag = true
end
