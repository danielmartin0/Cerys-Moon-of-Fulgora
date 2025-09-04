local merge = require("lib").merge
local common = require("common")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

table.insert(water_tile_type_names, "cerys-water-puddles")
table.insert(water_tile_type_names, "cerys-water-puddles-freezing")

local adjusted_original_ice_transitions = {
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
		to_tiles = common.SPACE_TILES_AROUND_CERYS,
		transition_group = out_of_map_transition_group_id,

		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,

		spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
		layout = tile_spritesheet_layout.transition_4_4_8_1_1,
		overlay_enabled = false,
	},
}

local adjusted_original_ice_transitions_between_transitions = {
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

--== Ground collision mask ==--

local cerys_ground_collision_mask = merge(tile_collision_masks.ground(), {
	layers = merge((tile_collision_masks.ground().layers or {}), {
		cerys_tile = true,
	}),
})

--== Rock & Rock Ice ==--

local adjusted_original_rock_transitions = {
	{
		to_tiles = water_tile_type_names,
		transition_group = water_transition_group_id,
		spritesheet = "__space-age__/graphics/terrain/water-transitions/lava-stone-cold.png",
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
		lightmap_layout = { spritesheet = "__space-age__/graphics/terrain/water-transitions/lava-stone-lightmap.png" },
		layout = tile_spritesheet_layout.transition_16_16_16_4_4,
		effect_map_layout = {
			spritesheet = "__space-age__/graphics/terrain/effect-maps/lava-dirt-mask.png",
			inner_corner_count = 8,
			outer_corner_count = 8,
			side_count = 8,
			u_transition_count = 2,
			o_transition_count = 1,
		},
	},
	{
		to_tiles = common.SPACE_TILES_AROUND_CERYS,
		transition_group = out_of_map_transition_group_id,
		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,
		spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
		layout = tile_spritesheet_layout.transition_4_4_8_1_1,
		overlay_enabled = false,
	},
}

-- stylua: ignore
local cerys_rock_base = merge(data.raw.tile["volcanic-ash-cracks"], {
	sprite_usage_surface = "any",
	collision_mask = cerys_ground_collision_mask,
	subgroup = "cerys-tiles",
	transitions = adjusted_original_rock_transitions,
})

-- stylua: ignore
local lightmap_spritesheet = {
	max_size = 4,
	[1] = {
		weights = { 0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 },
	},
	[2] = {
		probability = 1,
		weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 },
	},
	[4] = {
		probability = 0.1,
		weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 },
	},
}

local function create_base_tile(name, layer, force_hidden)
	return merge(cerys_rock_base, {
		name = name,
		frozen_variant = name .. "-frozen",
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/" .. name .. ".png",
			lightmap_spritesheet
		),
		layer = layer,
		hidden = force_hidden and true or cerys_rock_base.hidden,
	})
end

local frozen_rock_transitions = util.table.deepcopy(adjusted_original_rock_transitions)
frozen_rock_transitions[#frozen_rock_transitions + 1] = {
	to_tiles = {
		"cerys-ash-cracks",
		"cerys-ash-dark",
		"cerys-ash-light",
		"cerys-pumice-stones",
		"cerys-water-puddles",
		"cerys-water-puddles-freezing",
		"cerys-ice-on-water",
		"cerys-ice-on-water-melting",
	},
	transition_group = water_transition_group_id,
	spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-2-transparent.png",
	layout = tile_spritesheet_layout.transition_16_16_16_4_4,
	effect_map_layout = {
		spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-mask.png",
		inner_corner_count = 8,
		outer_corner_count = 8,
		side_count = 8,
		u_transition_count = 2,
		o_transition_count = 1,
	},
}

local function create_frozen_variant(name, layer, force_hidden)
	local noise_var = string.gsub(name, "%-", "_")
	return merge(cerys_rock_base, {
		name = name .. "-frozen",
		autoplace = {
			probability_expression = "if(cerys_surface>0, 1000 + " .. noise_var .. ", -1000)",
		},
		thawed_variant = name,
		layer = layer,
		hidden = force_hidden and true or cerys_rock_base.hidden,
		variants = tile_variations_template_with_transitions(
			"__Cerys-Moon-of-Fulgora__/graphics/terrain/" .. name .. "-frozen.png",
			lightmap_spritesheet
		),
		layer_group = "ground-artificial", -- Above crater decals
		transitions = frozen_rock_transitions,
	})
