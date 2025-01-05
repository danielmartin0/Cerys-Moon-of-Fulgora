local lib = require("lib")
local override_surface_conditions = lib.override_surface_conditions

data.raw.lab["cerys-lab"].inputs = {
	"automation-science-pack",
	"logistic-science-pack",
	"cerys-science-pack",
	"utility-science-pack",
}

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

--== Restrictions ==--

local magnetic_field_restriction = {
	property = "magnetic-field",
	max = 119,
}

for name, entity in pairs(data.raw["reactor"]) do
	if not string.sub(name, 1, 6) == "cerys-" then
		override_surface_conditions(entity, magnetic_field_restriction)
	end
end
for name, entity in pairs(data.raw["lab"]) do
	if not string.sub(name, 1, 6) == "cerys-" then
		override_surface_conditions(entity, magnetic_field_restriction)
	end
end
for name, entity in pairs(data.raw["accumulator"]) do
	if name ~= "charging-rod" then
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
