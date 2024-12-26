local merge = require("lib").merge
local common = require("common")
local hit_effects = require("__base__.prototypes.entity.hit-effects")

local reactor = {
	type = "reactor",
	name = "cerys-fulgoran-radiative-tower",
	subgroup = "cerys-entities",
	order = "a",
	flags = { "placeable-neutral", "not-deconstructable", "not-blueprintable", "not-flammable" },
	max_health = 500,
	corpse = "heating-tower-remnants",
	dying_explosion = "heating-tower-explosion",
	allow_copy_paste = false,
	collision_box = { { -1.25, -1.75 }, { 1.25, 1.75 } },
	selection_box = { { -1.5, -2 }, { 1.5, 2 } },
	damaged_trigger_effect = hit_effects.entity(),
	drawing_box_vertical_extension = 2, -- TODO: Check
	consumption = "350kW",
	energy_source = merge(data.raw.reactor["heating-tower"].energy_source, {
		fuel_categories = { "chemical-or-radiative" },
		effectivity = 0.27,
		fuel_inventory_size = 2, -- not too high so you can see the fuel on belts
		burnt_inventory_size = 0, -- from 2
	}),
	heat_buffer = {
		max_temperature = 200,
		specific_heat = "70kJ",
		max_transfer = "1kW",
		minimum_glow_temperature = 0,
		heat_picture = apply_heat_pipe_glow(
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/light", {
				scale = 0.22,
				blend_mode = "additive",
			})
		),
	},
	picture = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/back", {
				scale = 0.22,
			}),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower", {
				scale = 0.22,
			}),
			-- util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/front", {
			-- 	scale = 0.22,
			-- }),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/shadow", {
				scale = 0.22,
				draw_as_shadow = true,
			}),
		},
	},
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/radiative-tower.png",
	icon_size = 64,
	open_sound = { filename = "__base__/sound/open-close/metal-large-open.ogg", volume = 0.8 },
	close_sound = { filename = "__base__/sound/open-close/metal-large-close.ogg", volume = 0.8 },
	working_sound = {
		sound = { filename = "__base__/sound/heat-pipe.ogg", volume = 1.2 },
		max_sounds_per_type = 2,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
		audible_distance_modifier = 0.9,
	},
	default_temperature_signal = { type = "virtual", name = "signal-T" },
	circuit_wire_max_distance = reactor_circuit_wire_max_distance,
	circuit_connector = circuit_connector_definitions["heating-tower"],
	minable = { mining_time = 1, result = "cerys-fulgoran-radiative-tower" },
	autoplace = {
		probability_expression = "0",
	},
	map_color = { 143, 0, 0 },
}

local frozen_reactor = merge(reactor, {
	name = "cerys-fulgoran-radiative-tower-frozen",
	hidden = true,
	picture = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/back-ice", {
				scale = 0.22,
			}),
			util.sprite_load(
				"__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower",
				-- "__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-ice", -- TODO: Put back to icy tower if it can be distinguished in the landscape (in all locations, not just this one)
				{
					scale = 0.22,
				}
			),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/shadow", {
				scale = 0.22,
				draw_as_shadow = true,
			}),
		},
	},
	working_sound = "nil",
})

local CONTRACTED_MAP_COLOR = { 37, 0, 0 }

local rising_reactor_base = merge(reactor, {
	name = "cerys-fulgoran-radiative-tower-rising-reactor-base",
	render_layer = "wires",
	hidden = true,
	consumption = "0.0000001W",
	picture = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/back-ice", {
				scale = 0.22,
			}),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/shadow-base", {
				scale = 0.22,
				draw_as_shadow = true,
			}),
		},
	},
	map_color = CONTRACTED_MAP_COLOR,
	working_sound = "nil",
	minable = { mining_time = 1, result = "simple-entity-with-owner" }, -- This should never happen, but including it prompts the 'this cannot be mined' text if the created entity is set with minable_flag = false.
})

local rising_reactor_tower_1 = merge(rising_reactor_base, {
	name = "cerys-fulgoran-radiative-tower-rising-reactor-tower-1",
	type = "simple-entity-with-owner",
	render_layer = "above-inserters",
	picture = {
		layers = {
			util.sprite_load(
				"__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-crop-1",
				-- "__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-crop-1-ice", -- TODO: Put back to icy tower if it can be distinguished in the landscape (in all locations, not just this one)
				{
					scale = 0.22,
				}
			),
		},
	},
	minable = nil,
	next_upgrade = nil,
	flags = { "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map" },
	selectable_in_game = false,
	collision_box = { { 0, 0 }, { 0, 0 } },
	selection_box = { { 0, 0 }, { 0, 0 } },
	collision_mask = { layers = {} },
})

