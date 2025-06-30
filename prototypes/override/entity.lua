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
	if name ~= "cerys-charging-rod" then
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

--== Centrifuges ==--

local pipe_picture = assembler3pipepictures()
pipe_picture.north = util.empty_sprite()
pipe_picture.south.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-pipe-S.png"
pipe_picture.east.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-pipe-E.png"
pipe_picture.west.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-pipe-W.png"

local fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = pipe_picture,
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } } },
	},
	{
		production_type = "output",
		pipe_picture = pipe_picture,
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } } },
	},
}

-- Ensure centrifuges can accept fluid recipes. It isn't ideal that we change modded centrifuges this way, as the fluid boxes may be in the wrong positions, but on the other hand they're only visible when fluid recipes are used.
for _, machine in pairs(data.raw["assembling-machine"]) do
	if machine.crafting_categories and not machine.fluid_boxes then
		for _, category in pairs(machine.crafting_categories) do
			if category == "centrifuging" then
				machine.fluid_boxes = util.table.deepcopy(fluid_boxes)
				machine.fluid_boxes_off_when_no_fluid_recipe = true
				break
			end
		end
	end
end

local centrifuge = data.raw["assembling-machine"]["centrifuge"]
if
	centrifuge
	and centrifuge.graphics_set
	and centrifuge.graphics_set.working_visualisations
	and centrifuge.graphics_set.working_visualisations[1]
	and centrifuge.graphics_set.working_visualisations[2]
	and centrifuge.graphics_set.working_visualisations[2].animation
	and centrifuge.graphics_set.working_visualisations[2].animation.layers
then
	centrifuge.graphics_set.default_recipe_tint = { primary = { 0, 1, 0.2 } }
	centrifuge.graphics_set.recipe_not_set_tint = { primary = { 0, 1, 0.2 } }

	centrifuge.graphics_set.working_visualisations[1].apply_recipe_tint = "primary"
	centrifuge.graphics_set.working_visualisations[2].apply_recipe_tint = "primary"

	local layers = centrifuge.graphics_set.working_visualisations[2].animation.layers
	layers[1].filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-C-light.png"
	layers[2].filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-B-light.png"
	layers[3].filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/centrifuge/centrifuge-A-light.png"
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
