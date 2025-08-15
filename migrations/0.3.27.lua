local common = require("common")

if not storage.cerys then
	return
end

local surface = common.generated_cerys_surface()
if not surface then
	return
end

local reactor = storage.cerys.nuclear_reactor
if reactor and reactor.entity and reactor.entity.valid and reactor.entity.name == "cerys-fulgoran-reactor-wreck" then
	reactor.entity.minable_flag = false
end