local rising_reactor_tower_2 = merge(rising_reactor_tower_1, {
	name = "cerys-fulgoran-radiative-tower-rising-reactor-tower-2",
	picture = {
		layers = {
			util.sprite_load(
				"__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-crop-2",
				-- "__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-crop-2-ice", -- TODO: Put back to icy tower if it can be distinguished in the landscape (in all locations, not just this one)
				{
					scale = 0.22,
				}
			),
		},
	},
})

local rising_reactor_tower_3 = merge(rising_reactor_tower_1, {
	name = "cerys-fulgoran-radiative-tower-rising-reactor-tower-3",
	picture = {
		layers = {
			util.sprite_load(
				"__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower",
				-- "__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-ice", -- TODO: Put back to icy tower if it can be distinguished in the landscape (in all locations, not just this one)
				{
					scale = 0.22,
				}
			),
		},
	},
})

local reactor_base = merge(rising_reactor_tower_1, {
	name = "cerys-fulgoran-radiative-tower-base",
	render_layer = "nil",
	picture = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/back", {
				scale = 0.22,
			}),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/shadow-base", {
				scale = 0.22,
				draw_as_shadow = true,
			}),
		},
	},
})

local reactor_base_frozen = merge(reactor_base, {
	name = "cerys-fulgoran-radiative-tower-base-frozen",
	picture = {
		layers = {
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/back-ice", {
				scale = 0.22,
			}),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/shadow-base", {
				scale = 0.22,
				draw_as_shadow = true,
			}),
		},
	},
})

local container = {
	type = "container",
	name = "cerys-fulgoran-radiative-tower-contracted-container",
	subgroup = "cerys-entities",
	hidden_in_factoriopedia = true,
	flags = { "placeable-neutral", "not-deconstructable", "not-blueprintable", "not-flammable" },
	icon = "__space-age__/graphics/icons/heating-tower.png", -- TODO: Change
	inventory_size = 1,
	max_health = 500,
	corpse = "heating-tower-remnants",
	dying_explosion = "heating-tower-explosion",
	allow_copy_paste = false,
	collision_box = { { -1.25, -1.75 }, { 1.25, 1.75 } },
	selection_box = { { -1.5, -2 }, { 1.5, 2 } },
	drawing_box_vertical_extension = 2, -- TODO: Check
	picture = {
		layers = {
			util.sprite_load(
				"__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-crop-1",
				-- "__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/tower-crop-1-ice", -- TODO: Put back to icy tower if it can be distinguished in the landscape (in all locations, not just this one)
				{
					scale = 0.22,
					shift = util.by_pixel(0, common.RADIATIVE_TOWER_SHIFT_PIXELS),
				}
			),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/back-ice", {
				scale = 0.22,
			}),
			-- util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/front", {
			-- 	scale = 0.22,
			-- }),
			util.sprite_load("__Cerys-Moon-of-Fulgora__/graphics/entity/radiative-tower/shadow-base", {
				scale = 0.22,
				draw_as_shadow = true,
			}),
		},
	},
	open_sound = { filename = "__base__/sound/open-close/metal-large-open.ogg", volume = 0.8 },
	close_sound = { filename = "__base__/sound/open-close/metal-large-close.ogg", volume = 0.8 },
	minable = { mining_time = 1, result = "simple-entity-with-owner" }, -- This should never happen, but including it prompts the 'this cannot be mined' text if the created entity is set with minable_flag = false.
	map_color = CONTRACTED_MAP_COLOR,
}

reactor.fast_replaceable_group = "fulgoran-radiative-tower"
frozen_reactor.fast_replaceable_group = "fulgoran-radiative-tower"

data:extend({
	reactor,
	frozen_reactor,
	rising_reactor_base,
	rising_reactor_tower_1,
	rising_reactor_tower_2,
	rising_reactor_tower_3,
	reactor_base,
	reactor_base_frozen,
	container,
})

for i = 1, 20 do
	data:extend({
		{
			type = "reactor",
			name = "hidden-reactor-" .. i,
			subgroup = "cerys-entities",
			icon = "__space-age__/graphics/icons/heating-tower.png",
			hidden = true,
			flags = { "not-on-map", "placeable-off-grid", "placeable-neutral" },
			collision_mask = { layers = {} },
			collision_box = { { -0, -0 }, { 0, 0 } },
			selection_box = { { -0, -0 }, { 0, 0 } },
			selectable_in_game = false,
			picture = {
				filename = "__core__/graphics/empty.png",
				priority = "extra-high",
				width = 1,
				height = 1,
			},
			consumption = "500MW",
			energy_source = {
				type = "void",
			},
			heating_radius = i,
			heat_buffer = {
				max_temperature = 40,
				specific_heat = "1MJ",
				max_transfer = "500MW",
				connections = {
					{
						position = { 0, 0 },
						direction = defines.direction.north,
					},
					{
						position = { 0, 0 },
						direction = defines.direction.east,
					},
					{
						position = { 0, 0 },
						direction = defines.direction.south,
					},
					{
						position = { 0, 0 },
						direction = defines.direction.west,
					},
				},
			},
		},
	})
end
