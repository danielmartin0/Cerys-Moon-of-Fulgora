local ten_pressure_condition = {
	{
		property = "pressure",
		min = 10,
	},
}

data:extend({
	{
		type = "recipe-category",
		name = "gas-venting",
	},
	{
		type = "recipe-category",
		name = "flaring",
	},
	{
		type = "item",
		name = "vent-stack",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/vent-stack.png",
		icon_size = 64,
		subgroup = "production-machine",
		order = "e[chemical-plant]a",
		place_result = "vent-stack",
		stack_size = 50,
	},
	{
		type = "item",
		name = "flare-stack",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/flare-stack.png",
		icon_size = 64,
		subgroup = "production-machine",
		order = "e[chemical-plant]a",
		place_result = "flare-stack",
		stack_size = 50,
	},
	{
		type = "recipe",
		name = "vent-stack",
		energy_required = 2,
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 10 },
			{ type = "item", name = "electronic-circuit", amount = 2 },
			{ type = "item", name = "pipe", amount = 5 },
		},
		results = { { type = "item", name = "vent-stack", amount = 1 } },
	},
	{
		type = "recipe",
		name = "flare-stack",
		energy_required = 2,
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 10 },
			{ type = "item", name = "electronic-circuit", amount = 2 },
			{ type = "item", name = "pipe", amount = 5 },
		},
		results = { { type = "item", name = "flare-stack", amount = 1 } },
	},
	{
		type = "furnace",
		name = "vent-stack",
		-- localised_description = "flare-tooltips.fluid-burn-rate " .. settings.startup["flare-stack-fluid-rate"].value,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/vent-stack.png",
		icon_size = 64,
		flags = { "placeable-neutral", "player-creation" },
		minable = { mining_time = 1, result = "vent-stack" },
		fast_replaceable_group = "fluid-incinerator",
		max_health = 250,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		collision_box = { { -0.29, -0.29 }, { 0.29, 0.29 } },
		selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
		crafting_categories = { "gas-venting" },
		crafting_speed = 1,
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = { pollution = 1 },
			-- emissions_per_minute = { pollution = 8 },
		},
		energy_usage = "1kW",
		ingredient_count = 1,
		source_inventory_size = 0,
		result_inventory_size = 0,
		graphics_set = {
			animation = {
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/flare-stack/vent-stack.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 1.5, -1.59375 },
			},
			working_visualisations = {
				{
					animation = {
						filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/flare-stack/vent-stack-fumes.png",
						priority = "extra-high",
						frame_count = 29,
						width = 48,
						height = 105,
						shift = { 0, -5 },
						run_mode = "backward",
					},
					light = { intensity = 1, size = 32 },
					constant_speed = true,
				},
			},
		},
		vehicle_impact_sound = {
			filename = "__base__/sound/car-metal-impact.ogg",
			volume = 0.65,
		},
		working_sound = {
			sound = { filename = "__base__/sound/oil-refinery.ogg" },
			idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
			apparent_volume = 2.5,
		},
		fluid_boxes = {
			{
				production_type = "input",
				pipe_covers = pipecoverspictures(),
				volume = 50, -- edited
				pipe_connections = {
					{ flow_direction = "input", direction = defines.direction.north, position = { 0, 0 } },
				},
			},
		},
	},
	{
		type = "furnace",
		name = "flare-stack",
		-- localised_description = "flare-tooltips.fluid-burn-rate " .. settings.startup["flare-stack-fluid-rate"].value,
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/flare-stack.png",
		icon_size = 64,
		flags = { "placeable-neutral", "player-creation" },
		minable = { mining_time = 1, result = "flare-stack" },
		fast_replaceable_group = "fluid-incinerator",
		max_health = 250,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		collision_box = { { -0.29, -0.29 }, { 0.29, 0.29 } },
		selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
		crafting_categories = { "flaring" },
		crafting_speed = 1,
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = { pollution = 1 },
			-- emissions_per_minute = { pollution = 8 },
		},
		energy_usage = "1kW",
		ingredient_count = 1,
		source_inventory_size = 0,
		result_inventory_size = 0,
		graphics_set = {
			animation = {
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/flare-stack/flare-stack.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 1.5, -1.59375 },
			},
			working_visualisations = {
				{
					animation = {
						filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/flare-stack/flare-stack-fire.png",
						priority = "extra-high",
						frame_count = 29,
						width = 48,
						height = 105,
						shift = { 0, -5 },
						run_mode = "backward",
					},
					light = { intensity = 1, size = 32 },
					constant_speed = true,
				},
			},
		},
		vehicle_impact_sound = {
			filename = "__base__/sound/car-metal-impact.ogg",
			volume = 0.65,
		},
		working_sound = {
			sound = { filename = "__base__/sound/oil-refinery.ogg" },
			idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
			apparent_volume = 2.5,
		},
		fluid_boxes = {
			{
				production_type = "input",
				pipe_covers = pipecoverspictures(),
				volume = 50, -- edited
				pipe_connections = {
					{ flow_direction = "input", direction = defines.direction.north, position = { 0, 0 } },
				},
			},
		},
		surface_conditions = ten_pressure_condition,
	},
})
