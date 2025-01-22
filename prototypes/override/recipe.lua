local override_surface_conditions = require("lib").override_surface_conditions

--== Relaxations ==--

if data.raw.recipe["recycler"] then
	override_surface_conditions(data.raw.recipe["recycler"], {
		property = "magnetic-field",
		min = 99,
		max = 120,
	})
end

override_surface_conditions(data.raw.recipe["cryogenic-plant"], {
	property = "pressure",
	min = 5,
	max = 600,
})

--== Restrictions ==--

if data.raw.recipe["lab"] then
	override_surface_conditions(data.raw.recipe["lab"], {
		property = "magnetic-field",
		max = 119,
	})
end

if data.raw.recipe["accumulator"] then
	override_surface_conditions(data.raw.recipe["accumulator"], {
		property = "magnetic-field",
		max = 119,
	})
end

if data.raw.recipe["nuclear-reactor"] then
	override_surface_conditions(data.raw.recipe["nuclear-reactor"], {
		property = "magnetic-field",
		max = 119,
	})
end

if data.raw.recipe["fusion-reactor"] then
	override_surface_conditions(data.raw.recipe["fusion-reactor"], {
		property = "magnetic-field",
		max = 119,
	})
end

if data.raw.recipe["fusion-generator"] then
	override_surface_conditions(data.raw.recipe["fusion-generator"], {
		property = "magnetic-field",
		max = 119,
	})
end

if data.raw.recipe["fusion-power-cell"] then
	override_surface_conditions(data.raw.recipe["fusion-power-cell"], {
		property = "magnetic-field",
		max = 119,
	})
end

if data.raw.recipe["boiler"] then
	override_surface_conditions(data.raw.recipe["boiler"], {
		property = "pressure",
		min = 10,
	})
end

if data.raw.recipe["steam-engine"] then
	override_surface_conditions(data.raw.recipe["steam-engine"], {
		property = "pressure",
		min = 10,
	})
end

override_surface_conditions(data.raw.recipe["rocket-fuel"], {
	property = "temperature",
	min = 255,
})

--== Forbid recycling certain items on Cerys ==--

local magnetic_field_restriction = {
	property = "magnetic-field",
	max = 119,
}

if data.raw.recipe["uranium-238-recycling"] then
	override_surface_conditions(data.raw.recipe["uranium-238-recycling"], magnetic_field_restriction)
end
if data.raw.recipe["construction-robot-recycling"] then
	override_surface_conditions(data.raw.recipe["construction-robot-recycling"], magnetic_field_restriction)
end
if data.raw.recipe["exoskeleton-equipment-recycling"] then
	override_surface_conditions(data.raw.recipe["exoskeleton-equipment-recycling"], magnetic_field_restriction)
end

--== Flare stack ==--

if settings.startup["cerys-disable-flare-stack-item-venting"].value then
	data.raw.recipe["electric-incinerator"].hidden = true
	data.raw.recipe["incinerator"].hidden = true
end
