local merge = require("lib").merge
local common = require("common")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local original_ice_transitions = {
	{
		to_tiles = water_tile_type_names,
		transition_group = water_transition_group_id,

		spritesheet = "__space-age__/graphics/terrain/water-transitions/ice-2.png",
		layout = tile_spritesheet_layout.transition_16_16_16_4_4,
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-mask.png",
			inner_corner_count = 8,
			outer_corner_count = 8,
			side_count = 8,
			u_transition_count = 2,
			o_transition_count = 1,
		},
	},
	{
		to_tiles = lava_tile_type_names,
		transition_group = lava_transition_group_id,
		spritesheet = "__space-age__/graphics/terrain/water-transitions/lava-stone.png",
		-- this added the lightmap spritesheet
		layout = tile_spritesheet_layout.transition_16_16_16_4_4,
		lightmap_layout = { spritesheet = "__space-age__/graphics/terrain/water-transitions/lava-stone-lightmap.png" },
		-- this added the lightmap spritesheet
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-mask.png",
			inner_corner_count = 8,
			outer_corner_count = 8,
			side_count = 8,
			u_transition_count = 2,
			o_transition_count = 1,
		},
	},
	{
		to_tiles = { "out-of-map", "empty-space", "oil-ocean-shallow" },
		transition_group = out_of_map_transition_group_id,

		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,

		spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
		layout = tile_spritesheet_layout.transition_4_4_8_1_1,
		overlay_enabled = false,
	},
}

local original_ice_transitions_between_transitions = {
	{
		transition_group1 = default_transition_group_id,
		transition_group2 = water_transition_group_id,

		spritesheet = "__space-age__/graphics/terrain/water-transitions/ice-transition.png",
		layout = tile_spritesheet_layout.transition_3_3_3_1_0,
		background_enabled = false,
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-to-land-mask.png",
			o_transition_count = 0,
		},
		water_patch = {
			filename = "__space-age__/graphics/terrain/water-transitions/ice-patch.png",
			scale = 0.5,
			width = 64,
			height = 64,
		},
	},
	{
		transition_group1 = default_transition_group_id,
		transition_group2 = out_of_map_transition_group_id,

		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,

		spritesheet = "__base__/graphics/terrain/out-of-map-transition/dirt-out-of-map-transition.png",
		layout = tile_spritesheet_layout.transition_3_3_3_1_0,
		overlay_enabled = false,
	},
	{
		transition_group1 = water_transition_group_id,
		transition_group2 = out_of_map_transition_group_id,

		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,

		spritesheet = "__base__/graphics/terrain/out-of-map-transition/dry-dirt-shore-out-of-map-transition.png",
		layout = tile_spritesheet_layout.transition_3_3_3_1_0,
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-to-out-of-map-mask.png",
			u_transition_count = 0,
			o_transition_count = 0,
		},
	},
}

--== Transitions ==--

local water_ice_transitions = original_ice_transitions
water_ice_transitions[1].spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-2.png"
table.insert(water_ice_transitions[1].to_tiles, "cerys-water-puddles")
table.insert(water_ice_transitions[1].to_tiles, "cerys-water-puddles-freezing")
for _, tile_name in pairs(common.ROCK_TILES) do
	table.insert(water_ice_transitions[1].to_tiles, tile_name)
end

local water_ice_transitions_between_transitions = original_ice_transitions_between_transitions
water_ice_transitions_between_transitions[1].spritesheet =
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-transition.png"
water_ice_transitions_between_transitions[1].water_patch.filename =
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-patch.png"

local dry_ice_transitions = util.table.deepcopy(water_ice_transitions)
dry_ice_transitions[1].to_tiles = {
	"cerys-water-puddles",
	"cerys-water-puddles-freezing",
	"cerys-ice-on-water",
	"cerys-ice-on-water-melting",
	-- "nuclear-scrap-under-ice",
	-- "nuclear-scrap-under-ice-melting",
	-- "ice-supporting-nuclear-scrap",
	-- "ice-supporting-nuclear-scrap-freezing",
}
for _, tile_name in pairs(common.ROCK_TILES) do
	table.insert(dry_ice_transitions[1].to_tiles, tile_name)
end
dry_ice_transitions[1].transition_group = 184 -- Arbitrary number

local dry_ice_transitions_between_transitions = util.table.deepcopy(water_ice_transitions_between_transitions)
dry_ice_transitions_between_transitions[1].transition_group2 = 184

local rock_ice_transitions = util.table.deepcopy(data.raw.tile["ice-rough"].transitions)
rock_ice_transitions[1].spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-2.png"
table.insert(rock_ice_transitions[1].to_tiles, "cerys-ash-cracks")
table.insert(rock_ice_transitions[1].to_tiles, "cerys-ash-dark")
table.insert(rock_ice_transitions[1].to_tiles, "cerys-ash-flats")
table.insert(rock_ice_transitions[1].to_tiles, "cerys-ash-light")
table.insert(rock_ice_transitions[1].to_tiles, "cerys-pumice-stones")

