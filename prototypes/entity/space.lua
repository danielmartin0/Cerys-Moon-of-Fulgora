local merge = require("lib").merge
local common = require("common")
local common_data = require("common-data-only")

local ASTEROIDS_TO_CLONE = {
	["small-metallic-asteroid"] = 8,
	["small-carbonic-asteroid"] = 7,
	["small-oxide-asteroid"] = 6,
	["medium-metallic-asteroid"] = 7,
	["medium-carbonic-asteroid"] = 8,
	["medium-oxide-asteroid"] = 9,
}

if mods["cupric-asteroids"] then
	ASTEROIDS_TO_CLONE["small-cupric-asteroid"] = 7
	ASTEROIDS_TO_CLONE["medium-cupric-asteroid"] = 7
end

local ASTEROID_HEALTH_MULTIPLIER = common.HARD_MODE_ON and 8 or 2.5

local function create_asteroid(asteroid_name, shadow_shift_factor, name_suffix)
	local original = data.raw.asteroid[asteroid_name]

	local e = merge(original, {
		name = asteroid_name .. name_suffix,
		localised_name = { "entity-name.planetary-asteroid", { "entity-name." .. asteroid_name } },
		localised_description = { "cerys.planetary-asteroid-description" },
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
		existing_physical_res.decrease = existing_physical_res.decrease + 10
	end

	for _, variation in pairs(e.graphics_set.variations) do
		if variation.shadow_shift then
			variation.shadow_shift[1] = variation.shadow_shift[1] * shadow_shift_factor
			variation.shadow_shift[2] = variation.shadow_shift[2] * shadow_shift_factor
		end
	end

	if e.dying_trigger_effect then
		for _, effect in pairs(e.dying_trigger_effect) do
			if effect.type == "create-entity" then
				effect.entity_name = effect.entity_name .. name_suffix
			elseif effect.type == "create-asteroid-chunk" then
				effect.offsets = { { 0, 0 } } -- sets the number of created chunks to 1 for Factoriopedia purposes
			end
		end
	end

	data:extend({ e })
end

for asteroid_name, shadow_shift_value in pairs(ASTEROIDS_TO_CLONE) do
	if data.raw.asteroid[asteroid_name] then
		create_asteroid(asteroid_name, shadow_shift_value, "-planetary")
	end
end

local solar_wind_particle = {
	type = "simple-entity",
	subgroup = "planetary-environment",
	flags = { "placeable-off-grid" },
	name = "cerys-solar-wind-particle",
	order = "b",
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
				-- tint = data.raw["utility-constants"]["default"].ghost_shader_tint.ghost_tint,
				tint = { r = 1, g = 1, b = 1, a = 1 },
				size = 32,
				scale = 0.5,
				draw_as_glow = true,
				blend_mode = "additive",
			},
		},
	},
}

data:extend({
	solar_wind_particle,

	merge(solar_wind_particle, {
		map_color = { 0, 1, 0 },
		name = "cerys-solar-wind-particle-ghost",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/entity/solar-wind-particle-ghost.png",
		order = "e",
		pictures = {
			layers = {
				{
					filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/solar-wind-particle-ghost.png",
					-- tint = data.raw["utility-constants"]["default"].ghost_shader_tint.ghost_tint,
					tint = { r = 1, g = 1, b = 1, a = 1 },
					size = 32,
					scale = 0.5,
					draw_as_glow = true,
					blend_mode = "additive",
				},
			},
		},
	}),

	merge(solar_wind_particle, {
		map_color = { 0, 1, 0 },
		name = "cerys-gamma-radiation",
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/gamma-radiation.png",
		icon_size = 64,
		order = "d",
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
	}),

	merge(solar_wind_particle, {
		map_color = { 0.8, 0.8, 0.8 },
		name = "cerys-neutron-dummy", -- For Factoriopedia
		icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/neutron.png",
		icon_size = 48,
		order = "c",
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
	}),
})
