data:extend({
	{
		type = "recipe",
		name = "ancient-structure-repair-part",
		category = "advanced-crafting-or-fulgoran-cryogenics",
		enabled = false,
		energy_required = 0.7,
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
			{ type = "item", name = "steel-plate", amount = 500 },
			{ type = "item", name = "refined-concrete", amount = 500 },
			{ type = "item", name = "processing-unit", amount = 50 },
		},
		results = { { type = "item", name = "cerys-fulgoran-reactor-scaffold", amount = 1 } },
	},

	{
		type = "recipe",
		name = "cerys-excavate-nuclear-reactor",
		subgroup = "cerys-repair",
		order = "c",
		icon = "__base__/graphics/icons/concrete.png",
		energy_required = 1.1,
		enabled = false,
		hide_from_player_crafting = true,
		category = "nuclear-reactor-repair",
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
		order = "d",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png",
		icon_size = 64,
		energy_required = 1 / 5,
		enabled = false,
		hide_from_player_crafting = true,
		category = "nuclear-reactor-repair",
		ingredients = {
			-- The script need to be updated if these change:
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
		name = "cerys-repair-cryogenic-plant",
		subgroup = "cerys-repair",
		order = "b",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png",
		icon_size = 64,
		energy_required = 1 / 4,
		enabled = false,
		hide_from_player_crafting = true,
		category = "cryogenic-plant-repair",
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
		order = "f",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/technology/cryogenic-plant.png",
		icon_size = 256,
		energy_required = 30,
		hide_from_player_crafting = true,
		category = "fulgoran-cryogenics",
		ingredients = {
			{ type = "item", name = "ancient-structure-repair-part", amount = 20 },
			{ type = "item", name = "advanced-circuit", amount = 20 },
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
		name = "cerys-repair-crusher",
		subgroup = "cerys-repair",
		order = "c",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/ancient-repair-part.png",
		icon_size = 64,
		energy_required = 1 / 4,
		enabled = false,
		hide_from_player_crafting = true,
		category = "crusher-repair",
		ingredients = {
			{
				type = "item",
				name = settings.startup["cerys-disable-quality-mechanics"].value and "processing-unit"
					or "advanced-circuit",
				amount = 1,
			},
			{
				type = "item",
				name = "ancient-structure-repair-part",
				amount = settings.startup["cerys-disable-quality-mechanics"].value and 5 or 1,
			},
		},
		results = {},
		allow_quality = false,
		allow_productivity = true,
		hide_from_signal_gui = true,
	},
})

if not settings.startup["cerys-technology-compatibility-mode"].value then
	data:extend({
		{
			type = "recipe",
			name = "cerys-discover-fulgoran-cryogenics",
			subgroup = "cerys-repair",
			order = "e",
			icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/empty-science-pack.png",
			icon_size = 64,
			energy_required = 3,
			enabled = true,
			hide_from_player_crafting = true,
			category = "fulgoran-cryogenics",
			ingredients = {
				{ type = "item", name = "cerys-nuclear-scrap", amount = 20 },
			},
			results = {
				{ type = "research-progress", research_item = "fulgoran-cryogenics-progress", amount = 1 },
			},
			allow_quality = false,
			allow_productivity = false,
			hide_from_signal_gui = true,
		},
	})
end
