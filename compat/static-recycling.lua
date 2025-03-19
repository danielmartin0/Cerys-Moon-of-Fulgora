if settings.startup["cerys-enforce-vanilla-recycling-recipes"].value then
	data.raw["recipe"]["pipe-recycling"]["ingredients"] = { { type = "item", name = "pipe", amount = 1 } }
	data.raw["recipe"]["pipe-recycling"]["results"] = {
		{ type = "item", name = "iron-plate", amount = 0, extra_count_fraction = 0.25 },
	}

	data.raw["recipe"]["heat-pipe-recycling"]["ingredients"] = { { type = "item", name = "heat-pipe", amount = 1 } }
	data.raw["recipe"]["heat-pipe-recycling"]["results"] = {
		{ type = "item", name = "steel-plate", amount = 2, extra_count_fraction = 0.5 },
		{ type = "item", name = "copper-plate", amount = 5 },
	}

	data.raw["recipe"]["beacon-recycling"]["ingredients"] = { { type = "item", name = "beacon", amount = 1 } }
	data.raw["recipe"]["beacon-recycling"]["results"] = {
		{ type = "item", name = "electronic-circuit", amount = 5 },
		{ type = "item", name = "advanced-circuit", amount = 5 },
		{ type = "item", name = "steel-plate", amount = 2, extra_count_fraction = 0.5 },
		{ type = "item", name = "copper-cable", amount = 2, extra_count_fraction = 0.5 },
	}

	data.raw["recipe"]["steam-turbine-recycling"]["ingredients"] =
		{ { type = "item", name = "steam-turbine", amount = 1 } }
	data.raw["recipe"]["steam-turbine-recycling"]["results"] = {
		{ type = "item", name = "iron-gear-wheel", amount = 12, extra_count_fraction = 0.5 },
		{ type = "item", name = "copper-plate", amount = 12, extra_count_fraction = 0.5 },
		{ type = "item", name = "pipe", amount = 5 },
	}

	data.raw["recipe"]["centrifuge-recycling"]["ingredients"] = { { type = "item", name = "centrifuge", amount = 1 } }
	data.raw["recipe"]["centrifuge-recycling"]["results"] = {
		{ type = "item", name = "concrete", amount = 25 },
		{ type = "item", name = "steel-plate", amount = 12, extra_count_fraction = 0.5 },
		{ type = "item", name = "advanced-circuit", amount = 25 },
		{ type = "item", name = "iron-gear-wheel", amount = 25 },
	}

	data.raw["recipe"]["iron-gear-wheel-recycling"]["ingredients"] =
		{ { type = "item", name = "iron-gear-wheel", amount = 1 } }
	data.raw["recipe"]["iron-gear-wheel-recycling"]["results"] = {
		{ type = "item", name = "iron-plate", amount = 0, extra_count_fraction = 0.5 },
	}

	data.raw["recipe"]["copper-cable-recycling"]["ingredients"] =
		{ { type = "item", name = "copper-cable", amount = 1 } }
	data.raw["recipe"]["copper-cable-recycling"]["results"] = {
		{ type = "item", name = "copper-plate", amount = 0, extra_count_fraction = 0.125 },
	}

	data.raw["recipe"]["electronic-circuit-recycling"]["ingredients"] =
		{ { type = "item", name = "electronic-circuit", amount = 1 } }
	data.raw["recipe"]["electronic-circuit-recycling"]["results"] = {
		{ type = "item", name = "iron-plate", amount = 0, extra_count_fraction = 0.25 },
		{ type = "item", name = "copper-cable", amount = 0, extra_count_fraction = 0.75 },
	}

	local RECYCLE_TO_ITSELF = {
		"solid-fuel",
		"steel-plate",
		"copper-plate",
		"iron-plate",
		"stone-brick",
		"plastic-bar",
		"holmium-plate",
	}

	for i = 1, #RECYCLE_TO_ITSELF do
		data.raw["recipe"][RECYCLE_TO_ITSELF[i] .. "-recycling"]["ingredients"] =
			{ { type = "item", name = RECYCLE_TO_ITSELF[i], amount = 1 } }
		data.raw["recipe"][RECYCLE_TO_ITSELF[i] .. "-recycling"]["results"] = {
			{ type = "item", name = RECYCLE_TO_ITSELF[i], amount = 0, extra_count_fraction = 0.25 },
		}
	end
end
