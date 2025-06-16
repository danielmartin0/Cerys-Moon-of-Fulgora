local merge = require("lib").merge

data:extend({
	{
		type = "sound",
		name = "cerys-teleporter-1",
		category = "game-effect",
		priority = 200,
		filename = "__Cerys-Moon-of-Fulgora__/sounds/teleporter_1.ogg",
	},
	{
		type = "sound",
		name = "cerys-teleporter-2",
		category = "game-effect",
		priority = 200,
		filename = "__Cerys-Moon-of-Fulgora__/sounds/teleporter_2.ogg",
	},
	{
		type = "sound",
		name = "cerys-radiation-exposure",
		audible_distance_modifier = 0.7, --multiplies the default 40 tiles of audible distance by this number
		category = "game-effect",
		priority = 180,
		variations = {
			{
				filename = "__base__/sound/bullets/bullet-impact-stone-5.ogg",
				min_speed = 1.6,
				max_speed = 2,
			},
		},
	},
	{
		type = "sound",
		name = "cerys-radiation-impact",
		audible_distance_modifier = 0.8,
		category = "game-effect",
		priority = 250,
		variations = {
			{
				filename = "__base__/sound/bullets/bullet-impact-stone-4.ogg",
			},
			{
				filename = "__base__/sound/bullets/bullet-impact-stone-5.ogg",
			},
			{
				filename = "__base__/sound/bullets/bullet-impact-stone-6.ogg",
			},
		},
	},
	{
		type = "sound",
		name = "cerys-fulgoran-tower-opening",
		category = "game-effect",
		priority = 200,
		filename = "__Cerys-Moon-of-Fulgora__/sounds/vehicle-surface-metal-rock-truncated.ogg",
	},
	{
		type = "sound",
		name = "cerys-excavation",
		category = "game-effect",
		priority = 250,
		variations = {
			{
				filename = "__base__/sound/burner-mining-drill-1.ogg",
				min_speed = 0.4,
				max_speed = 1,
			},
			{
				filename = "__base__/sound/burner-mining-drill-2.ogg",
				min_speed = 0.4,
				max_speed = 1,
			},
		},
	},
	{
		type = "sound",
		name = "cerys-repair",
		category = "game-effect",
		priority = 240,
		variations = {
			{
				filename = "__base__/sound/centrifuge-1.ogg",
				min_speed = 0.2,
				max_speed = 0.8,
			},
			{
				filename = "__base__/sound/centrifuge-2.ogg",
				min_speed = 0.2,
				max_speed = 0.8,
			},
			{
				filename = "__base__/sound/centrifuge-3.ogg",
				min_speed = 0.2,
				max_speed = 0.8,
			},
		},
	},
	merge(data.raw["ambient-sound"]["aquilo-4"], {
		name = "cerys-1",
		planet = "cerys",
		track_type = "hero-track",
		weight = "nil",
	}),
	merge(data.raw["ambient-sound"]["aquilo-5"], {
		name = "cerys-2",
		planet = "cerys",
	}),
	merge(data.raw["ambient-sound"]["fulgora-4"], {
		name = "cerys-3",
		planet = "cerys",
	}),
	merge(data.raw["ambient-sound"]["aquilo-6"], {
		name = "cerys-4",
		planet = "cerys",
	}),
	merge(data.raw["ambient-sound"]["fulgora-6"], {
		name = "cerys-5",
		planet = "cerys",
	}),
	merge(data.raw["ambient-sound"]["space-6"], {
		name = "cerys-6",
		planet = "cerys",
	}),
	merge(data.raw["ambient-sound"]["fulgora-9"], {
		name = "cerys-7",
		planet = "cerys",
	}),
	merge(data.raw["ambient-sound"]["fulgora-5"], {
		name = "cerys-8",
		planet = "cerys",
	}),
})
