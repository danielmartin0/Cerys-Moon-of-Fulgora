local merge = require("lib").merge

local max_health = 2000

local mixed_oxide_reactor = merge(data.raw.reactor["nuclear-reactor"], {
	name = "cerys-mixed-oxide-reactor",
	subgroup = "energy",
	order = "z-f[nuclear-energy]-a[reactor]-a[mixed-oxide-reactor]",
	max_health = max_health,
	collision_box = { { -3.2, -3.2 }, { 3.2, 3.2 } },
	selection_box = { { -3.5, -3.5 }, { 3.5, 3.5 } },
	minable = { mining_time = 1, result = "cerys-mixed-oxide-reactor" },
	lower_layer_picture = "nil",
	heat_lower_layer_picture = "nil",
	energy_source = {
		type = "burner",
		fuel_categories = { "nuclear-mixed-oxide" },
		effectivity = 1,
		fuel_inventory_size = 1,
		burnt_inventory_size = 1,
		light_flicker = {
			color = { 0, 0, 0 },
			minimum_intensity = 0.7,
			maximum_intensity = 0.95,
		},
	},
	consumption = "640MW", -- From 40MW
	heat_buffer = merge(data.raw.reactor["nuclear-reactor"].heat_buffer, {
		minimum_glow_temperature = 175, -- From 350
		connections = {
			{
				position = { -3, -3 },
				direction = defines.direction.north,
			},
			{
				position = { -1, -3 },
				direction = defines.direction.north,
			},
			{
				position = { 1, -3 },
				direction = defines.direction.north,
			},
			{
				position = { 3, -3 },
				direction = defines.direction.north,
			},
			{
				position = { 3, -3 },
				direction = defines.direction.east,
			},
			{
				position = { 3, -1 },
				direction = defines.direction.east,
			},
			{
				position = { 3, 1 },
				direction = defines.direction.east,
			},
			{
				position = { 3, 3 },
				direction = defines.direction.east,
			},
			{
				position = { 3, 3 },
				direction = defines.direction.south,
			},
			{
				position = { 1, 3 },
				direction = defines.direction.south,
			},
			{
				position = { -1, 3 },
				direction = defines.direction.south,
			},
			{
				position = { -3, 3 },
				direction = defines.direction.south,
			},
			{
				position = { -3, 3 },
				direction = defines.direction.west,
			},
			{
				position = { -3, 1 },
				direction = defines.direction.west,
			},
			{
				position = { -3, -1 },
				direction = defines.direction.west,
			},
			{
				position = { -3, -3 },
				direction = defines.direction.west,
			},
		},
		heat_picture = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/heat.png",
			width = 646,
			height = 540,
			scale = 0.55,
			shift = util.by_pixel(35, -8),
			blend_mode = "additive",
			draw_as_glow = true,
		}),
		specific_heat = "40MJ", -- from 10MJ
		max_temperature = 1500, -- from 1000
		max_transfer = "40GW", -- from 10GW
	}),
	connection_patches_connected = {
		sheet = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/reactor-connect-patches-4x4.png",
			width = 64,
			height = 64,
			variation_count = 16,
			scale = 0.55,
		},
	},
	connection_patches_disconnected = {
		sheet = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/reactor-connect-patches-4x4.png",
			width = 64,
			height = 64,
			variation_count = 16,
			y = 64,
			scale = 0.55,
		},
	},
	heat_connection_patches_connected = {
		sheet = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/reactor-connect-patches-heated-4x4.png",
			width = 64,
			height = 64,
			variation_count = 16,
			scale = 0.55,
		}),
	},
	heat_connection_patches_disconnected = {
		sheet = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/reactor-connect-patches-heated-4x4.png",
			width = 64,
			height = 64,
			variation_count = 16,
			y = 64,
			scale = 0.55,
		}),
	},
	working_light_picture = {
		blend_mode = "additive",
		draw_as_glow = true,
		filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/light.png",
		width = 646,
		height = 540,
		scale = 0.55,
		shift = util.by_pixel(35, -8),
		tint = { r = 0, g = 1, b = 1 },
	},
	picture = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/reactor.png",
				width = 646,
				height = 540,
				scale = 0.55,
				shift = util.by_pixel(35, -8),
			},
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/shadow.png",
				width = 646,
				height = 540,
				scale = 0.55,
				shift = util.by_pixel(35, -8),
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
	-- scale = 0.55,
	-- shift = ?,
	-- },
	-- heat_lower_layer_picture = apply_heat_pipe_glow({
	-- 	filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-pipes-heated-0.5.png",
	-- width = 2113,
	-- height = 2068,
	-- scale = 0.55,
	-- shift = ?,
	-- }),
	-- working_sound = merge(data.raw.reactor["nuclear-reactor"].working_sound, {
	-- 	sound = sound_variations("__base__/sound/nuclear-reactor", 2, 1),
	-- }),
	fast_replaceable_group = "mixed-oxide-reactor",
	surface_conditions = { {
		property = "magnetic-field",
		max = 119,
	} },
})

data:extend({
	mixed_oxide_reactor,
})
