local lib = require("lib")

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
	end
end

for _, character in pairs(data.raw.character) do -- there are alt-skin mods with different characters
	table.insert(character.crafting_categories, "crafting-or-fulgoran-cryogenics")
end

if data.raw.furnace["stone-furnace"] then
	table.insert(data.raw.furnace["stone-furnace"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.furnace["steel-furnace"] then
	table.insert(data.raw.furnace["steel-furnace"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.boiler["boiler"] then
	table.insert(data.raw.boiler["boiler"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.inserter["burner-inserter"] then
	table.insert(data.raw.inserter["burner-inserter"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.car["car"] then
	table.insert(data.raw.car["car"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.car["tank"] then
	table.insert(data.raw.car["tank"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw["mining-drill"]["burner-mining-drill"] then
	table.insert(data.raw["mining-drill"]["burner-mining-drill"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.locomotive["locomotive"] then
	table.insert(data.raw.locomotive["locomotive"].energy_source.fuel_categories, "chemical-or-radiative")
end

if data.raw.reactor["heating-tower"] then
	table.insert(data.raw.reactor["heating-tower"].energy_source.fuel_categories, "chemical-or-radiative")
end
