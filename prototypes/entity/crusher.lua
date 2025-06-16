local merge = require("lib").merge
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local common = require("common")

local crusher = {
	type = "assembling-machine",
	name = "cerys-fulgoran-crusher",
	subgroup = "cerys-entities",
	order = "d",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/crusher.png",
	icon_size = 64,
	flags = { "placeable-neutral", "placeable-player", "player-creation" },
	minable = { mining_time = 0.2, result = "cerys-fulgoran-crusher" },
	fast_replaceable_group = "cerys-fulgoran-crusher",
	max_health = 900,
	corpse = "electric-furnace-remnants",
	dying_explosion = "electric-furnace-explosion",
	circuit_wire_max_distance = 9,
	circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 0,
			main_offset = util.by_pixel(16.25, 38.25),
			shadow_offset = util.by_pixel(16.25, 38.25),
			show_shadow = true,
		},
		{
			variation = 0,
			main_offset = util.by_pixel(16.25, 38.25),
			shadow_offset = util.by_pixel(16.25, 38.25),
			show_shadow = true,
		},
		{
			variation = 0,
			main_offset = util.by_pixel(16.25, 38.25),
			shadow_offset = util.by_pixel(16.25, 38.25),
			show_shadow = true,
		},
		{
			variation = 0,
			main_offset = util.by_pixel(16.25, 38.25),
			shadow_offset = util.by_pixel(16.25, 38.25),
			show_shadow = true,
		},
	}),
	resistances = {
		{
			type = "fire",
			percent = 80,
		},
	},
	collision_box = { { -1.7, -1.2 }, { 1.7, 1.2 } },
	selection_box = { { -2, -1.5 }, { 2, 1.5 } },
	damaged_trigger_effect = hit_effects.entity(),
	module_slots = 0, -- (old comment: 1 lets us bump the asteroid spawn rate. More fun to shoot down more asteroids rather than build more modules)
	icons_positioning = {
		{ inventory_index = defines.inventory.furnace_modules, shift = { 0, 0.3 } },
	},
	icon_draw_specification = { shift = { 0, -0.45 } },
	allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" },
	crafting_categories = { "crushing", "cerys-crusher-quality-upgrades" },
	crafting_speed = 0.4,
	energy_usage = common.HARD_MODE_ON and "4000kW" or "2000kW",
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
			audible_distance_modifier = 1,
		},
		fade_in_ticks = 4,
		fade_out_ticks = 40,
		max_sounds_per_prototype = 3,
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
	map_color = { 212, 93, 93 },
	created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "cerys-fulgoran-crusher-created",
			},
		},
	},
}

local quality_variants = {}
for _, quality in pairs(data.raw.quality) do
	if quality.level and quality.level > 0 then
		local quality_crusher = merge(crusher, {
			name = "cerys-fulgoran-crusher-quality-" .. quality.level,
			localised_name = { "entity-name.cerys-fulgoran-crusher" },
			module_slots = math.ceil(quality.level),
			hidden = true,
		})

		table.insert(quality_variants, quality_crusher)
	end
end

local wreck = merge(crusher, {
	name = "cerys-fulgoran-crusher-wreck",
	hidden = true,
	crafting_categories = { "cerys-crusher-repair" },
	fixed_recipe = "cerys-repair-crusher",
	-- fixed_quality = settings.startup["cerys-disable-quality-mechanics"].value and "nil" or "uncommon",
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
	map_color = { 212, 93, 93 },
	working_sound = {
		-- TODO: Improve this sound
		sound = {
			audible_distance_modifier = 0.5,
			filename = "__base__/sound/assembling-machine-t2-1.ogg",
			volume = 0.45,
		},
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
data:extend(quality_variants)