local rock_ice_transitions_between_transitions =
	util.table.deepcopy(data.raw.tile["ice-rough"].transitions_between_transitions)
rock_ice_transitions_between_transitions[1].spritesheet =
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-transition.png"
rock_ice_transitions_between_transitions[1].water_patch.filename =
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-patch.png"

table.insert(water_tile_type_names, "cerys-water-puddles")
table.insert(water_tile_type_names, "cerys-water-puddles-freezing")

--== Collision Masks ==--
local cerys_ground_collision_mask = merge(tile_collision_masks.ground(), {
	layers = merge((tile_collision_masks.ground().layers or {}), {
		cerys_tile = true,
	}),
})

local cerys_shallow_water_collision_mask = merge(tile_collision_masks.shallow_water(), {
	layers = merge((tile_collision_masks.shallow_water().layers or {}), {
		cerys_tile = true,
	}),
})

--== Rock Ice ==--
local cerys_rock_base = merge(data.raw.tile["volcanic-ash-cracks"], {
	sprite_usage_surface = "nil",
	collision_mask = cerys_ground_collision_mask,
})

local lightmap_spritesheet = {
	max_size = 4,
	[1] = {
		weights = {
			0.085,
			0.085,
			0.085,
			0.085,
			0.087,
			0.085,
			0.065,
			0.085,
			0.045,
			0.045,
			0.045,
			0.045,
			0.005,
			0.025,
			0.045,
			0.045,
		},
	},
	[2] = {
		probability = 1,
		weights = {
			0.018,
			0.020,
			0.015,
			0.025,
			0.015,
			0.020,
			0.025,
			0.015,
			0.025,
			0.025,
			0.010,
			0.025,
			0.020,
			0.025,
			0.025,
			0.010,
		},
	},
	[4] = {
		probability = 0.1,
		weights = {
			0.018,
			0.020,
			0.015,
			0.025,
			0.015,
			0.020,
			0.025,
			0.015,
			0.025,
			0.025,
			0.010,
			0.025,
			0.020,
			0.025,
			0.025,
			0.010,
		},
	},
}

data:extend({
	merge(cerys_rock_base, {
		name = "cerys-ash-cracks",
		frozen_variant = "cerys-ash-cracks-frozen",
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-cracks.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-cracks-frozen",
		autoplace = {
			probability_expression = "if(cerys_surface>0, 1000 + cerys_ash_cracks, -1000)",
		},
		thawed_variant = "cerys-ash-cracks",
		layer = 48,
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-cracks-frozen.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-dark",
		frozen_variant = "cerys-ash-dark-frozen",
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-dark.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-dark-frozen",
		autoplace = {
			probability_expression = "if(cerys_surface>0, 1000 + cerys_ash_dark, -1000)",
		},
		thawed_variant = "cerys-ash-dark",
		layer = 48,
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-dark-frozen.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-flats",
		frozen_variant = "cerys-ash-flats-frozen",
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-flats.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-flats-frozen",
		thawed_variant = "cerys-ash-flats",
		layer = 48,
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-flats-frozen.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-light",
		frozen_variant = "cerys-ash-light-frozen",
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-light.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-ash-light-frozen",
		autoplace = {
			probability_expression = "if(cerys_surface>0, 1000 + cerys_ash_light, -1000)",
		},
		thawed_variant = "cerys-ash-light",
		layer = 48,
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-ash-light-frozen.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-pumice-stones",
		frozen_variant = "cerys-pumice-stones-frozen",
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-pumice-stones.png",
			lightmap_spritesheet
		),
	}),
	merge(cerys_rock_base, {
		name = "cerys-pumice-stones-frozen",
		autoplace = {
			probability_expression = "if(cerys_surface>0, 1000 + cerys_pumice_stones, -1000)",
		},
		thawed_variant = "cerys-pumice-stones",
		layer = 48,
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/moon-pumice-stones-frozen.png",
			lightmap_spritesheet
		),
	}),
})

--== Water Ice ==--

local cerys_brash_ice_base = merge(data.raw.tile["brash-ice"], {
	fluid = "water",
	collision_mask = cerys_shallow_water_collision_mask,
	default_cover_tile = "foundation",
	autoplace = "nil",
	sprite_usage_surface = "nil",
	map_color = { 8, 39, 94 },
})

data:extend({
	merge(cerys_brash_ice_base, {
		name = "cerys-water-puddles",
		frozen_variant = "cerys-water-puddles-freezing",
		autoplace = {
			probability_expression = "0",
		},
	}),
	merge(cerys_brash_ice_base, {
		name = "cerys-water-puddles-freezing",
		thawed_variant = "cerys-water-puddles",
	}),
})

