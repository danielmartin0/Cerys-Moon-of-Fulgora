local common = require("common")
local merge = require("lib").merge

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
	PlanetsLib.restrict_surface_conditions(
		data.raw.recipe["cerys-construction-robot-recycling"],
		common.AMBIENT_RADIATION_MIN
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
	PlanetsLib.restrict_surface_conditions(
		data.raw.recipe["cerys-exoskeleton-equipment-recycling"],
		common.AMBIENT_RADIATION_MIN
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
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["cerys-uranium-238-recycling"], common.AMBIENT_RADIATION_MIN)
end

if data.raw.recipe["uranium-235-recycling"] then
	data:extend({
		merge(data.raw.recipe["uranium-235-recycling"], {
			name = "cerys-uranium-235-recycling", -- unlocked by a late-game tech
			enabled = false,
		}),
	})
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["uranium-235-recycling"], common.AMBIENT_RADIATION_MAX)
	PlanetsLib.restrict_surface_conditions(data.raw.recipe["cerys-uranium-235-recycling"], common.AMBIENT_RADIATION_MIN)
end
