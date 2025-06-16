local merge = require("lib").merge
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local common = require("common")
local sounds = require("__base__.prototypes.entity.sounds")

local teleporter = {
	type = "assembling-machine",
	name = "cerys-fulgoran-teleporter",
	subgroup = "cerys-entities",
	order = "b",
	max_health = 8000,
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/teleporter.png",
	icon_size = 64,
	flags = { "placeable-neutral", "player-creation" },
	minable = { mining_time = 1, result = "cerys-fulgoran-teleporter" },
	fast_replaceable_group = "cerys-fulgoran-teleporter",
	corpse = "cryogenic-plant-remnants",
	dying_explosion = "cryogenic-plant-explosion",
	collision_box = { { -3.4, -3.4 }, { 3.4, 3.4 } },
	heating_energy = "100kW",
	selection_box = { { -3.5, -3.5 }, { 3.5, 3.5 } },
	damaged_trigger_effect = hit_effects.entity(),
	drawing_box_vertical_extension = 0.5,
	module_slots = 0,
	icons_positioning = {
		{ inventory_index = defines.inventory.furnace_modules, shift = { 0, 0.95 }, max_icons_per_row = 4 },
	},
	icon_draw_specification = { scale = 2, shift = { 0, -0.3 } },
	allowed_effects = {},
	crafting_categories = {
		"cerys-no-recipes",
	},
	crafting_speed = 1,
	energy_source = {
		type = "void",
	},
	energy_usage = "1000kW",
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/teleporter/teleporter.png",
					width = 650,
					height = 650,
					animation_speed = 0.1,
					repeat_count = 48,
					scale = 0.5,
					shift = util.by_pixel(-1, -4),
					tint = common.FACTORIO_UNDO_FROZEN_TINT,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/teleporter/teleporter-shadow.png",
					width = 650,
					height = 650,
					animation_speed = 0.1,
					repeat_count = 48,
					scale = 0.5,
					shift = util.by_pixel(-1, -4),
					draw_as_shadow = true,
				},
			},
		},
	},
	open_sound = sounds.metal_large_open,
	close_sound = sounds.metal_large_close,
	water_reflection = {
		pictures = util.sprite_load("__space-age__/graphics/entity/foundry/foundry-reflection", {
			scale = 5,
			shift = { 0, 2 },
		}),
		rotate = false,
	},
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 100, 255, 0 },
}

local teleporter_frozen = merge(teleporter, {
	name = "cerys-fulgoran-teleporter-frozen",
	hidden_in_factoriopedia = true,
	crafting_categories = {
		"cerys-no-recipes",
	},
	fast_replaceable_group = "cerys-fulgoran-teleporter",
	energy_source = {
		type = "void",
	},
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/teleporter/teleporter-frozen.png",
					width = 650,
					height = 650,
					animation_speed = 0.1,
					repeat_count = 48,
					scale = 0.5,
					shift = util.by_pixel(-1, -4),
					tint = common.FACTORIO_UNDO_FROZEN_TINT,
				},
			},
		},
	},
})

data:extend({
	teleporter,
	teleporter_frozen,
})
