data.raw.technology["flare-stack-item-venting-electric-tech"].enabled = false
data.raw.technology["flare-stack-item-venting-tech"].enabled = false
data.raw.technology["flare-stack-fluid-venting-tech"].prerequisites = { "cerys-science-pack" }
data.raw.technology["flare-stack-fluid-venting-tech"].unit = {
	count = 50,
	ingredients = {
		{ "cerys-science-pack", 1 },
	},
	time = 60,
}

data.raw.furnace["electric-incinerator"].hidden = true
data.raw.furnace["incinerator"].hidden = true
data.raw.item["electric-incinerator"].hidden = true
data.raw.item["incinerator"].hidden = true
data.raw.recipe["electric-incinerator"].hidden = true
data.raw.recipe["incinerator"].hidden = true
