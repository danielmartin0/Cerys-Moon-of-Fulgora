local merge = require("lib").merge
local common = require("common")

local teleporter = merge(data.raw["assembling-machine"]["cryogenic-plant"], {
	name = "cerys-fulgoran-teleporter",
	subgroup = "cerys-entities",
	order = "z",
	max_health = 20000,
	crafting_categories = {
		"cerys-no-recipes",
	},
	module_slots = 0,
	crafting_speed = 1,
	energy_usage = "1000kW",
	next_upgrade = "nil",
	fast_replaceable_group = "cerys-fulgoran-teleporter",
	minable = "nil",
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 0, 255, 20 },
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cryogenic-plant.png",
	icon_size = 64,
})

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
	-- graphics_set = {
	-- 	animation = {
	-- 		layers = {
	-- 			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/crusher/crusher-wreck-frozen", {
	-- 				animation_speed = 0.1,
	-- 				repeat_count = 48,
	-- 				scale = 0.5,
	-- 				shift = util.by_pixel(3, -6),
	-- 				tint = common.FACTORIO_UNDO_FROZEN_TINT,
	-- 			}),
	-- 		},
	-- 	},
	-- },
	map_color = { 0, 255, 20 },
})

data:extend({
	teleporter,
	teleporter_frozen,
})
