if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

local tower_prototypes = {
	"cerys-fulgoran-radiative-tower",
	"cerys-fulgoran-radiative-tower-frozen",
	"cerys-fulgoran-radiative-tower-rising-reactor-base",
	"cerys-fulgoran-radiative-tower-rising-reactor-tower-1",
	"cerys-fulgoran-radiative-tower-rising-reactor-tower-2",
	"cerys-fulgoran-radiative-tower-rising-reactor-tower-3",
	"cerys-fulgoran-radiative-tower-base",
	"cerys-fulgoran-radiative-tower-base-frozen",
	"cerys-fulgoran-radiative-tower-contracted-container",
}

for _, prototype_name in pairs(tower_prototypes) do
	local entities = surface.find_entities_filtered({ name = prototype_name })
	for _, entity in pairs(entities) do
		if entity.valid and entity.force.name == "neutral" then
			entity.force = "player"
		end
	end
end
