local merge = require("lib").merge
local common = require("common")

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

local reactor_sound = sound_variations("__base__/sound/nuclear-reactor", 2, 1)
for _, sound in pairs(reactor_sound) do
	sound.speed = 0.8
end

local fulgoran_reactor = {
	type = "reactor",
	name = "cerys-fulgoran-reactor",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/fulgoran-reactor.png",
	icon_size = 64,
	subgroup = "cerys-entities",
	order = "e",
	flags = { "placeable-neutral", "player-creation" },
	minable = { mining_time = 1, result = "cerys-fulgoran-reactor" },
	max_health = max_health,
	corpse = "nuclear-reactor-remnants",
	dying_explosion = "nuclear-reactor-explosion",
	consumption = "4GW",
	neighbour_bonus = 0,
	energy_source = {
		type = "burner",
		fuel_categories = { "nuclear-mixed-oxide" },
		effectivity = 2,
		fuel_inventory_size = 1,
		burnt_inventory_size = 1,
		light_flicker = {
			color = { 0, 0, 0 },
			minimum_intensity = 0.7,
			maximum_intensity = 0.95,
		},
	},
	collision_box = { { -11, -10.7 }, { 10.8, 10.7 } },
	selection_box = { { -11, -11 }, { 11, 11 } },
	damaged_trigger_effect = data.raw["reactor"]["nuclear-reactor"].damaged_trigger_effect,
	lower_layer_picture = nil,
	heat_lower_layer_picture = nil,
	heat_buffer = {
		max_temperature = 2000, -- from 1000
		specific_heat = "640MJ", -- from 10MJ
		max_transfer = "300GW", -- from 10GW
		minimum_glow_temperature = 0,
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
	},

	connection_patches_connected = {
		sheet = {
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-connect-patches-4x6.png",
			width = 64,
			height = 64,
			variation_count = 24,
			scale = 0.5,
		},
	},
	connection_patches_disconnected = nil,
	heat_connection_patches_connected = {
		sheet = apply_heat_pipe_glow({
			filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated-4x6.png",
			width = 64,
			height = 64,
			variation_count = 24,
			scale = 0.5,
		}),
	},
	heat_connection_patches_disconnected = nil,

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

	impact_category = "metal-large",
	open_sound = { filename = "__base__/sound/open-close/nuclear-open.ogg", volume = 0.8 },
	close_sound = { filename = "__base__/sound/open-close/nuclear-close.ogg", volume = 0.8 },
	working_sound = {
		sound = reactor_sound,
		max_sounds_per_prototype = 3,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
	},

	meltdown_action = {
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {
				{
					type = "create-entity",
					entity_name = "atomic-rocket",
				},
			},
		},
	},

	default_temperature_signal = { type = "virtual", name = "signal-T" },
	circuit_wire_max_distance = reactor_circuit_wire_max_distance,
	circuit_connector = circuit_connector_definitions["nuclear-reactor"],
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 0, 183, 212 },
	fast_replaceable_group = "cerys-fulgoran-reactor",
}

local reactor_wreck_base = {
	type = "simple-entity-with-owner",
	subgroup = "cerys-entities",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/fulgoran-reactor.png",
	icon_size = 64,
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
		{ 16, 10.7 },
	},
	selection_box = { { -16, -11 }, { 16, 11 } },
	minable = { mining_time = 1, result = "cerys-fulgoran-reactor" },
}

local reactor_wreck = merge(reactor_wreck_base, {
	name = "cerys-fulgoran-reactor-wreck",
	type = "assembling-machine",
	hidden_in_factoriopedia = true,
	crafting_categories = { "cerys-nuclear-reactor-repair" },
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
					shift = util.by_pixel(66, -10),
					scale = 0.365,
					frame_count = 1,
					repeat_count = 1,
				},
			},
		},
	},
	working_sound = {
		sound = { audible_distance_modifier = 1, filename = "__base__/sound/burner-mining-drill-1.ogg", volume = 1 },

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
					shift = util.by_pixel(66, -10),
					scale = 0.365,
					frame_count = 1,
					repeat_count = 1,
					tint = common.FACTORIO_UNDO_FROZEN_TINT,
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
		{ -11, -10.7 },
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
		{ -11, -10.7 },
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
	crafting_categories = { "cerys-nuclear-reactor-repair" },
	fixed_recipe = "cerys-repair-nuclear-reactor",
	crafting_speed = 1,
	module_slots = 0, -- Apart from feeling a bit cheap, they would fall out of the machine
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
					repeat_count = 1,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/reactor-ruin-cleared-cropped.png",
					width = 2299,
					height = 2161,
					shift = util.by_pixel(17, 0),
					scale = 0.354816,
					frame_count = 1,
					repeat_count = 1,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-front.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					frame_count = 1,
					repeat_count = 1,
				},
				-- TODO: Time this laser animation to the crafting time
				-- {
				-- 	filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-laser.png",
				-- 	width = 1180,
				-- 	height = 1300,
				-- 	shift = util.by_pixel(0, -80),
				-- 	scale = 0.32,
				-- 	frame_count = 8,
				-- 	line_length = 4,
				-- 	frame_sequence = { 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 8, 8, 8, 8, 8 },
				-- },
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-shadow.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					draw_as_shadow = true,
					frame_count = 1,
					repeat_count = 1,
				},
			},
		},
	},
	working_sound = {
		sound = { audible_distance_modifier = 1, filename = "__base__/sound/assembling-machine-t1-1.ogg", volume = 1 },

		fade_in_ticks = 0,
		fade_out_ticks = 0,
	},
	map_color = { 0, 104, 120 },
})

local complete_with_scaffold = merge(cleared_with_scaffold, {
	name = "cerys-fulgoran-reactor-scaffolded",
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
					repeat_count = 1,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/Reactor-0.5.png",
					width = 2113,
					height = 2068,
					scale = 0.354816,
					shift = util.by_pixel(3, -3),
					frame_count = 1,
					repeat_count = 1,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-front.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					frame_count = 1,
					repeat_count = 1,
				},
				-- TODO: Time this laser animation to the crafting time
				-- {
				-- 	filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-laser.png",
				-- 	width = 1180,
				-- 	height = 1300,
				-- 	shift = util.by_pixel(0, -80),
				-- 	scale = 0.32,
				-- 	frame_count = 8,
				-- 	line_length = 4,
				-- 	frame_sequence = { 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 8, 8, 8, 8, 8 },
				-- },
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/nuclear-reactor/scaffold-shadow.png",
					width = 1058,
					height = 1022,
					shift = util.by_pixel(155, 4),
					scale = 1,
					draw_as_shadow = true,
					frame_count = 1,
					repeat_count = 1,
				},
			},
		},
	},
})

data:extend({
	fulgoran_reactor,
	reactor_wreck,
	reactor_wreck_frozen,
	reactor_wreck_cleared,
	scaffold,
	cleared_with_scaffold,
	complete_with_scaffold,
})
