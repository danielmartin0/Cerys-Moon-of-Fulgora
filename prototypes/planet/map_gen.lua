local planet_map_gen = require("__base__/prototypes/planet/planet-map-gen")

planet_map_gen.cerys = function()
	return {
		width = 32 * 30,
		height = 32 * 30,
		cliff_settings = nil,
		autoplace_settings = {
			["tile"] = {
				treat_missing_as_default = false,
				settings = {
					["empty-space"] = {},
					["cerys-ice-on-water"] = {},
					["cerys-water-puddles"] = {},
					["cerys-ash-cracks-frozen"] = {},
					["cerys-ash-dark-frozen"] = {},
					["cerys-ash-light-frozen"] = {},
					["cerys-pumice-stones-frozen"] = {},
				},
			},
			["decorative"] = {
				treat_missing_as_default = false,
				settings = {
					["cerys-ruin-tiny"] = {},
					["cerys-ice-decal-white"] = {},
					["cerys-crater-large"] = {},
					["cerys-crater-small"] = {},
				},
			},
			["entity"] = {
				treat_missing_as_default = false,
				settings = {
					["cerys-nuclear-scrap"] = {},
					["cerys-nitrogen-rich-minerals"] = {},
					["methane-ice"] = {},
					["cerys-ruin-colossal"] = {},
					["cerys-ruin-huge"] = {},
					["cerys-ruin-big"] = {},
					["cerys-ruin-medium"] = {},
					["cerys-ruin-small"] = {},
					["cerys-fulgoran-radiative-tower"] = {}, -- null
					["cerys-fulgoran-cryogenic-plant"] = {}, -- null
					["cerys-fulgoran-reactor"] = {}, -- null
				},
			},
		},
	}
end

return planet_map_gen
