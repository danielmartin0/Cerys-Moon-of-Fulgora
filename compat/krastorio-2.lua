local common = require("common")
local common_data = require("common-data-only")
local lib = require("lib")
local merge = lib.merge
local find = lib.find

if common_data.K2_INSTALLED then
	data:extend({
		merge(data.raw.recipe["utility-science-pack"], {
			name = "cerys-utility-science-pack",
			ingredients = {
				{ type = "item", name = "low-density-structure", amount = 5 },
				{ type = "item", name = "processing-unit", amount = 5 },
				{ type = "item", name = "electric-engine-unit", amount = 5 },
				{ type = "item", name = "kr-blank-tech-card", amount = 10 },
			},
			results = { { type = "item", name = "utility-science-pack", amount = 5 } },
			category = "fulgoran-cryogenics",
			subgroup = "cerys-processes",
			order = "k",
		}),
	})

	PlanetsLib.restrict_surface_conditions(data.raw.recipe["utility-science-pack"], common.AMBIENT_RADIATION_MAX)

	table.insert(data.raw.technology["cerys-fulgoran-cryogenics"].effects, {
		type = "unlock-recipe",
		recipe = "cerys-utility-science-pack",
	})

	data.raw.recipe["cerys-charging-rod"].ingredients = {
		{ type = "item", name = "superconductor", amount = 8 },
		{ type = "item", name = "kr-steel-beam", amount = 8 },
		{ type = "item", name = "holmium-plate", amount = 16 }, -- For holmium plate qualitycycling
	}

	data.raw.recipe["cerys-fulgoran-reactor-scaffold"].ingredients = {
		{ type = "item", name = "kr-steel-beam", amount = 400 },
		{ type = "item", name = "refined-concrete", amount = 400 },
		{ type = "item", name = "processing-unit", amount = 50 },
	}

	data.raw.recipe["cerys-nitric-acid"].ingredients = {
		{ type = "fluid", name = "ammonia", amount = 50 },
		{ type = "fluid", name = "kr-oxygen", amount = 50 },
	}
	data.raw.recipe["cerys-nitric-acid"].results = {
		{ type = "fluid", name = "kr-nitric-acid", amount = 50 },
		{ type = "fluid", name = "kr-nitrogen", amount = 50 },
	}
	data.raw.recipe["cerys-nitric-acid"].category = "fulgoran-cryogenics"
	data.raw.recipe["cerys-nitric-acid"].localised_name = { "cerys.nitric-acid-by-ammonia-oxidation" }
	data.raw.recipe["cerys-nitric-acid"].energy_required = 0.5

	if
		not find(data.raw.recipe["cerys-hydrogen-bomb"].ingredients, function(ingredient)
			return ingredient.type == "fluid" and ingredient.name == "kr-hydrogen"
		end)
	then
		table.insert(
			data.raw.recipe["cerys-hydrogen-bomb"].ingredients,
			{ type = "fluid", name = "kr-hydrogen", amount = 25 }
		)
		data.raw.recipe["cerys-hydrogen-bomb"].category = "chemistry"
	end

	-- Copied from K2SO files:
	local rifle_range = 30
	local sniper_range = 70
	local k_target_type = "direction" -- "entity", "position" or "direction"
	local k_d_radius = 0.5
	if settings.startup["kr-realistic-weapons-auto-aim"].value then
		rifle_range = 25
		sniper_range = 50
		k_target_type = "entity" -- "entity", "position" or "direction"
		k_d_radius = 0.25
	end

	if data.raw.ammo["plutonium-rounds-magazine"] and data.raw.recipe["plutonium-rounds-magazine"] then
		data.raw.recipe["plutonium-rounds-magazine"].hidden = true
		data.raw.ammo["plutonium-rounds-magazine"].hidden = true
	end

	if
		data.raw.ammo["kr-uranium-rifle-magazine"]
		and data.raw.recipe["kr-uranium-rifle-magazine"]
		and data.raw.projectile["kr-uranium-rifle-magazine-projectile"]
	then
		data:extend({
			merge(data.raw.ammo["kr-uranium-rifle-magazine"], {
				name = "kr-plutonium-rifle-magazine",
				order = data.raw.ammo["kr-uranium-rifle-magazine"].order .. "-b[plutonium-rifle-magazine]",
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/kr-plutonium-rifle-magazine.png",
				icon_size = 64,
				pictures = {
					{
						filename = "__Cerys-Moon-of-Fulgora__/graphics/icons/kr-plutonium-rifle-magazine.png",
						size = 64,
						scale = 0.5,
					},
				},
				ammo_type = {
					target_type = k_target_type,
					action = {
						{
							type = "direct",
							action_delivery = {
								{
									type = "projectile",
									projectile = "kr-uranium-rifle-magazine-projectile",
									starting_speed = 1.75,
									direction_deviation = 0.15,
									range_deviation = 0.15,
									max_range = rifle_range,
									source_effects = {
										{
											type = "create-explosion",
											entity_name = "explosion-gunshot",
										},
									},
								},
							},
						},
					},
				},
			}),
			merge(data.raw.recipe["kr-uranium-rifle-magazine"], {
				name = "kr-plutonium-rifle-magazine",
				ingredients = {
					{ type = "item", name = "kr-uranium-rifle-magazine", amount = 10 },
					{ type = "item", name = "plutonium-238", amount = 1 },
				},
				results = { { type = "item", name = "kr-plutonium-rifle-magazine", amount = 10 } },
				energy_required = data.raw.recipe["kr-uranium-rifle-magazine"].energy_required * 10,
			}),
			merge(data.raw.projectile["kr-uranium-rifle-magazine-projectile"], {
				name = "kr-plutonium-rifle-magazine-projectile",
				action = {
					type = "direct",
					action_delivery = {
						type = "instant",
						target_effects = {
							{
								type = "create-entity",
								entity_name = "kr-explosion-hit-u",
							},
							{
								type = "damage",
								damage = { amount = 14, type = "physical" },
							},
							{
								type = "damage",
								damage = { amount = 12, type = "kr-radioactive" },
							},
						},
					},
				},
			}),
		})

		table.insert(data.raw.technology["cerys-applications-of-radioactivity"].effects, {
			type = "unlock-recipe",
			recipe = "kr-plutonium-rifle-magazine",
		})
	end

	if
		data.raw.ammo["kr-uranium-anti-materiel-rifle-magazine"]
		and data.raw.recipe["kr-uranium-anti-materiel-rifle-magazine"]
		and data.raw.projectile["kr-uranium-anti-materiel-rifle-magazine-projectile"]
	then
		data:extend({
			merge(data.raw.ammo["kr-uranium-anti-materiel-rifle-magazine"], {
				name = "kr-plutonium-anti-materiel-rifle-magazine",
				order = data.raw.ammo["kr-uranium-anti-materiel-rifle-magazine"].order
					.. "-b[plutonium-anti-materiel-rifle-magazine]",
				icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/kr-plutonium-anti-materiel-rifle-magazine.png",
				icon_size = 64,
				pictures = {
					{
						filename = "__Cerys-Moon-of-Fulgora__/graphics/icons/kr-plutonium-anti-materiel-rifle-magazine.png",
						size = 64,
						scale = 0.5,
					},
				},
				ammo_type = {
					target_type = k_target_type,
					action = {
						{
							type = "direct",
							action_delivery = {
								{
									type = "projectile",
									projectile = "kr-uranium-anti-materiel-rifle-magazine-projectile",
									starting_speed = 3,
									direction_deviation = 0.02,
									range_deviation = 0.02,
									max_range = sniper_range,
									source_effects = {
										{
											type = "create-explosion",
											entity_name = "explosion-gunshot",
										},
									},
								},
							},
							force = "not-same",
						},
					},
				},
			}),
			merge(data.raw.recipe["kr-uranium-anti-materiel-rifle-magazine"], {
				name = "kr-plutonium-anti-materiel-rifle-magazine",
				ingredients = {
					{ type = "item", name = "kr-uranium-anti-materiel-rifle-magazine", amount = 10 },
					{ type = "item", name = "plutonium-238", amount = 1 },
				},
				results = { { type = "item", name = "kr-plutonium-anti-materiel-rifle-magazine", amount = 10 } },
				energy_required = data.raw.recipe["kr-uranium-anti-materiel-rifle-magazine"].energy_required * 10,
			}),
			merge(data.raw.projectile["kr-uranium-anti-materiel-rifle-magazine-projectile"], {
				name = "kr-plutonium-anti-materiel-rifle-magazine-projectile",
				action = {
					type = "direct",
					action_delivery = {
						type = "instant",
						target_effects = {
							{
								type = "create-entity",
								entity_name = "kr-explosion-hit-u",
							},
							{
								type = "nested-result",
								action = {
									type = "area",
									radius = k_d_radius + 0.25,
									action_delivery = {
										type = "instant",
										target_effects = {
											{
												type = "damage",
												damage = { amount = 125, type = "physical" },
											},
											{
												type = "damage",
												damage = { amount = 150, type = "kr-radioactive" },
											},
										},
									},
									force = "not-same",
								},
							},
						},
					},
				},
			}),
		})

		table.insert(data.raw.technology["cerys-applications-of-radioactivity"].effects, {
			type = "unlock-recipe",
			recipe = "kr-plutonium-anti-materiel-rifle-magazine",
		})
	end
end
