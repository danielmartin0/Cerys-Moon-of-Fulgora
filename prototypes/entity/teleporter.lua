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
	-- map_color = { 83, 17, 150 },
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cryogenic-plant.png",
	icon_size = 64,
})

local wreck = merge(teleporter, {
	name = "cerys-fulgoran-teleporter-wreck",
	hidden_in_factoriopedia = true,
	crafting_categories = { "cerys-teleporter-repair" },
	fixed_recipe = "cerys-repair-teleporter",
	fast_replaceable_group = "cerys-fulgoran-teleporter",
	energy_source = {
		type = "void",
	},
	module_slots = 1,
	allowed_effects = { "speed", "productivity" },
	-- map_color = { 200, 150, 250 },
	working_sound = {
		-- TODO: Improve this sound
		sound = { filename = "__base__/sound/assembling-machine-t2-1.ogg", volume = 0.45 },
		audible_distance_modifier = 0.5,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
	},
})

local wreck_frozen = merge(wreck, {
	name = "cerys-fulgoran-teleporter-wreck-frozen",
})

data:extend({
	teleporter,
	wreck,
	wreck_frozen,
})
