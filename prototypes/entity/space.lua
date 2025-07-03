local merge = require("lib").merge
local common = require("common")

local ASTEROIDS_TO_CLONE = {
	"small-metallic-asteroid",
	"small-carbonic-asteroid",
	"small-oxide-asteroid",
	"medium-metallic-asteroid",
	"medium-carbonic-asteroid",
	"medium-oxide-asteroid",
}

if mods["cupric-asteroids"] then
	table.insert(ASTEROIDS_TO_CLONE, "small-cupric-asteroid")
	table.insert(ASTEROIDS_TO_CLONE, "medium-cupric-asteroid")
end

local ASTEROID_HEALTH_MULTIPLIER = common.HARD_MODE_ON and 8 or 2.5
local ASTEROID_PHYSICAL_RESISTANCE_INCREASE = 10

local function create_asteroid(asteroid_name, shadow_shift_factor, name_suffix)
	local original = data.raw.asteroid[asteroid_name]

	local e = merge(original, {
		name = asteroid_name .. name_suffix,
		localised_name = { "entity-name.planetary-asteroid", { "entity-name." .. asteroid_name } },
		order = "z[planetary]-" .. original.order,
		subgroup = "planetary-environment",
		max_health = original.max_health * ASTEROID_HEALTH_MULTIPLIER,
	})

	if
		string.find(asteroid_name, "metallic")
		or string.find(asteroid_name, "oxide")
		or string.find(asteroid_name, "carbonic")
	then
		-- TODO: Add 'p' symbol for cupric etc asteroids
		e.icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/planetary-" .. asteroid_name .. ".png"
		e.icon_size = 64
	end

	local existing_physical_res = nil
	for _, resistance in pairs(e.resistances) do
		if resistance.type == "laser" then
			resistance.percent = 100
		end

		if resistance.type == "physical" then
			existing_physical_res = resistance
		end
	end

	if existing_physical_res then
		existing_physical_res.decrease = existing_physical_res.decrease + ASTEROID_PHYSICAL_RESISTANCE_INCREASE
	end

	for _, variation in pairs(e.graphics_set.variations) do
		if variation.shadow_shift then
			variation.shadow_shift[1] = variation.shadow_shift[1] * shadow_shift_factor
			variation.shadow_shift[2] = 0
		end
	end

	if e.dying_trigger_effect then
		for _, effect in pairs(e.dying_trigger_effect) do
			if effect.type == "create-entity" then
				effect.entity_name = effect.entity_name .. name_suffix
			end
		end
	end

	data:extend({ e })
end

for _, asteroid_name in pairs(ASTEROIDS_TO_CLONE) do
	if data.raw.asteroid[asteroid_name] then
		create_asteroid(asteroid_name, 7, "-planetary")
	end
end

local solar_wind_particle = {
	type = "simple-entity",
	subgroup = "planetary-environment",
	flags = { "placeable-off-grid" },
	name = "cerys-solar-wind-particle",
	order = "a",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/entity/solar-wind-particle.png",
	icon_size = 32,
	map_color = { 1, 0, 1 },
	render_layer = "arrow",
	-- subgroup = "space",
	collision_mask = { layers = {} },
	collision_box = { { -0.35, -0.35 }, { 0.35, 0.35 } },
	selection_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
	pictures = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/solar-wind-particle.png",
				tint = { r = 1, g = 1, b = 1, a = 0.8 },
				apply_runtime_tint = true,
				size = 32,
				scale = 0.5,
				draw_as_glow = true,
				blend_mode = "additive",
			},
		},
	},
}

local neutron_dummy = merge(solar_wind_particle, {
	map_color = { 0.8, 0.8, 0.8 },
	name = "cerys-neutron-dummy", -- For Factoriopedia
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/neutron.png",
	icon_size = 48,
	order = "b",
	pictures = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/neutron.png",
				size = 32,
				scale = 0.45,
				draw_as_glow = true,
			},
		},
	},
})

local gamma_radiation = merge(solar_wind_particle, {
	map_color = { 0, 1, 0 },
	name = "cerys-gamma-radiation",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/gamma-radiation.png",
	icon_size = 64,
	order = "c",
	pictures = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/gamma-radiation.png",
				size = 32,
				scale = 0.45,
				draw_as_glow = true,
			},
		},
	},
})

data:extend({ solar_wind_particle, gamma_radiation, neutron_dummy })
