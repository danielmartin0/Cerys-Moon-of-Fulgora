local util = require("util")
local common = require("common")
local common_data = require("common-data-only")
local lib = require("lib")
local merge = lib.merge
local find = lib.find

if not common_data.K2_INSTALLED then
	return
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
		}),
	})
	local ammo_type = util.table.deepcopy(data.raw.ammo["kr-uranium-rifle-magazine"].ammo_type)
	ammo_type.action[1].action_delivery[1].projectile = "kr-plutonium-rifle-magazine-projectile"
	data.raw.ammo["kr-plutonium-rifle-magazine"].ammo_type = ammo_type

	data:extend({
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
	})

	data:extend({
		merge(data.raw.projectile["kr-uranium-rifle-magazine-projectile"], {
			name = "kr-plutonium-rifle-magazine-projectile",
		}),
	})
	local action = util.table.deepcopy(data.raw.projectile["kr-plutonium-rifle-magazine-projectile"].action)
	action.action_delivery.target_effects[3].damage.amount = action.action_delivery.target_effects[3].damage.amount * 2
	data.raw.projectile["kr-plutonium-rifle-magazine-projectile"].action = action

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
		}),
	})
	local ammo_type = util.table.deepcopy(data.raw.ammo["kr-plutonium-anti-materiel-rifle-magazine"].ammo_type)
	ammo_type.action[1].action_delivery[1].projectile = "kr-plutonium-anti-materiel-rifle-magazine-projectile"
	data.raw.ammo["kr-plutonium-anti-materiel-rifle-magazine"].ammo_type = ammo_type

	data:extend({
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
	})

	data:extend({
		merge(data.raw.projectile["kr-uranium-anti-materiel-rifle-magazine-projectile"], {
			name = "kr-plutonium-anti-materiel-rifle-magazine-projectile",
		}),
	})
	local action =
		util.table.deepcopy(data.raw.projectile["kr-plutonium-anti-materiel-rifle-magazine-projectile"].action)
	action.action_delivery.target_effects[2].action.action_delivery.target_effects[2].damage.amount = action.action_delivery.target_effects[2].action.action_delivery.target_effects[2].damage.amount
		* 2
	data.raw.projectile["kr-plutonium-anti-materiel-rifle-magazine-projectile"].action = action

	table.insert(data.raw.technology["cerys-applications-of-radioactivity"].effects, {
		type = "unlock-recipe",
		recipe = "kr-plutonium-anti-materiel-rifle-magazine",
	})
end

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
data.raw.recipe["cerys-nitric-acid"].localised_description = { "" }
data.raw.recipe["cerys-nitric-acid"].energy_required = 0.5
data.raw.recipe["cerys-nitric-acid"].icons = {
	{
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/nitric-acid.png",
		icon_size = 64,
		scale = 0.65,
		shift = { 2, 2 },
		draw_background = true,
	},
	{
		icon = "__space-age__/graphics/icons/fluid/ammonia.png",
		icon_size = 64,
		scale = 0.45,
		shift = { -11, -11 },
		draw_background = true,
	},
}

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

if data.raw.ammo["plutonium-rounds-magazine"] and data.raw.recipe["plutonium-rounds-magazine"] then
	data.raw.recipe["plutonium-rounds-magazine"].hidden = true
	data.raw.ammo["plutonium-rounds-magazine"].hidden = true
end
