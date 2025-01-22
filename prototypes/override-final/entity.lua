local lib = require("lib")
local override_surface_conditions = lib.override_surface_conditions

for _, machine in pairs(data.raw["assembling-machine"]) do
	if machine.crafting_categories then
		for _, category in pairs(machine.crafting_categories) do
			if category == "chemistry-or-cryogenics" then
				if not lib.find(machine.crafting_categories, "chemistry-or-cryogenics-or-fulgoran-cryogenics") then
					table.insert(machine.crafting_categories, "chemistry-or-cryogenics-or-fulgoran-cryogenics")
				end
				break
			end
		end

		for _, category in pairs(machine.crafting_categories) do
			if category == "chemistry" then
				if not lib.find(machine.crafting_categories, "chemistry-or-fulgoran-cryogenics") then
					table.insert(machine.crafting_categories, "chemistry-or-fulgoran-cryogenics")
				end
				break
			end
		end

		for _, category in pairs(machine.crafting_categories) do
			if category == "electromagnetics" then
				if not lib.find(machine.crafting_categories, "electromagnetics-or-fulgoran-cryogenics") then
					table.insert(machine.crafting_categories, "electromagnetics-or-fulgoran-cryogenics")
				end
				break
			end
		end

		for _, category in pairs(machine.crafting_categories) do
			if category == "cryogenics" then
				if not lib.find(machine.crafting_categories, "cryogenics-or-fulgoran-cryogenics") then
					table.insert(machine.crafting_categories, "cryogenics-or-fulgoran-cryogenics")
				end
				break
			end
		end

		for _, category in pairs(machine.crafting_categories) do
			if category == "crafting" then
				if not lib.find(machine.crafting_categories, "crafting-or-fulgoran-cryogenics") then
					table.insert(machine.crafting_categories, "crafting-or-fulgoran-cryogenics")
				end
				break
			end
		end

		for _, category in pairs(machine.crafting_categories) do
			if category == "advanced-crafting" then
				if not lib.find(machine.crafting_categories, "advanced-crafting-or-fulgoran-cryogenics") then
					table.insert(machine.crafting_categories, "advanced-crafting-or-fulgoran-cryogenics")
				end
				break
			end
		end
	end
end

for _, character in pairs(data.raw.character) do -- there are alt-skin mods with different characters
	if character.crafting_categories then
		table.insert(character.crafting_categories, "crafting-or-fulgoran-cryogenics")
	end
end

