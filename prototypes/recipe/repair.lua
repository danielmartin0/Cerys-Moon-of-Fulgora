local common = require("common")

data:extend({
	{
		type = "recipe",
		name = "ancient-structure-repair-part",
		category = "advanced-crafting",
		additional_categories = { "fulgoran-cryogenics" },
		enabled = false,
		energy_required = 3,
		ingredients = {
			{ type = "item", name = "electronic-circuit", amount = 2 },
			{ type = "item", name = "engine-unit", amount = 1 },
		},
		results = {
			{ type = "item", name = "ancient-structure-repair-part", amount = 1 },
		},
		allow_productivity = true,
		always_show_made_in = true,
	},

	{
		type = "recipe",
		name = "cerys-fulgoran-reactor-scaffold",
		energy_required = 20,
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 400 },
			{ type = "item", name = "refined-concrete", amount = 400 },
			{ type = "item", name = "processing-unit", amount = 50 },
		},
		results = { { type = "item", name = "cerys-fulgoran-reactor-scaffold", amount = 1 } },
	},

	{
		type = "recipe",
		name = "cerys-repair-cryogenic-plant",
		subgroup = "cerys-repair",
		order = "c",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png",
		icon_size = 64,
		energy_required = 1 / 3,
		enabled = false,
		hide_from_player_crafting = true,
		category = "cerys-cryogenic-plant-repair",
		ingredients = {
			{ type = "item", name = "ancient-structure-repair-part", amount = 1 },
		},
		results = {},
		allow_quality = false,
		allow_productivity = true,
		hide_from_signal_gui = true,
	},

	{
		type = "recipe",
		name = "cerys-upgrade-fulgoran-cryogenic-plant-quality",
		subgroup = "cerys-repair",
		enabled = false,
		order = "e",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cryogenic-plant.png",
		icon_size = 64,
		energy_required = 25,
		hide_from_player_crafting = true,
		category = "fulgoran-cryogenics",
		ingredients = {
			{ type = "item", name = "ancient-structure-repair-part", amount = 1 },
			{ type = "item", name = "advanced-circuit", amount = 5 },
		},
		results = {},
		allow_quality = true,
		allow_productivity = false,
		hide_from_signal_gui = true,
		allow_inserter_overload = false,
		overload_multiplier = 1, -- This is ineffective due to the default value of the utility constant 'minimum_recipe_overload_multiplier', which this vanilla-compatible mod doesn't want to change. However if another mod lowers this value, this will take effect.
	},

	{
		type = "recipe",
		name = "cerys-excavate-nuclear-reactor",
		subgroup = "cerys-repair",
		order = "f",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/fulgoran-reactor.png",
		icon_size = 64,
		energy_required = 0.9,
		enabled = false,
		hide_from_player_crafting = true,
		category = "cerys-nuclear-reactor-repair",
		ingredients = {},
		results = {
			{ type = "item", name = "concrete", amount = 100 },
		},
		allow_quality = false,
		hide_from_signal_gui = true,
		show_amount_in_title = false,
	},

	{
		type = "recipe",
		name = "cerys-repair-nuclear-reactor",
		subgroup = "cerys-repair",
		order = "g",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png",
		icon_size = 64,
		energy_required = 1 / 5,
		enabled = false,
		hide_from_player_crafting = true,
		category = "cerys-nuclear-reactor-repair",
		ingredients = {
			{ type = "item", name = "ancient-structure-repair-part", amount = 1 },
			{ type = "item", name = "processing-unit", amount = 1 },
		},
		results = {},
		allow_quality = false,
		allow_productivity = true,
		hide_from_signal_gui = true,
	},

	{
		type = "recipe",
		name = "cerys-repair-crusher",
		subgroup = "cerys-repair",
		order = "h",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png", -- Should not be distinguishable from cryogenic repair on the map view
		icon_size = 64,
		energy_required = 1 / 3,
		enabled = false,
		hide_from_player_crafting = true,
		category = "cerys-crusher-repair",
		ingredients = {
			{
				type = "item",
				name = "processing-unit",
				amount = 1,
			},
			{
				type = "item",
				name = "ancient-structure-repair-part",
				amount = 1,
			},
		},
		results = {},
		allow_quality = false,
		allow_productivity = true,
		hide_from_signal_gui = true,
	},

	{
		type = "recipe",
		name = "cerys-upgrade-fulgoran-crusher-quality",
		subgroup = "cerys-repair",
		enabled = false,
		order = "i",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/crusher.png",
		icon_size = 64,
		energy_required = 4,
		hide_from_player_crafting = true,
		category = "cerys-crusher-quality-upgrades",
		ingredients = {
			{ type = "item", name = "ancient-structure-repair-part", amount = 1 },
			{ type = "item", name = "processing-unit", amount = 5 },
		},
		results = {},
		allow_quality = true,
		allow_productivity = false,
		hide_from_signal_gui = true,
		allow_inserter_overload = false,
		overload_multiplier = 1, -- This is ineffective due to the default value of the utility constant 'minimum_recipe_overload_multiplier', which this vanilla-compatible mod doesn't want to change. However if another mod lowers this value, this will take effect.
	},
})

-- if not settings.startup["cerys-technology-compatibility-mode"].value then
data:extend({
	{
		type = "recipe",
		name = "cerys-discover-fulgoran-cryogenics",
		subgroup = "cerys-repair",
		order = "d",
		icon = "__PlanetsLib__/graphics/icons/research-progress-product.png",
		icon_size = 64,
		energy_required = 2.5,
		enabled = true,
		hide_from_player_crafting = true,
		category = "fulgoran-cryogenics",
		ingredients = common.HARD_MODE_ON and {
			{ type = "item", name = "solid-fuel", amount = 40 },
			{ type = "item", name = "cerys-nuclear-scrap", amount = 40 },
			{ type = "item", name = "advanced-circuit", amount = 30 },
			{ type = "item", name = "uranium-238", amount = 20 },
			{ type = "item", name = "copper-cable", amount = 20 },
			{ type = "item", name = "stone-brick", amount = 6 },
			{ type = "item", name = "transport-belt", amount = 3 },
			{ type = "item", name = "holmium-plate", amount = 2 },
			{ type = "item", name = "heat-pipe", amount = 1 },
			{ type = "item", name = "steam-turbine", amount = 1 },
		} or { { type = "item", name = "cerys-nuclear-scrap", amount = 20 } },
		results = {
			{ type = "research-progress", research_item = "fulgoran-cryogenics-progress", amount = 1 },
		},
		allow_quality = false,
		allow_productivity = false,
		hide_from_signal_gui = true,
	},
})
-- end
