local merge = require("lib").merge

-- This function actually needs to be adjusted if size is changed:
local function make_heat_buffer_connections(size)
	local connections = {}
	for x = -(size - 1) / 2 + 3, (size - 1) / 2 - 3, 3 do
		connections[#connections + 1] = {
			position = { x, -(size - 1) / 2 },
			direction = defines.direction.north,
		}
	end

	for y = -(size - 1) / 2 + 3, (size - 1) / 2 - 3, 3 do
		connections[#connections + 1] = {
			position = { (size - 1) / 2, y },
			direction = defines.direction.east,
		}
	end

	for x = -(size - 1) / 2 + 3, (size - 1) / 2 - 3, 3 do
		connections[#connections + 1] = {
			position = { x, (size - 1) / 2 },
			direction = defines.direction.south,
		}
	end

	for y = -(size - 1) / 2 + 3, (size - 1) / 2 - 3, 3 do
		connections[#connections + 1] = {
			position = { -(size - 1) / 2, y },
			direction = defines.direction.west,
		}
	end

	return connections
end

local max_health = 15000

local fulgoran_reactor = merge(data.raw.reactor["nuclear-reactor"], {
	name = "cerys-fulgoran-reactor",
	subgroup = "cerys-entities",
	order = "c",
	max_health = max_health,
	collision_box = {
		{ -11,  -10.7 },
		{ 10.8, 10.7 },
	},
	selection_box = { { -11, -11 }, { 11, 11 } },
	lower_layer_picture = "nil",
	heat_lower_layer_picture = "nil",
	energy_source = merge(data.raw.reactor["nuclear-reactor"].energy_source, {
		fuel_categories = { "nuclear-mixed-oxide" },
		effectivity = 6,        -- from 1
	}),
	consumption = "6GW",        -- From 40MW
	heat_buffer = merge(data.raw.reactor["nuclear-reactor"].heat_buffer, {
		minimum_glow_temperature = 0, -- From 350
		connections = make_heat_buffer_connections(22),
		heat_picture = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-heat-0.5.png",
			width = 2113,
			height = 2068,
			scale = 0.354816,
			shift = util.by_pixel(3, -3),
			blend_mode = "additive",
			draw_as_glow = true,
		}),
		specific_heat = "400MJ", -- from 10MJ
		max_temperature = 1000, -- from 1000
		max_transfer = "300GW", -- from 10GW
	}),
	connection_patches_connected = {
		sheet = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-connect-patches-4x6.png",
			width = 64,
			height = 64,
			variation_count = 24,
			scale = 0.5,
		},
	},
	connection_patches_disconnected = {
		sheet = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-connect-patches-4x6.png",
			width = 64,
			height = 64,
			variation_count = 24,
			y = 64,
			scale = 0.5,
		},
	},
	heat_connection_patches_connected = {
		sheet = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated-4x6.png",
			width = 64,
			height = 64,
			variation_count = 24,
			scale = 0.5,
		}),
	},
	heat_connection_patches_disconnected = {
		sheet = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated-4x6.png",
			width = 64,
			height = 64,
			variation_count = 24,
			y = 64,
			scale = 0.5,
		}),
	},
	working_light_picture = {
		blend_mode = "additive",
		draw_as_glow = true,
		filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-light-front-0.5.png",
		width = 2113,
		height = 2068,
		scale = 0.354816,
		shift = util.by_pixel(3, -3),
		tint = { r = 0, g = 1, b = 1 },
	},
	picture = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-0.5.png",
				width = 2113,
				height = 2068,
				scale = 0.354816,
				shift = util.by_pixel(3, -3),
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-light-shadow-0.5.png",
				width = 2179,
				height = 2068,
				scale = 0.354816,
				shift = util.by_pixel(3, -3),
				draw_as_shadow = true,
			},
		},
	},
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/fulgoran-reactor.png",
	icon_size = 64,
	-- lower_layer_picture = {
	-- 	filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-pipes-0.5.png",
	-- width = 2113,
	-- height = 2068,
	-- scale = 0.354816,
	-- shift = ?,
	-- },
	-- heat_lower_layer_picture = apply_heat_pipe_glow({
	-- 	filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-pipes-heated-0.5.png",
	-- width = 2113,
	-- height = 2068,
	-- scale = 0.354816,
	-- shift = ?,
	-- }),
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 0, 183, 212 },
	working_sound = merge(data.raw.reactor["nuclear-reactor"].working_sound, {
		sound = sound_variations("__base__/sound/nuclear-reactor", 2, 1),
	}),
	fast_replaceable_group = "cerys-fulgoran-reactor",
})

