local merge = require("lib").merge

data:extend({
	{
		type = "tool",
		name = "fulgoran-cryogenics-progress",
		hidden = true,
		icon = "__PlanetsLib__/graphics/icons/research-progress-product.png",
		icon_size = 64,
		subgroup = "science-pack",
		order = "j-a[cerys]-b[fulgoran-cryogenics-progress]",
		stack_size = 200,
		default_import_location = "cerys",
		weight = 1 * 1000 * 1000000,
		durability = 1,
	},
})

local magnetic_field_restriction = {
	property = "magnetic-field",
	max = 119,
}

if data.raw.recipe["construction-robot-recycling"] then
	data:extend({
		merge(data.raw.recipe["construction-robot-recycling"], {
			name = "cerys-construction-robot-recycling", -- unlocked by a late-game tech
			enabled = false,
		}),
	})

	PlanetsLib.restrict_surface_conditions(data.raw.recipe["construction-robot-recycling"], magnetic_field_restriction)
end

if data.raw.recipe["exoskeleton-equipment-recycling"] then
	data:extend({
		merge(data.raw.recipe["exoskeleton-equipment-recycling"], {
			name = "cerys-exoskeleton-equipment-recycling", -- unlocked by a late-game tech
			enabled = false,
		}),
	})

	PlanetsLib.restrict_surface_conditions(
		data.raw.recipe["exoskeleton-equipment-recycling"],
		magnetic_field_restriction
	)
end

if data.raw.recipe["uranium-238-recycling"] then
	data:extend({
		merge(data.raw.recipe["uranium-238-recycling"], {
			name = "cerys-uranium-238-recycling", -- unlocked by a late-game tech
			enabled = false,
		}),
	})
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["uranium-238-recycling"], magnetic_field_restriction)
end