end

local function create_melting_variant(name, layer, force_hidden)
	local frozen_variant = create_frozen_variant(name, layer)
	return merge(frozen_variant, {
		name = frozen_variant.name .. "-from-dry-ice",
		thawed_variant = "nil",
		factoriopedia_alternative = frozen_variant.name,
	})
end

data:extend({
	create_base_tile("cerys-ash-cracks", 5),
	create_frozen_variant("cerys-ash-cracks", 10),
	create_melting_variant("cerys-ash-cracks", 10),

	create_base_tile("cerys-ash-dark", 6),
	create_frozen_variant("cerys-ash-dark", 10), -- sadly, we don't have graphics for tile transitions between frozen variants due to miscoloration in the rough ice transitions in the base game, so this has to be the same layer as above
	create_melting_variant("cerys-ash-dark", 10),

	create_base_tile("cerys-ash-light", 7, true),
	create_frozen_variant("cerys-ash-light", 10, true),
	create_melting_variant("cerys-ash-light", 10),

	create_base_tile("cerys-pumice-stones", 8),
	create_frozen_variant("cerys-pumice-stones", 10),
	create_melting_variant("cerys-pumice-stones", 10),
})

-- data.raw.tile["cerys-ash-cracks-frozen"].variants.transition.overlay_layer_group = "top"
-- data.raw.tile["cerys-ash-cracks-frozen"].variants.transition.overlay_layer_offset = 1
-- data.raw.tile["cerys-ash-cracks-frozen"].variants.transition.background_layer_group = "top"
-- data.raw.tile["cerys-ash-cracks-frozen"].variants.transition.background_layer_offset = 1
-- data.raw.tile["cerys-ash-cracks-frozen"].variants.transition.offset_background_layer_by_tile_layer = 1
-- log(serpent.block(data.raw.tile["cerys-ash-cracks-frozen"]))

--== Water ==--

local cerys_shallow_water_base = merge(data.raw.tile["brash-ice"], {
	fluid = "water",
	subgroup = "cerys-tiles",
	collision_mask = {
		layers = {
			water_tile = true,
			floor = true,
			resource = true,
			cerys_tile = true,
			doodad = true,
		},
	},
	effect = "cerys-water-puddles-2",
	autoplace = "nil",
	sprite_usage_surface = "any",
	map_color = { 8, 39, 94 },
	default_cover_tile = "ice-platform",
	walking_speed_modifier = 0.8,
})

data:extend({
	merge(cerys_shallow_water_base, {
		name = "cerys-water-puddles",
		frozen_variant = "cerys-water-puddles-freezing",
		autoplace = {
			probability_expression = "0",
		},
	}),
	merge(cerys_shallow_water_base, {
		name = "cerys-water-puddles-freezing",
		thawed_variant = "cerys-water-puddles",
		factoriopedia_alternative = "cerys-water-puddles",
	}),
	merge(data.raw["tile-effect"]["brash-ice-2"], {
		name = "cerys-water-puddles-2",
		water = merge(data.raw["tile-effect"]["brash-ice-2"].water, {
			textures = {
				{
					filename = "__space-age__/graphics/terrain/gleba/watercaustics.png",
					width = 512,
					height = 512,
				},
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/terrain/cerys-shallow-water.png",
					width = 512 * 4,
					height = 512 * 2,
				},
			},
		}),
	}),
})

--== Iced Water ==--

local water_ice_transitions = util.table.deepcopy(adjusted_original_ice_transitions)
water_ice_transitions[1].spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-2.png"
table.insert(water_ice_transitions[1].to_tiles, "cerys-water-puddles")
table.insert(water_ice_transitions[1].to_tiles, "cerys-water-puddles-freezing")
table.insert(water_ice_transitions[1].to_tiles, "cerys-ash-cracks")
table.insert(water_ice_transitions[1].to_tiles, "cerys-ash-dark")
table.insert(water_ice_transitions[1].to_tiles, "cerys-ash-light")
table.insert(water_ice_transitions[1].to_tiles, "cerys-pumice-stones")

