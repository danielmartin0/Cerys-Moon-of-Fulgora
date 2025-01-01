local merge = require("lib").merge

local ASTEROIDS_TO_CLONE = {
	"small-metallic-asteroid",
	"small-carbonic-asteroid",
	"small-oxide-asteroid",
	"medium-metallic-asteroid",
	"medium-carbonic-asteroid",
	"medium-oxide-asteroid",
}

local ASTEROID_HEALTH_MULTIPLIER = 2.5
local ASTEROID_PHYSICAL_RESISTANCE_INCREASE = 10
local function create_asteroid(asteroid_name, shadow_shift_factor, name_suffix)
	local original = data.raw.asteroid[asteroid_name]

	local e = merge(original, {
		name = asteroid_name .. name_suffix,
		order = "z[planetary]-" .. original.order,
		subgroup = "planetary-environment",
		max_health = original.max_health * ASTEROID_HEALTH_MULTIPLIER,
	})

	local existing_physical_res = nil
	for _, resistance in pairs(e.resistances) do
		if resistance.type == "laser" then
			resistance.percent = 100
		end

		if resistance.type == "physical" then
			existing_physical_res = resistance
			break
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
				apply_runtime_tint = true,
				size = 32,
				scale = 0.6,
				draw_as_glow = true,
				blend_mode = "additive",
			},
		},
	},
}
local radiation_particle = merge(solar_wind_particle, {
	map_color = { 0, 1, 0 },
	name = "cerys-gamma-radiation",
	icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/radiation-particle.png",
	icon_size = 64,
	order = "b",
	pictures = {
		layers = {
			{
				filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/radiation-particle.png",
				size = 32,
				scale = 0.3,
				draw_as_glow = true,
				blend_mode = "additive",
			},
		},
	},
})

data:extend({ solar_wind_particle, radiation_particle })
