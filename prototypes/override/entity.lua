table.insert(data.raw.planet.fulgora.lightning_properties.priority_rules, {
	type = "prototype",
	string = "charging-rod",
	priority_bonus = 250,
})

local pipe_picture = assembler3pipepictures()
pipe_picture.north.tint = { 0.3, 0.35, 0.3 }
pipe_picture.south.tint = { 0.3, 0.35, 0.3 }
pipe_picture.east.tint = { 0.3, 0.35, 0.3 }
pipe_picture.west.tint = { 0.3, 0.35, 0.3 }

local fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = pipe_picture,
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } } },
		secondary_draw_orders = { north = -1 },
	},
	{
		production_type = "output",
		pipe_picture = pipe_picture,
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = { { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } } },
		secondary_draw_orders = { north = -1 },
	},
}

-- Ensure centrifuges can accept fluid recipes. It isn't ideal that we change modded centrifuges this way, as the fluid boxes may be in the wrong positions, but on the other hand they're only visible when fluid recipes are used.
for _, machine in pairs(data.raw["assembling-machine"]) do
	if machine.crafting_categories and not machine.fluid_boxes then
		for _, category in pairs(machine.crafting_categories) do
			if category == "centrifuging" then
				machine.fluid_boxes = fluid_boxes
				machine.fluid_boxes_off_when_no_fluid_recipe = true
				break
			end
		end
	end
end

--== Relaxations ==--

data.raw["assembling-machine"]["crusher"].surface_conditions = {
	{
		property = "gravity",
		min = 0,
		max = 5,
	},
}

local eased_pressure_restriction = {
	{
		property = "pressure",
		min = 5,
	},
}
data.raw["inserter"]["burner-inserter"].surface_conditions = eased_pressure_restriction
data.raw["roboport"]["roboport"].surface_conditions = eased_pressure_restriction

local gravity_condition =
{
	{
		property = "gravity",
		min = 0.1
	}
}

data.raw["cargo-landing-pad"]["cargo-landing-pad"].surface_conditions = gravity_condition
data.raw["car"]["car"].surface_conditions = gravity_condition
data.raw["car"]["tank"].surface_conditions = gravity_condition
data.raw["spider-vehicle"]["spidertron"].surface_conditions = gravity_condition

--== Restrictions ==--

local magnetic_field_restriction = {
	{ property = "magnetic-field", max = 119 },
}

data.raw["lab"]["lab"].surface_conditions = magnetic_field_restriction
data.raw["accumulator"]["accumulator"].surface_conditions = magnetic_field_restriction
data.raw["reactor"]["nuclear-reactor"].surface_conditions = magnetic_field_restriction
data.raw["fusion-reactor"]["fusion-reactor"].surface_conditions = magnetic_field_restriction
data.raw["fusion-generator"]["fusion-generator"].surface_conditions = magnetic_field_restriction
