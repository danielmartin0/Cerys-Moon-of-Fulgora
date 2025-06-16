local planet_map_gen = require("__base__/prototypes/planet/planet-map-gen")

planet_map_gen.cerys = function()
	return {
		width = 32 * 30,
		height = 32 * 30,
		cliff_settings = nil,
		autoplace_controls = {
			["cerys_nitrogen_rich_minerals"] = {},
			["cerys_methane_ice"] = {},
			["cerys_nuclear_scrap"] = {},
		},
		autoplace_settings = {
			["tile"] = {
				treat_missing_as_default = false,
				settings = {
					["cerys-empty-space-2"] = {},
					["cerys-ice-on-water"] = {},
					["cerys-water-puddles"] = {},
					["cerys-ash-cracks-frozen"] = {},
					["cerys-ash-dark-frozen"] = {},
					-- ["cerys-ash-light-frozen"] = {},
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
					["cerys-methane-iceberg-medium"] = {},
					["cerys-methane-iceberg-small"] = {},
					["cerys-methane-iceberg-tiny"] = {},
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
					["cerys-methane-iceberg-huge"] = {},
					["cerys-methane-iceberg-big"] = {},
					["cerys-fulgoran-radiative-tower"] = {}, -- null
					["cerys-fulgoran-cryogenic-plant"] = {}, -- null
					["cerys-fulgoran-crusher"] = {}, -- null
					["cerys-fulgoran-teleporter"] = {}, -- null
					["cerys-fulgoran-reactor"] = {}, -- null
					["lithium-brine"] = { -- Needed for Cerys to appear in the 'Appears on' list for lithium brine's Factoriopedia entry, but overridden below.
						frequency = "very-low",
						size = "very-low",
						richness = "very-low",
					},
				},
			},
		},
		property_expression_names = {
			["entity:lithium-brine:probability"] = "0",
		},
	}
end

data:extend({
	{
		type = "autoplace-control",
		name = "cerys_nuclear_scrap",
		localised_name = {
			"",
			"[entity=cerys-nuclear-scrap] ",
			{ "entity-name.cerys-nuclear-scrap" },
		},
		order = "r-a",
		category = "resource",
	},
	{
		type = "autoplace-control",
		name = "cerys_methane_ice",
		localised_name = {
			"",
			"[entity=methane-ice] ",
			{ "entity-name.methane-ice" },
		},
		order = "r-b",
		category = "resource",
	},
	{
		type = "autoplace-control",
		name = "cerys_nitrogen_rich_minerals",
		localised_name = {
			"",
			"[entity=cerys-nitrogen-rich-minerals] ",
			{ "entity-name.cerys-nitrogen-rich-minerals" },
		},
		order = "r-c",
		category = "resource",
	},
})

return planet_map_gen
