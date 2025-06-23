local common = require("common")
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

if data.raw.recipe["construction-robot-recycling"] then
	data:extend({
		merge(data.raw.recipe["construction-robot-recycling"], {
			name = "cerys-construction-robot-recycling", -- unlocked by a late-game tech
			enabled = false,
		}),
	})

	PlanetsLib.restrict_surface_conditions(
		data.raw.recipe["construction-robot-recycling"],
		common.AMBIENT_RADIATION_MAX
	)
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
		common.AMBIENT_RADIATION_MAX
	)
end

if data.raw.recipe["uranium-238-recycling"] then
	data:extend({
		merge(data.raw.recipe["uranium-238-recycling"], {
			name = "cerys-uranium-238-recycling", -- unlocked by a late-game tech
			enabled = false,
		}),
	})
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["uranium-238-recycling"], common.AMBIENT_RADIATION_MAX)
end
