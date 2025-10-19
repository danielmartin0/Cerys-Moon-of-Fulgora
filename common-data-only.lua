local Public = {}

Public.K2_INSTALLED = mods["Krastorio2-spaced-out"] or mods["Krastorio2"]
Public.NITRIC_ACID_NAME = Public.K2_INSTALLED and "kr-nitric-acid" or "nitric-acid"
Public.LITHIUM_NAME = Public.K2_INSTALLED and "kr-lithium" or "lithium"

Public.hidden_lamp_base = {
	type = "lamp",
	icon = "__core__/graphics/empty.png",
	flags = { "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map" },
	hidden_in_factoriopedia = true,
	selectable_in_game = false,
	max_health = 1,
	collision_box = { { 0, 0 }, { 0, 0 } },
	selection_box = { { 0, 0 }, { 0, 0 } },
	collision_mask = { layers = {} },
	energy_source = {
		type = "void",
	},
	always_on = true,
	energy_usage_per_tick = "1kW",
	picture_off = {
		filename = "__core__/graphics/empty.png",
		priority = "high",
		width = 1,
		height = 1,
		frame_count = 1,
		axially_symmetrical = false,
		direction_count = 1,
	},
	picture_on = {
		filename = "__core__/graphics/empty.png",
		priority = "high",
		width = 1,
		height = 1,
		frame_count = 1,
		axially_symmetrical = false,
		direction_count = 1,
	},
	glow_size = 6,
	glow_color_intensity = 1,
	glow_render_mode = "multiplicative",
}

return Public