if data.raw.furnace["stone-furnace"] and data.raw.furnace["stone-furnace"].energy_source.fuel_categories then
	table.insert(data.raw.furnace["stone-furnace"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.furnace["steel-furnace"] and data.raw.furnace["steel-furnace"].energy_source.fuel_categories then
	table.insert(data.raw.furnace["steel-furnace"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.boiler["boiler"] and data.raw.boiler["boiler"].energy_source.fuel_categories then
	table.insert(data.raw.boiler["boiler"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.inserter["burner-inserter"] and data.raw.inserter["burner-inserter"].energy_source.fuel_categories then
	table.insert(data.raw.inserter["burner-inserter"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.car["car"] and data.raw.car["car"].energy_source.fuel_categories then
	table.insert(data.raw.car["car"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.car["tank"] and data.raw.car["tank"].energy_source.fuel_categories then
	table.insert(data.raw.car["tank"].energy_source.fuel_categories, "chemical-or-radiative")
end

if
	data.raw["mining-drill"]["burner-mining-drill"]
	and data.raw["mining-drill"]["burner-mining-drill"].energy_source.fuel_categories
then
	table.insert(data.raw["mining-drill"]["burner-mining-drill"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.locomotive["locomotive"] and data.raw.locomotive["locomotive"].energy_source.fuel_categories then
	table.insert(data.raw.locomotive["locomotive"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.reactor["heating-tower"] and data.raw.reactor["heating-tower"].energy_source.fuel_categories then
	table.insert(data.raw.reactor["heating-tower"].energy_source.fuel_categories, "chemical-or-radiative")
end

--== Relaxations ==--

-- local eased_pressure_restriction = {
-- 	property = "pressure",
-- 	min = 5,
-- }

-- Vanilla and modded roboports:
for _, entity in pairs(data.raw["roboport"]) do
	for _, condition in pairs(entity.surface_conditions or {}) do
		if condition.property == "pressure" and condition.min and condition.min > 5 then
			condition.min = 5
		end
	end
end
-- Vanilla and modded burner inserters (to help with freeze reboots):
for _, entity in pairs(data.raw["inserter"]) do
	if entity.energy_source.type == "burner" and entity.surface_conditions then
		for _, condition in pairs(entity.surface_conditions) do
			if condition.property == "pressure" and condition.min and condition.min > 5 then
				condition.min = 5
			end
		end
	end
end

local gravity_condition = {
	property = "gravity",
	min = 0.1,
}

for _, entity in pairs(data.raw["cargo-landing-pad"] or {}) do
	if entity.surface_conditions then
		for _, condition in pairs(entity.surface_conditions) do
			if condition.property == "gravity" and condition.min and condition.min > 0.1 then
				condition.min = 0.1
			end
		end
	end
end
if data.raw["car"]["car"] then
	override_surface_conditions(data.raw["car"]["car"], gravity_condition)
end
if data.raw["car"]["tank"] then
	override_surface_conditions(data.raw["car"]["tank"], gravity_condition)
end
if data.raw["spider-vehicle"]["spidertron"] then
	override_surface_conditions(data.raw["spider-vehicle"]["spidertron"], gravity_condition)
end

--== Restrictions ==--

local magnetic_field_restriction = {
	property = "magnetic-field",
	max = 119,
}

for name, entity in pairs(data.raw["reactor"]) do
	if string.sub(name, 1, 6) ~= "cerys-" then
		override_surface_conditions(entity, magnetic_field_restriction)
	end
end
for name, entity in pairs(data.raw["lab"]) do
	if string.sub(name, 1, 6) ~= "cerys-" then
		override_surface_conditions(entity, magnetic_field_restriction)
	end
end
for name, entity in pairs(data.raw["accumulator"]) do
	if name ~= "cerys-charging-rod" then
		override_surface_conditions(entity, magnetic_field_restriction)
	end
end
for _, entity in pairs(data.raw["fusion-reactor"]) do
	override_surface_conditions(entity, magnetic_field_restriction)
end
for _, entity in pairs(data.raw["fusion-generator"]) do
	override_surface_conditions(entity, magnetic_field_restriction)
end

local ten_pressure_condition = {
	property = "pressure",
	min = 10,
}

for name, entity in pairs(data.raw["boiler"]) do
	if name ~= "heat-exchanger" then
		override_surface_conditions(entity, ten_pressure_condition)
	end
end
-- TODO: Restrict modded furnaces

--== Water puddles collisions ==--

for _, entity in pairs(data.raw["offshore-pump"]) do
	if entity.tile_buildability_rules then
		for _, rule in pairs(entity.tile_buildability_rules) do
			if rule.required_tiles and rule.required_tiles.layers and rule.required_tiles.layers.water_tile then
				rule.required_tiles.layers.cerys_water_tile = true
			end
			if rule.colliding_tiles and rule.colliding_tiles.layers and rule.colliding_tiles.layers.water_tile then
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

--== Atomic projectiles ==--
-- Ensuring that nuclear ground tiles don't get set on Cerys water spots.

local function add_cerys_layers_to_masks(tbl)
	if type(tbl) ~= "table" then
		return
	end

	if tbl.layers and tbl.layers.water_tile and not tbl.layers.cerys_tile then
		tbl.layers.cerys_tile = true
	end
	if tbl.layers and tbl.layers.water_tile and not tbl.layers.cerys_water_tile then
		tbl.layers.cerys_water_tile = true
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