local reactor_wreck_base = {
	type = "simple-entity-with-owner",
	subgroup = "cerys-entities",
	icon = "__base__/graphics/icons/nuclear-reactor.png",
	flags = {
		"placeable-player",
		"not-rotatable",
		"not-blueprintable",
		"not-deconstructable",
		"not-flammable",
	},
	hidden = true,
	map_color = { r = 0, g = 0.365, b = 0.58, a = 1 },
	max_health = max_health,
	allow_copy_paste = false,
	collision_box = {
		{ -16, -10.7 },
		{ 16,  10.7 },
	},
	selection_box = { { -16, -11 }, { 16, 11 } },
	minable = { mining_time = 1, result = "cerys-fulgoran-reactor" },
}

local reactor_wreck = merge(reactor_wreck_base, {
	name = "cerys-fulgoran-reactor-wreck",
	type = "assembling-machine",
	hidden_in_factoriopedia = true,
	crafting_categories = { "nuclear-reactor-repair" },
	crafting_speed = 1,
	fixed_recipe = "cerys-excavate-nuclear-reactor",
	energy_usage = "100kW",
	energy_source = {
		type = "void",
	},
	pictures = "nil",
	heating_energy = "10kJ", -- Put this high and it can leak to nearby entities to re-freeze
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-ruin.png",
					width = 3620,
					height = 2770,
					shift = util.by_pixel(66, 0),
					scale = 0.354816,
					frame_count = 1,
					repeat_count = 1,
				},
			},
		},
	},
	working_sound = {
		sound = { filename = "__base__/sound/burner-mining-drill-1.ogg", volume = 1 },
		audible_distance_modifier = 1,
		fade_in_ticks = 0,
		fade_out_ticks = 0,
	},
	map_color = { 0, 0, 0 },
})

local reactor_wreck_frozen = merge(reactor_wreck, {
	name = "cerys-fulgoran-reactor-wreck-frozen",
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-ruin-frozen.png",
					width = 3620,
					height = 2770,
					shift = util.by_pixel(66, 0),
					scale = 0.354816,
					frame_count = 1,
					repeat_count = 1,
				},
			},
		},
	},
	map_color = { 0, 41, 48 },
})

local reactor_wreck_cleared = merge(reactor_wreck_base, {
	name = "cerys-fulgoran-reactor-wreck-cleared",
	minable = "nil",
	fast_replaceable_group = "cerys-fulgoran-reactor-scaffold",
	collision_box = {
		{ -11,  -10.7 },
		{ 10.8, 10.7 },
	},
	selection_box = { { -11, -11 }, { 11, 11 } },
	picture = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-ruin-cleared-cropped.png",
				width = 2299,
				height = 2161,
				shift = util.by_pixel(17, 0),
				scale = 0.354816,
			},
		},
	},
	map_color = { 0, 68, 79 },
})

local scaffold = merge(reactor_wreck_cleared, {
	name = "cerys-fulgoran-reactor-scaffold",
	minable = {
		mining_time = 2,
		result = "cerys-fulgoran-reactor-scaffold",
	},
	collision_box = {
		{ -11,  -10.7 },
		{ 10.8, 10.7 },
	},
	picture = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold.png",
				width = 1058,
				height = 1022,
				shift = util.by_pixel(155, 4),
				scale = 1,
			},
		},
	},
})

local cleared_with_scaffold = merge(reactor_wreck_cleared, {
	name = "cerys-fulgoran-reactor-wreck-scaffolded",
	type = "assembling-machine",
	crafting_categories = { "nuclear-reactor-repair" },
	fixed_recipe = "cerys-repair-nuclear-reactor",
	fixed_quality = "rare",
	crafting_speed = 1,
	module_slots = 2,
	allowed_effects = { "speed", "productivity" },
	energy_usage = "100kW",
	energy_source = {
		type = "void",
	},
	pictures = "nil",
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					frame_count = 1,
					repeat_count = 8,
				},
				{
					filename =
					"__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-ruin-cleared-cropped.png",
					width = 2299,
					height = 2161,
					shift = util.by_pixel(17, 0),
					scale = 0.354816,
					frame_count = 1,
					repeat_count = 8,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-front.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					frame_count = 1,
					repeat_count = 8,
				},
				-- {
				-- 	filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-laser.png",
				-- 	width = 1180,
				-- 	height = 1300,
				-- 	shift = util.by_pixel(0, 0),
				-- 	scale = 1,
				-- 	frame_count = 8,
				-- 	line_length = 4,
				-- },
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-shadow.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					draw_as_shadow = true,
					frame_count = 1,
					repeat_count = 8,
				},
			},
		},
	},
	working_sound = {
		sound = { filename = "__base__/sound/assembling-machine-t1-1.ogg", volume = 1 },
		audible_distance_modifier = 1,
		fade_in_ticks = 0,
		fade_out_ticks = 0,
	},
	map_color = { 0, 104, 120 },
})

data:extend({
	fulgoran_reactor,
	reactor_wreck,
	reactor_wreck_frozen,
	reactor_wreck_cleared,
	scaffold,
	cleared_with_scaffold,
})
