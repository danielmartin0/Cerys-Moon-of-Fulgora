-- TODO: Prepend with "cerys-"

data:extend({
	{
		type = "fuel-category",
		name = "chemical-or-radiative",
	},
	{
		type = "fuel-category",
		name = "nuclear-mixed-oxide",
	},
	{
		type = "recipe-category",
		name = "cryogenic-plant-repair",
	},
	{
		type = "recipe-category",
		name = "nuclear-reactor-repair",
	},
	{
		type = "recipe-category",
		name = "crusher-repair",
	},
	{
		type = "recipe-category",
		name = "crusher-quality-upgrades",
	},
	{
		type = "recipe-category",
		name = "fulgoran-cryogenics",
	},
	{
		type = "recipe-category",
		name = "no-machine",
	},
	{
		type = "item-subgroup",
		name = "plutonium-processing",
		group = "intermediate-products",
		order = "i-b[cerys]-a",
	},
	{
		type = "item-subgroup",
		name = "cerys-processes",
		group = "intermediate-products",
		order = "i-b[cerys]-b",
	},
	{
		type = "item-subgroup",
		name = "cerys-repair",
		group = "intermediate-products",
		order = "i-b[cerys]-c",
	},
	{
		type = "item-subgroup",
		name = "planetary-environment",
		group = "space",
		order = "i-c[cerys]",
	},
	{
		type = "item-subgroup",
		name = "cerys-entities",
		group = "production",
		order = "t[cerys]-a",
	},
	{
		type = "item-subgroup",
		name = "research-recipes",
		group = "intermediate-products",
		order = "y-b",
	},
	{
		type = "item-subgroup",
		name = "cerys-tiles",
		group = "tiles",
		order = "k-[cerys]",
	},
})
