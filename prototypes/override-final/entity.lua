local common = require("common")
local lib = require("lib")

-- == Crusher module slots for arbitrary quality levels ==--

-- Also encoded in the entity file:
data.raw["assembling-machine"]["cerys-fulgoran-crusher"].module_slots_quality_bonus = {}
for _, quality in pairs(data.raw.quality) do
	data.raw["assembling-machine"]["cerys-fulgoran-crusher"].module_slots_quality_bonus[quality.name] = quality.level
		* 2
end

-- == Cryogenic plant crafting speed for arbitrary quality levels ==--

-- Also encoded in the entity file:
data.raw["assembling-machine"]["cerys-fulgoran-cryogenic-plant"].crafting_speed_quality_multiplier = {}
for _, quality in pairs(data.raw.quality) do
	data.raw["assembling-machine"]["cerys-fulgoran-cryogenic-plant"].crafting_speed_quality_multiplier[quality.name] = 1
		+ quality.level * 0.4
end

-- == Surface Condition Relaxations ==--

-- Vanilla and modded roboports:
for _, entity in pairs(data.raw["roboport"]) do
	PlanetsLib.relax_surface_conditions(entity, common.FIVE_PRESSURE_MIN)
end
-- Vanilla and modded burner inserters (to help with freeze reboots):
for _, entity in pairs(data.raw["inserter"]) do
	if entity.energy_source.type == "burner" and entity.surface_conditions then
		PlanetsLib.relax_surface_conditions(entity, common.FIVE_PRESSURE_MIN)
	end
end

for _, entity in pairs(data.raw["cargo-landing-pad"] or {}) do
	PlanetsLib.relax_surface_conditions(entity, common.GRAVITY_MIN)
end
if data.raw["car"]["car"] then
	PlanetsLib.relax_surface_conditions(data.raw["car"]["car"], common.GRAVITY_MIN)
end
if data.raw["car"]["tank"] then
	PlanetsLib.relax_surface_conditions(data.raw["car"]["tank"], common.GRAVITY_MIN)
end
if data.raw["spider-vehicle"]["spidertron"] then
	PlanetsLib.relax_surface_conditions(data.raw["spider-vehicle"]["spidertron"], common.GRAVITY_MIN)
end

-- == Relaxations with no effect on vanilla (for compatibility) ==--

if data.raw["assembling-machine"]["electromagnetic-plant"] then
	PlanetsLib.relax_surface_conditions(data.raw["assembling-machine"]["electromagnetic-plant"], {
		property = "magnetic-field",
		max = 120
	})
end

if data.raw.recipe["quantum-processor"] then
	PlanetsLib.relax_surface_conditions(data.raw.recipe["quantum-processor"], {
		property = "magnetic-field",
		max = 120
	})
end

-- == Atomic projectiles ==--
-- Makes the Cerys surface less vulnerable to nuclear explosions. (This no longer affects vanilla, but can affect modded projectiles.)

local function add_cerys_layers_to_masks(tbl)
	if type(tbl) ~= "table" then
		return
	end

	if tbl.layers and tbl.layers.water_tile and not tbl.layers.cerys_tile then
		tbl.layers.cerys_tile = true
	end

	for _, v in pairs(tbl) do
		if type(v) == "table" then
			add_cerys_layers_to_masks(v)
		end
	end
end

for _, projectile in pairs(data.raw["projectile"]) do
	add_cerys_layers_to_masks(projectile)
end

-- == Water puddles collisions ==--

for _, entity in pairs(data.raw["offshore-pump"]) do
	if entity.tile_buildability_rules then
		for _, rule in pairs(entity.tile_buildability_rules) do
			if rule.required_tiles and rule.required_tiles.layers and rule.required_tiles.layers.water_tile
				and not rule.required_tiles.layers.cerys_water_tile then
				rule.required_tiles.layers.cerys_water_tile = true
			end
			if rule.colliding_tiles and rule.colliding_tiles.layers and rule.colliding_tiles.layers.water_tile
				and not rule.colliding_tiles.layers.cerys_water_tile then
				rule.colliding_tiles.layers.cerys_water_tile = true
			end
		end
	end
end

for key, mask in pairs(data.raw["utility-constants"].default.default_collision_masks) do
	if mask.layers and mask.layers.water_tile then
		local new_mask = util.table.deepcopy(mask)
		new_mask.layers.cerys_water_tile = true
		data.raw["utility-constants"].default.default_collision_masks[key] = new_mask
	end
end
