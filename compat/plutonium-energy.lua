if mods["PlutoniumEnergy"] then
	data.raw.technology["plutonium-processing"] = nil
	data.raw.technology["plutonium-reprocessing"] = nil
	data.raw.technology["plutonium-ammo"] = nil
	data.raw.technology["plutonium-nuclear-power"] = nil
	data.raw.technology["MOX-nuclear-power"] = nil
	data.raw.technology["fission-reactor-equipment-from-MOX-fuel"] = nil
	data.raw.technology["fission-reactor-equipment-from-plutonium"] = nil
	data.raw.technology["plutonium-atomic-bomb"] = nil
	data.raw.technology["nuclear-breeding"] = nil
	data.raw.technology["breeder-fuel-cell-from-uranium-cell"] = nil
	data.raw.technology["breeder-fuel-cell-from-MOX-fuel-cell"] = nil

	table.insert(data.raw.technology["cerys-plutonium-weaponry"].effects, {
		type = "unlock-recipe",
		recipe = "plutonium-cannon-shell",
	})
	table.insert(data.raw.technology["cerys-plutonium-weaponry"].effects, {
		type = "unlock-recipe",
		recipe = "explosive-plutonium-cannon-shell",
	})
	table.insert(data.raw.technology["cerys-applications-of-radioactivity"].effects, {
		type = "unlock-recipe",
		recipe = "MOX-reactor",
	})
	table.insert(data.raw.reactor["MOX-reactor"].energy_source.fuel_categories, "nuclear-mixed-oxide")
end
