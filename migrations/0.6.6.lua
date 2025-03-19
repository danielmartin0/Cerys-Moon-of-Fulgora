if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
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
