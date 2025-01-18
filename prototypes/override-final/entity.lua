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

local eased_pressure_restriction = { {
	property = "pressure",
	min = 5,
} }

-- NOTE: Why are these not equivalent?
override_surface_conditions(data.raw["roboport"]["roboport"], eased_pressure_restriction)
override_surface_conditions(data.raw["inserter"]["burner-inserter"], eased_pressure_restriction)

local gravity_condition = {
	property = "gravity",
	min = 0.1,
}

override_surface_conditions(data.raw["cargo-landing-pad"]["cargo-landing-pad"], gravity_condition)
override_surface_conditions(data.raw["car"]["car"], gravity_condition)
override_surface_conditions(data.raw["car"]["tank"], gravity_condition)
override_surface_conditions(data.raw["spider-vehicle"]["spidertron"], gravity_condition)

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
