if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

storage.cerys.solar_panels = {}
for _, entity in pairs(surface.find_entities_filtered({ type = "solar-panel" })) do
	if entity.valid then
		storage.cerys.solar_panels[entity.unit_number] = {
			entity = entity,
		}
	end
end
