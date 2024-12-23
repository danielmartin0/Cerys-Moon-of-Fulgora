local procession_graphic_catalogue = require("__base__/prototypes/planet/procession-graphic-catalogue-types")

return {
	-- Hatches
	{
		index = procession_graphic_catalogue.hatch_emission_bay,
		sprite = util.sprite_load("__space-age__/graphics/entity/cargo-hubs/hatches/shared-cargo-bay-pod-emission", {
			priority = "medium",
			draw_as_glow = true,
			blend_mode = "additive",
			scale = 0.5,
			shift = util.by_pixel(10.24, 48), --32 x ({-0.32, -1.5})
		}),
	},
	{
		index = procession_graphic_catalogue.hatch_emission_out_1,
		sprite = util.sprite_load(
			"__space-age__/graphics/entity/cargo-hubs/hatches/platform-lower-hatch-pod-emission-A",
			{
				priority = "medium",
				draw_as_glow = true,
				blend_mode = "additive",
				scale = 0.5,
				shift = util.by_pixel(56, -16), --32 x ({-1.75, 0} + {0, 0.5})
			}
		),
	},
	{
		index = procession_graphic_catalogue.hatch_emission_out_2,
		sprite = util.sprite_load(
			"__space-age__/graphics/entity/cargo-hubs/hatches/platform-lower-hatch-pod-emission-B",
			{
				priority = "medium",
				draw_as_glow = true,
				blend_mode = "additive",
				scale = 0.5,
				shift = util.by_pixel(16, -32), --32 x ({-0.5, 0.5} + {0, 0.5})
			}
		),
	},
	{
		index = procession_graphic_catalogue.hatch_emission_out_3,
		sprite = util.sprite_load(
			"__space-age__/graphics/entity/cargo-hubs/hatches/platform-lower-hatch-pod-emission-C",
			{
				priority = "medium",
				draw_as_glow = true,
				blend_mode = "additive",
				scale = 0.5,
				shift = util.by_pixel(64, -48), --32 x ({-2, 1} + {0, 0.5})
			}
		),
	},
	{
		index = procession_graphic_catalogue.hatch_emission_in_1,
		sprite = util.sprite_load(
			"__space-age__/graphics/entity/cargo-hubs/hatches/platform-upper-hatch-pod-emission-A",
			{
				priority = "medium",
				draw_as_glow = true,
				blend_mode = "additive",
				scale = 0.5,
				shift = util.by_pixel(-16, 96), --32 x ({0.5, -3.5} + {0, 0.5})
			}
		),
	},
	{
		index = procession_graphic_catalogue.hatch_emission_in_2,
		sprite = util.sprite_load(
			"__space-age__/graphics/entity/cargo-hubs/hatches/platform-upper-hatch-pod-emission-B",
			{
				priority = "medium",
				draw_as_glow = true,
				blend_mode = "additive",
				scale = 0.5,
				shift = util.by_pixel(-64, 96), --32 x ({2, -3.5} + {0, 0.5})
			}
		),
	},
	{
		index = procession_graphic_catalogue.hatch_emission_in_3,
		sprite = util.sprite_load(
			"__space-age__/graphics/entity/cargo-hubs/hatches/platform-upper-hatch-pod-emission-C",
			{
				priority = "medium",
				draw_as_glow = true,
				blend_mode = "additive",
				scale = 0.5,
				shift = util.by_pixel(-40, 64), --32 x ({1.25, -2.5} + {0, 0.5})
			}
		),
	},
	{
		index = procession_graphic_catalogue.planet_hatch_emission_in_1,
		sprite = util.sprite_load("__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-A", {
			priority = "medium",
			draw_as_glow = true,
			blend_mode = "additive",
			scale = 0.5,
			shift = util.by_pixel(-16, 96), --32 x ({0.5, -3.5} + {0, 0.5})
		}),
	},
	{
		index = procession_graphic_catalogue.planet_hatch_emission_in_2,
		sprite = util.sprite_load("__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-B", {
			priority = "medium",
			draw_as_glow = true,
			blend_mode = "additive",
			scale = 0.5,
			shift = util.by_pixel(-64, 96), --32 x ({2, -3.5} + {0, 0.5})
		}),
	},
	{
		index = procession_graphic_catalogue.planet_hatch_emission_in_3,
		sprite = util.sprite_load("__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-C", {
			priority = "medium",
			draw_as_glow = true,
			blend_mode = "additive",
			scale = 0.5,
			shift = util.by_pixel(-40, 64), --32 x ({1.25, -2.5} + {0, 0.5})
		}),
	},
}
