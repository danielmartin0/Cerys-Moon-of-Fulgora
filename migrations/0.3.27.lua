if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

local reactor = storage.cerys.nuclear_reactor
if reactor and reactor.entity and reactor.entity.valid and reactor.entity.name == "cerys-fulgoran-reactor-wreck" then
	reactor.entity.minable_flag = false
end
