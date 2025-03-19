if mods["PlutoniumEnergy"] then
	if data.raw.technology["plutonium-processing"] then
		data.raw.technology["plutonium-processing"].hidden = true
	end
	if data.raw.technology["plutonium-reprocessing"] then
		data.raw.technology["plutonium-reprocessing"].hidden = true
	end
	if data.raw.technology["plutonium-ammo"] then
		data.raw.technology["plutonium-ammo"].hidden = true
	end
	if data.raw.technology["plutonium-nuclear-power"] then
		data.raw.technology["plutonium-nuclear-power"].hidden = true
	end
	if data.raw.technology["MOX-nuclear-power"] then
		data.raw.technology["MOX-nuclear-power"].hidden = true
	end
	if data.raw.technology["fission-reactor-equipment-from-MOX-fuel"] then
		data.raw.technology["fission-reactor-equipment-from-MOX-fuel"].hidden = true
	end
	if data.raw.technology["fission-reactor-equipment-from-plutonium"] then
		data.raw.technology["fission-reactor-equipment-from-plutonium"].hidden = true
	end
	if data.raw.technology["nuclear-breeding"] then
		data.raw.technology["nuclear-breeding"].hidden = true
	end
	if data.raw.technology["breeder-fuel-cell-from-uranium-cell"] then
		data.raw.technology["breeder-fuel-cell-from-uranium-cell"].hidden = true
	end
	if data.raw.technology["breeder-fuel-cell-from-MOX-fuel-cell"] then
		data.raw.technology["breeder-fuel-cell-from-MOX-fuel-cell"].hidden = true
	end
	if data.raw.recipe["plutonium-cannon-shell"] then
		table.insert(data.raw.technology["cerys-plutonium-weaponry"].effects, {
			type = "unlock-recipe",
			recipe = "plutonium-cannon-shell",
		})
	end
	if data.raw.recipe["explosive-plutonium-cannon-shell"] then
		table.insert(data.raw.technology["cerys-plutonium-weaponry"].effects, {
			type = "unlock-recipe",
			recipe = "explosive-plutonium-cannon-shell",
		})
	end
	if data.raw.recipe["MOX-reactor"] then
		table.insert(data.raw.technology["cerys-applications-of-radioactivity"].effects, {
			type = "unlock-recipe",
			recipe = "MOX-reactor",
		})
	end
	if data.raw.reactor["MOX-reactor"] then
		table.insert(data.raw.reactor["MOX-reactor"].energy_source.fuel_categories, "nuclear-mixed-oxide")
	end
end
