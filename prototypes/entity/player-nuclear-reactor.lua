local hit_effects = require("__base__.prototypes.entity.hit-effects")
local common = require("common")
local merge = require("lib").merge

data:extend({
	{
		type = "reactor",
		name = "cerys-mixed-oxide-reactor",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/mixed-oxide-reactor.png",
		icon_size = 64,
		flags = { "placeable-neutral", "player-creation" },
		minable = { mining_time = 0.5, result = "cerys-mixed-oxide-reactor" },
		max_health = 2000,
		collision_box = { { -3.2, -3.2 }, { 3.2, 3.2 } },
		selection_box = { { -3.5, -3.5 }, { 3.5, 3.5 } },
		corpse = "nuclear-reactor-remnants",
		dying_explosion = "nuclear-reactor-explosion",
		neighbour_bonus = 1,
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
		consumption = "160MW", -- From 40MW
		damaged_trigger_effect = hit_effects.entity(),
		fast_replaceable_group = "mixed-oxide-reactor",
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
			specific_heat = "10MJ", -- from 10MJ
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
		connection_patches_disconnected = nil,
		heat_connection_patches_connected = {
			sheet = apply_heat_pipe_glow({
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/player-nuclear-reactor/reactor-connect-patches-heated-4x4.png",
				width = 64,
				height = 64,
				variation_count = 16,
				scale = 0.55,
			}),
		},
		heat_connection_patches_disconnected = nil,
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
		lower_layer_picture = nil,
		heat_lower_layer_picture = nil,
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
		impact_category = "metal-large",
		open_sound = { filename = "__base__/sound/open-close/nuclear-open.ogg", volume = 0.8 },
		close_sound = { filename = "__base__/sound/open-close/nuclear-close.ogg", volume = 0.8 },
		working_sound = data.raw.reactor["nuclear-reactor"].working_sound,
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
		surface_conditions = { common.AMBIENT_RADIATION_MAX },
	},
})