local cerys_ice_on_water_base = merge(data.raw.tile["ice-smooth"], {
	transitions = water_ice_transitions,
	transitions_between_transitions = water_ice_transitions_between_transitions,
	collision_mask = cerys_ground_collision_mask,
	sprite_usage_surface = "nil",
	map_color = { 8, 39, 94 },
})

data:extend({
	merge(cerys_ice_on_water_base, {
		name = "cerys-ice-on-water",
		thawed_variant = "cerys-ice-on-water-melting",
		autoplace = {
			probability_expression = "min(0, 1000000 * cerys_surface) + 100 * cerys_water",
		},
	}),
	merge(cerys_ice_on_water_base, {
		name = "cerys-ice-on-water-melting",
		frozen_variant = "cerys-ice-on-water",
		autoplace = "nil",
	}),
})

--== Dry ice ==--

local dry_ice_rough_variants = tile_variations_template(
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/dry-ice-rough.png",
	"__base__/graphics/terrain/masks/transition-4.png",
	{
		max_size = 4,
		[1] = {
			weights = {
				0.085,
				0.085,
				0.085,
				0.085,
				0.087,
				0.085,
				0.065,
				0.085,
				0.045,
				0.045,
				0.045,
				0.045,
				0.005,
				0.025,
				0.045,
				0.045,
			},
		},
		[2] = {
			probability = 1,
			weights = {
				0.018,
				0.020,
				0.015,
				0.025,
				0.015,
				0.020,
				0.025,
				0.015,
				0.025,
				0.025,
				0.010,
				0.025,
				0.020,
				0.025,
				0.025,
				0.010,
			},
		},
		[4] = {
			probability = 0.1,
			weights = {
				0.018,
				0.020,
				0.015,
				0.025,
				0.015,
				0.020,
				0.025,
				0.015,
				0.025,
				0.025,
				0.010,
				0.025,
				0.020,
				0.025,
				0.025,
				0.010,
			},
		},
		--[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
	}
)

local cerys_dry_ice_rough_base = merge(data.raw.tile["ice-rough"], {
	transitions = dry_ice_transitions,
	transitions_between_transitions = dry_ice_transitions_between_transitions,
	collision_mask = cerys_ground_collision_mask,
	autoplace = "nil",
	variants = dry_ice_rough_variants,
	sprite_usage_surface = "nil",
	layer_group = "ground-artificial", -- Above crater decals
	map_color = { 128, 184, 194 },
})

data:extend({
	merge(cerys_dry_ice_rough_base, {
		name = "cerys-dry-ice-on-water",
		thawed_variant = "cerys-dry-ice-on-water-melting",
	}),
	merge(cerys_dry_ice_rough_base, {
		name = "cerys-dry-ice-on-water-melting",
		frozen_variant = "cerys-dry-ice-on-water",
	}),
})

local dry_ice_rough_land_variants = tile_variations_template(
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/dry-ice-rough-land.png",
	"__base__/graphics/terrain/masks/transition-4.png",
	{
		max_size = 4,
		[1] = {
			weights = {
				0.085,
				0.085,
				0.085,
				0.085,
				0.087,
				0.085,
				0.065,
				0.085,
				0.045,
				0.045,
				0.045,
				0.045,
				0.005,
				0.025,
				0.045,
				0.045,
			},
		},
		[2] = {
			probability = 1,
			weights = {
				0.018,
				0.020,
				0.015,
				0.025,
				0.015,
				0.020,
				0.025,
				0.015,
				0.025,
				0.025,
				0.010,
				0.025,
				0.020,
				0.025,
				0.025,
				0.010,
			},
		},
		[4] = {
			probability = 0.1,
			weights = {
				0.018,
				0.020,
				0.015,
				0.025,
				0.015,
				0.020,
				0.025,
				0.015,
				0.025,
				0.025,
				0.010,
				0.025,
				0.020,
				0.025,
				0.025,
				0.010,
			},
		},
		--[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
	}
)

local cerys_dry_ice_rough_land_base = merge(data.raw.tile["ice-rough"], {
	transitions = dry_ice_transitions,
	transitions_between_transitions = dry_ice_transitions_between_transitions,
	collision_mask = cerys_ground_collision_mask,
	autoplace = "nil",
	variants = dry_ice_rough_land_variants,
	sprite_usage_surface = "nil",
	layer_group = "ground-artificial", -- Above crater decals
	map_color = { 92, 138, 116 },
})

data:extend({
	merge(cerys_dry_ice_rough_land_base, {
		name = "cerys-dry-ice-on-land",
		thawed_variant = "cerys-dry-ice-on-land-melting",
	}),
	merge(cerys_dry_ice_rough_land_base, {
		name = "cerys-dry-ice-on-land-melting",
		frozen_variant = "cerys-dry-ice-on-land",
	}),
})

--== Concrete (supporting script entities from water) ==--
data:extend({
	merge(data.raw.tile["concrete"], {
		name = "cerys-concrete",
		minable = "nil",
	}),
})