local water_ice_transitions_between_transitions = adjusted_original_ice_transitions_between_transitions
water_ice_transitions_between_transitions[1].spritesheet =
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-transition.png"
water_ice_transitions_between_transitions[1].water_patch.filename =
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/ice-patch.png"

local cerys_ice_on_water_base = merge(data.raw.tile["ice-smooth"], {
	transitions = water_ice_transitions,
	transitions_between_transitions = water_ice_transitions_between_transitions,
	collision_mask = cerys_ground_collision_mask,
	sprite_usage_surface = "any",
	map_color = { 8, 39, 94 },
	layer = 9,
	layer_group = "ground-artificial", -- Above crater decals
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

-- stylua: ignore
local dry_ice_rough_variants = tile_variations_template(
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/dry-ice-rough.png",
	"__base__/graphics/terrain/masks/transition-4.png",
	{
		max_size = 4,
		[1] = {
			weights = { 0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 },
		},
		[2] = {
			probability = 1,
			weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 },
		},
		[4] = {
			probability = 0.1,
			weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 },
		},
		--[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
	}
)

local dry_ice_transitions = util.table.deepcopy(water_ice_transitions)
dry_ice_transitions[1].to_tiles = {
	"stone-path",
	"cerys-water-puddles",
	"cerys-water-puddles-freezing",
	"cerys-ice-on-water",
	"cerys-ice-on-water-melting",
	"cerys-concrete",
	"cerys-refined-concrete",
	"cerys-hazard-concrete-left",
	"cerys-hazard-concrete-right",
	"cerys-refined-hazard-concrete-left",
	"cerys-refined-hazard-concrete-right",
	"cerys-frozen-concrete",
	"cerys-frozen-refined-concrete",
	"cerys-frozen-hazard-concrete-left",
	"cerys-frozen-hazard-concrete-right",
	"cerys-frozen-refined-hazard-concrete-left",
	"cerys-frozen-refined-hazard-concrete-right",
	"cerys-concrete-minable",
	"cerys-frozen-concrete-minable",
	"cerys-foundation",
	"cerys-ice-platform",
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

local cerys_dry_ice_rough_base = merge(data.raw.tile["ice-rough"], {
	subgroup = "cerys-tiles",
	transitions = dry_ice_transitions,
	transitions_between_transitions = dry_ice_transitions_between_transitions,
	collision_mask = cerys_ground_collision_mask,
	autoplace = "nil",
	variants = dry_ice_rough_variants,
	sprite_usage_surface = "any",
	layer_group = "ground-artificial", -- Above crater decals
	map_color = { 128, 184, 194 },
	allows_being_covered = false,
	walking_speed_modifier = 0.9,
})

data:extend({
	merge(cerys_dry_ice_rough_base, {
		name = "cerys-dry-ice-on-water",
		thawed_variant = "cerys-dry-ice-on-water-melting",
		collision_mask = cerys_ground_collision_mask,
		layer = 80,
	}),
	merge(cerys_dry_ice_rough_base, {
		name = "cerys-dry-ice-on-water-melting",
		frozen_variant = "cerys-dry-ice-on-water",
		collision_mask = cerys_ground_collision_mask,
		layer = 81,
		factoriopedia_alternative = "cerys-dry-ice-on-water",
	}),
})

-- stylua: ignore
local dry_ice_rough_land_variants = tile_variations_template(
	"__Cerys-Moon-of-Fulgora__/graphics/terrain/dry-ice-rough-land.png",
	"__base__/graphics/terrain/masks/transition-4.png",
	{
		max_size = 4,
		[1] = {
			weights = { 0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 },
		},
		[2] = {
			probability = 1,
			weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 },
		},
		[4] = {
			probability = 0.1,
			weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 },
		},
		--[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
	}
)

local cerys_dry_ice_rough_land_base = merge(cerys_dry_ice_rough_base, {
	variants = dry_ice_rough_land_variants,
	map_color = { 92, 138, 116 },
})

data:extend({
	merge(cerys_dry_ice_rough_land_base, {
		name = "cerys-dry-ice-on-land",
		thawed_variant = "cerys-dry-ice-on-land-melting",
		layer = 82,
	}),
	merge(cerys_dry_ice_rough_land_base, {
		name = "cerys-dry-ice-on-land-melting",
		frozen_variant = "cerys-dry-ice-on-land",
		layer = 83,
		factoriopedia_alternative = "cerys-dry-ice-on-land",
	}),
})

--== Concrete ==--

-- local concrete_edges_overlay_layout = {
-- 	inner_corner = {
-- 		spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/concrete-inner-corner.png",
-- 		count = 16,
-- 		scale = 0.5,
-- 	},
-- 	outer_corner = {
-- 		spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/concrete-outer-corner.png",
-- 		count = 8,
-- 		scale = 0.5,
-- 	},
-- 	side = {
-- 		spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/concrete-side.png",
-- 		count = 16,
-- 		scale = 0.5,
-- 	},
-- 	u_transition = {
-- 		spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/concrete-u.png",
-- 		count = 8,
-- 		scale = 0.5,
-- 	},
-- 	o_transition = {
-- 		spritesheet = "__Cerys-Moon-of-Fulgora__/graphics/terrain/concrete-o.png",
-- 		count = 4,
-- 		scale = 0.5,
-- 	},
-- }

local function create_cerys_concrete(name_stem, frozen, item_name, transition_merge_tile)
	local name_without_cerys = frozen and "frozen-" .. name_stem or name_stem
	local name = "cerys-" .. name_without_cerys

	local tile = merge(data.raw.tile[name_without_cerys], {
		name = name,
		localised_name = { "tile-name." .. name_without_cerys },
		localised_description = { "tile-description." .. name_without_cerys },
		subgroup = "cerys-tiles",
		-- minable = "nil",
		placeable_by = { item = item_name, count = 1 },
		factoriopedia_alternative = frozen and "nil" or name_without_cerys,
		hidden = frozen and "nil" or true,
		can_be_part_of_blueprint = true,
	})

	tile.transition_merges_with_tile = transition_merge_tile

	if frozen then
		tile.thawed_variant = "cerys-" .. name_stem
	else
		tile.frozen_variant = "cerys-frozen-" .. name_stem
	end

	if frozen then
		tile.variants = {
			-- overlay_layout = concrete_edges_overlay_layout, -- Using our edge graphics caused the frozen concrete's tile transitions to fail to merge with regular concrete. Presumably, that's because Factorio checks that you're using the same images. (In vanilla, they have the same overlay so it doesn't matter.)
			material_background = {
				picture = "__Cerys-Moon-of-Fulgora__/graphics/terrain/frozen-" .. name_stem .. ".png",
				count = 8,
				scale = 0.5,
			},
			transition = { -- Similar to vanilla frozen concrete
				mask_layout = {
					inner_corner = {
						spritesheet = "__base__/graphics/terrain/concrete/hazard-concrete-inner-corner-mask.png",
						count = 1,
						scale = 0.5,
					},
					outer_corner = {
						spritesheet = "__base__/graphics/terrain/concrete/hazard-concrete-outer-corner-mask.png",
						count = 1,
						scale = 0.5,
					},
					side = {
						spritesheet = "__base__/graphics/terrain/concrete/hazard-concrete-side-mask.png",
						count = 1,
						scale = 0.5,
					},
					u_transition = {
						spritesheet = "__base__/graphics/terrain/concrete/hazard-concrete-u-mask.png",
						count = 1,
						scale = 0.5,
					},
					o_transition = {
						spritesheet = "__base__/graphics/terrain/concrete/hazard-concrete-o-mask.png",
						count = 1,
						scale = 0.5,
					},
				},
				-- apply_effect_color_to_overlay = true, -- Wish this worked!
			},
		}
	end

	tile.collision_mask.layers.cerys_tile = true

	if name_stem == "concrete" then
		data:extend({
			merge(tile, {
				name = name .. "-minable",
				frozen_variant = frozen and "nil" or "cerys-frozen-" .. name_stem .. "-minable",
				thawed_variant = frozen and "cerys-" .. name_stem .. "-minable" or "nil",
			}),
		})

		-- The following tile is used for machine on water. Unfortunately, it's stuck on the default namespace because Factorio cannot migrate the names of hidden tiles.
		tile.transition_merges_with_tile = frozen and "cerys-concrete" or nil
		data:extend({
			merge(tile, {

				minable = "nil",
				can_be_part_of_blueprint = false,
			}),
		})
	else
		data:extend({ tile })
	end
