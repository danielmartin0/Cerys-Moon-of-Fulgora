local common = require("common")

--== Surface Conditions Restrictions ==--

for name, entity in pairs(data.raw["reactor"]) do
	if string.sub(name, 1, 6) ~= "cerys-" then
		PlanetsLib.restrict_surface_conditions(entity, common.AMBIENT_RADIATION_MAX)
	end
end
for name, entity in pairs(data.raw["lab"]) do
	if string.sub(name, 1, 6) ~= "cerys-" then
		PlanetsLib.restrict_surface_conditions(entity, common.AMBIENT_RADIATION_MAX)
	end
end
for name, entity in pairs(data.raw["accumulator"]) do
	if name ~= "cerys-charging-rod" and name ~= "kr-planetary-teleporter" then
		PlanetsLib.restrict_surface_conditions(entity, common.AMBIENT_RADIATION_MAX)
	end
end
for _, entity in pairs(data.raw["fusion-reactor"]) do
	PlanetsLib.restrict_surface_conditions(entity, common.AMBIENT_RADIATION_MAX)
end
for _, entity in pairs(data.raw["fusion-generator"]) do
	PlanetsLib.restrict_surface_conditions(entity, common.AMBIENT_RADIATION_MAX)
end

for _, entity in pairs(data.raw["burner-generator"]) do
	PlanetsLib.restrict_surface_conditions(entity, common.AMBIENT_RADIATION_MAX)
end

for _, entity in pairs(data.raw["boiler"]) do
	if entity.energy_source.type ~= "heat" then
		PlanetsLib.restrict_surface_conditions(entity, common.TEN_PRESSURE_MIN)
	end
end

if data.raw["assembling-machine"]["cryogenic-plant"] then
	PlanetsLib.restrict_surface_conditions(
		data.raw["assembling-machine"]["cryogenic-plant"],
		common.AMBIENT_RADIATION_MAX
	)
end

-- No effect on vanilla:

for _, entity in pairs(data.raw["furnace"]) do
	if entity.energy_source and entity.energy_source.type == "burner" then
		PlanetsLib.restrict_surface_conditions(entity, common.TEN_PRESSURE_MIN)
	end
end

--=== Fulgora lightning priority rules ==--

if
	data.raw.planet.fulgora
	and data.raw.planet.fulgora.lightning_properties
	and data.raw.planet.fulgora.lightning_properties.priority_rules
then
	table.insert(data.raw.planet.fulgora.lightning_properties.priority_rules, {
		type = "prototype",
		string = "cerys-charging-rod",
		priority_bonus = 250,
	})
end

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	if data.raw.furnace["electric-incinerator"] then
		data.raw.furnace["electric-incinerator"].hidden = true
	end
	if data.raw.furnace["incinerator"] then
		data.raw.furnace["incinerator"].hidden = true
	end
end

--== Nuclear explosion effects ==--

if data.raw["explosion"]["nuke-effects-nauvis"] then
	PlanetsLib.restrict_surface_conditions(data.raw["explosion"]["nuke-effects-nauvis"], common.AMBIENT_RADIATION_MAX)
end
