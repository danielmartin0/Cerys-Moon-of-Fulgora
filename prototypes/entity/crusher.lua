local merge = require("lib").merge
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local common = require("common")

local crusher = {
	type = "assembling-machine",
	name = "cerys-fulgoran-crusher",
	subgroup = "cerys-entities",
	order = "c",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/crusher.png",
	icon_size = 64,
	flags = { "placeable-neutral", "placeable-player", "player-creation" },
	minable = { mining_time = 0.2, result = "cerys-fulgoran-crusher" },
	fast_replaceable_group = "cerys-fulgoran-crusher",
	max_health = 900,
	corpse = "electric-furnace-remnants",
	dying_explosion = "electric-furnace-explosion",
	circuit_wire_max_distance = 9,
	circuit_connector = circuit_connector_definitions["crusher"],
	resistances = {
		{
			type = "fire",
			percent = 80,
		},
	},
	collision_box = { { -1.7, -1.2 }, { 1.7, 1.2 } },
	selection_box = { { -2, -1.5 }, { 2, 1.5 } },
	surface_conditions = {
		{
			property = "gravity",
			min = 0,
			max = 5,
		},
	},
	damaged_trigger_effect = hit_effects.entity(),
	module_slots = 1, -- 1 lets us bump the asteroid spawn rate. More fun to shoot down more asteroids rather than build more modules
	icons_positioning = {
		{ inventory_index = defines.inventory.furnace_modules, shift = { 0, 0.3 } },
	},
	icon_draw_specification = { shift = { 0, -0.45 } },
	allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" },
	crafting_categories = { "crushing" },
	crafting_speed = 0.5,
	energy_usage = "600kW",
	heating_energy = "200kW",
	energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		emissions_per_minute = { pollution = 1 },
	},
	open_sound = sounds.electric_large_open,
	close_sound = sounds.electric_large_close,
	working_sound = {
		sound = {
			filename = "__space-age__/sound/entity/crusher/crusher-loop.ogg",
			volume = 1,
			speed = 0.4,
		},
		audible_distance_modifier = 1,
		fade_in_ticks = 4,
		fade_out_ticks = 40,
		max_sounds_per_type = 3,
	},
	-- water_reflection = {...},
	graphics_set = {
		frozen_patch = util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-frozen", {
			scale = 0.5,
			shift = util.by_pixel(3, -6),
		}),
		animation = {
			layers = {
				util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-animation", {
					animation_speed = 0.5,
					frame_count = 48,
					scale = 0.5,
					shift = util.by_pixel(3, -6),
				}),
				util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher", {
					animation_speed = 0.5,
					repeat_count = 48,
					scale = 0.5,
					shift = util.by_pixel(3, -6),
				}),
			},
		},
	},
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 153, 158, 255 },
}

local wreck = merge(crusher, {
	name = "cerys-fulgoran-crusher-wreck",
	hidden_in_factoriopedia = true,
	crafting_categories = { "crusher-repair" },
	fixed_recipe = "cerys-repair-crusher",
	fixed_quality = settings.startup["cerys-disable-quality-mechanics"].value and "nil" or "uncommon",
	fast_replaceable_group = "cerys-fulgoran-crusher",
	crafting_speed = 1,
	energy_source = {
		type = "void",
	},
	module_slots = 1,
	allowed_effects = { "speed", "productivity" },
	graphics_set = {
		frozen_patch = util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-broken-frozen", {
			scale = 0.5,
			shift = util.by_pixel(3, -6),
		}),
		animation = {
			layers = {
				util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-animation", {
					animation_speed = 0.1,
					frame_count = 48,
					scale = 0.5,
					shift = util.by_pixel(3, -6),
				}),
				util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-broken", {
					animation_speed = 0.1,
					repeat_count = 48,
					scale = 0.5,
					shift = util.by_pixel(3, -6),
				}),
			},
		},
	},
	map_color = { 53, 54, 89 },
	working_sound = {
		-- TODO: Improve this sound
		sound = { filename = "__base__/sound/assembling-machine-t2-1.ogg", volume = 0.45 },
		audible_distance_modifier = 0.5,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
	},
})

local wreck_frozen = merge(wreck, {
	name = "cerys-fulgoran-crusher-wreck-frozen",
	graphics_set = {
		animation = {
			layers = {
				util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-animation", {
					animation_speed = 0.1,
					frame_count = 48,
					scale = 0.5,
					shift = util.by_pixel(3, -6),
					tint = common.FACTORIO_UNDO_FROZEN_TINT,
				}),
				util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-wreck-frozen", {
					animation_speed = 0.1,
					repeat_count = 48,
					scale = 0.5,
					shift = util.by_pixel(3, -6),
					tint = common.FACTORIO_UNDO_FROZEN_TINT,
				}),
			},
		},
	},
})

data:extend({ crusher, wreck, wreck_frozen })