end

create_cerys_concrete("concrete", false, "concrete", nil)
create_cerys_concrete("concrete", true, "concrete", "cerys-concrete-minable")

for _, name in pairs({
	"hazard-concrete-left",
	"hazard-concrete-right",
}) do
	create_cerys_concrete(name, false, "hazard-concrete", "cerys-concrete-minable")
	create_cerys_concrete(name, true, "hazard-concrete", "cerys-concrete-minable")
end

create_cerys_concrete("refined-concrete", false, "refined-concrete", nil)
create_cerys_concrete("refined-concrete", true, "refined-concrete", "cerys-refined-concrete")

for _, name in pairs({
	"refined-hazard-concrete-left",
	"refined-hazard-concrete-right",
}) do
	create_cerys_concrete(name, false, "refined-hazard-concrete", "cerys-refined-concrete")
	create_cerys_concrete(name, true, "refined-hazard-concrete", "cerys-refined-concrete")
end

--== Other cloned tiles ==--

local foundation_layers = data.raw.tile.foundation.collision_mask.layers
local ice_platform_layers = data.raw.tile["ice-platform"].collision_mask.layers

data:extend({
	merge(data.raw.tile.foundation, {
		name = "cerys-foundation",
		subgroup = "cerys-tiles",
		localised_name = { "tile-name.foundation" },
		localised_description = { "tile-description.foundation" },
		placeable_by = { item = "foundation", count = 1 },
		factoriopedia_alternative = "foundation",
		hidden = true,
		can_be_part_of_blueprint = true,
		collision_mask = merge(data.raw.tile.foundation.collision_mask, {
			layers = foundation_layers,
		}),
		is_foundation = false,
	}),
	merge(data.raw.tile["ice-platform"], {
		name = "cerys-ice-platform",
		subgroup = "cerys-tiles",
		localised_name = { "tile-name.ice-platform" },
		localised_description = { "tile-description.ice-platform" },
		placeable_by = { item = "ice-platform", count = 1 },
		factoriopedia_alternative = "ice-platform",
		hidden = true,
		can_be_part_of_blueprint = true,
		collision_mask = merge(data.raw.tile["ice-platform"].collision_mask, {
			layers = ice_platform_layers,
		}),
		is_foundation = false,
	}),
})

--== Empty space ==--

local cerys_empty = merge(data.raw.tile["empty-space"], {
	subgroup = "cerys-tiles",
	name = "cerys-empty-space", -- Legacy tile. We're not migrating it so not to break old saves
	destroys_dropped_items = true,
	factoriopedia_alternative = "cerys-empty-space-2",
})
if not cerys_empty.collision_mask then
	cerys_empty.collision_mask = { layers = {} }
end
cerys_empty.collision_mask.layers.cerys_tile = true
table.insert(out_of_map_tile_type_names, "cerys-empty-space")

local cerys_empty_2 = merge(data.raw.tile["empty-space"], {
	subgroup = "cerys-tiles",
	name = "cerys-empty-space-2", -- Legacy tile. We're not migrating it so not to break old saves
	destroys_dropped_items = true,
	default_cover_tile = "nil",
	collision_mask = {
		colliding_with_tiles_only = true,
		not_colliding_with_itself = true,
		layers = data.raw.tile["empty-space"].collision_mask.layers,
	},
})
table.insert(out_of_map_tile_type_names, "cerys-empty-space-2")

data:extend({
	cerys_empty,
	cerys_empty_2,
})
