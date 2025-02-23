if not storage.cerys then
	return
end

if not storage.cerys.first_visit_tick then
	storage.cerys.first_visit_tick = game.tick
end

local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

storage.cerys.solar_panels = storage.cerys.solar_panels or {}
for _, entity in pairs(surface.find_entities_filtered({ type = "solar-panel" })) do
	if entity.valid then
		storage.cerys.solar_panels[entity.unit_number] = {
			entity = entity,
		}
	end
end
