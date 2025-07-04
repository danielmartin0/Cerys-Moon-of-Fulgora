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
				main_product = "kr-plutonium-rifle-magazine",
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
				main_product = "kr-plutonium-anti-materiel-rifle-magazine",
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
