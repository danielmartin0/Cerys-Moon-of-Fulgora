local override_surface_conditions = require("lib").override_surface_conditions

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

override_surface_conditions(data.raw["assembling-machine"]["crusher"], {
	property = "gravity",
	min = 0,
	max = 5,
})

local eased_pressure_restriction = {
	property = "pressure",
	min = 5,
}

override_surface_conditions(data.raw["inserter"]["burner-inserter"], eased_pressure_restriction)
override_surface_conditions(data.raw["roboport"]["roboport"], eased_pressure_restriction)

local gravity_condition = {
	property = "gravity",
	min = 0.1,
}

override_surface_conditions(data.raw["cargo-landing-pad"]["cargo-landing-pad"], gravity_condition)
override_surface_conditions(data.raw["car"]["car"], gravity_condition)
override_surface_conditions(data.raw["car"]["tank"], gravity_condition)
override_surface_conditions(data.raw["spider-vehicle"]["spidertron"], gravity_condition)
