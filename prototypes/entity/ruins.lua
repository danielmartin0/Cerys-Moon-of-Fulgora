local common_data = require("common-data-only")

local function ruin_minable_results(collision_area)
	-- collision_area is 2, 4, 10, 25, 36
	local fulgoran_ruin_mining_time = 0.25 * collision_area ^ 0.75
	local K2_Installed = common_data.K2_INSTALLED

	local results = {
		mining_particle = "stone-particle",
		mining_time = (2 / 3) * fulgoran_ruin_mining_time,
		results = {
			{
				type = "item",
				name = "iron-gear-wheel",
				amount_min = math.ceil(collision_area * 1.9 * (K2_Installed and 1.5 or 1)),
				amount_max = math.ceil(collision_area * 2.1 * (K2_Installed and 1.5 or 1)),
			},
			{
				type = "item",
				name = "steel-plate",
				amount_max = math.ceil(collision_area * 0.62),
				amount_min = math.ceil(collision_area * 0.53),
			},
			{
				type = "item",
				name = "concrete",
				amount_min = math.ceil(collision_area * 0.19),
				amount_max = math.ceil(collision_area * 0.21),
			},
		},
	}

	if collision_area >= 14 then
		table.insert(results.results, {
			type = "item",
			name = "solar-panel",
			amount_min = math.ceil(collision_area / 14),
			amount_max = math.ceil(collision_area / 14),
		})
	else
		table.insert(results.results, {
			type = "item",
			name = "solar-panel",
			amount = 1,
			probability = collision_area / 12,
		})
	end

	if collision_area >= 6.5 then
		table.insert(results.results, {
			type = "item",
			name = "processing-unit",
			amount = math.ceil(collision_area / 6.5),
		})
	else
		table.insert(results.results, {
			type = "item",
			name = "processing-unit",
			amount = 1,
			probability = collision_area / 6.5,
		})
	end

	if collision_area >= 21 then
		table.insert(results.results, {
			type = "item",
			name = "cerys-charging-rod",
			amount = math.floor(collision_area / 21),
		})
	else
		table.insert(results.results, {
			type = "item",
			name = "cerys-charging-rod",
			amount = 1,
			probability = collision_area / 21,
		})
	end

	if collision_area >= 10 then
		table.insert(results.results, {
			type = "item",
			name = "efficiency-module",
			amount = math.floor(collision_area / 10),
		})
	else
		table.insert(results.results, {
			type = "item",
			name = "efficiency-module",
			amount = 1,
			probability = collision_area / 10,
		})
	end

	if collision_area >= 9 then
		table.insert(results.results, {
			type = "item",
			name = "copper-cable",
			amount_min = 1,
			amount_max = math.floor(collision_area / 9),
		})
	else
		table.insert(results.results, {
			type = "item",
			name = "copper-cable",
			amount = 1,
			probability = collision_area / 9,
		})
	end

	return results
end

local sizes = { "small", "medium", "big", "huge", "colossal" }
local ruins = {}

local size_to_probability_expression = {
	small = "0.0065 * (cerys_ruin_density)",
	medium = "0.01 * (cerys_ruin_density - 0.1)",
	big = "0.0065 * (cerys_ruin_density - 0.3)",
	huge = "0.002 * (cerys_ruin_density - 0.4)", -- Looks similar to cryoplants
	colossal = "0.002 * (cerys_ruin_density - 0.5)",
}

for _, size in ipairs(sizes) do
	local base_entity = util.table.deepcopy(data.raw["simple-entity"]["fulgoran-ruin-" .. size])

	base_entity.name = "cerys-ruin-" .. size
	base_entity.order = "b[decorative]-l[rock]-j[ruin]-b[cerys]-e[" .. size .. "]"
	base_entity.icon = "__Cerys-Moon-of-Fulgora__/graphics/icons/cerys-ruin-" .. size .. ".png"
	base_entity.icon_size = 64
	base_entity.dying_trigger_effect = nil
	base_entity.remains_when_mined = nil -- fix for things like fulgora extended; it shouldn't leave anything behind

	local collision_area = (base_entity.collision_box[2][1] - base_entity.collision_box[1][1])
		* (base_entity.collision_box[2][2] - base_entity.collision_box[1][2])
	base_entity.minable = ruin_minable_results(collision_area)

	local filtered_pictures = {}
	for i, picture in pairs(base_entity.pictures) do
		local include = true
		if picture.filename:match("%-tall%.png$") and not (size == "small" or size == "medium") then
			include = false
		end
		if size == "big" and i == 7 then
			include = false
		end

		if include then
			picture.filename = "__Cerys-Moon-of-Fulgora__/graphics/entity/cerys-ruin/cerys-ruin"
				.. picture.filename:sub(62, -1)
			table.insert(filtered_pictures, picture)
		end
	end
	base_entity.pictures = filtered_pictures

	base_entity.autoplace.probability_expression = size_to_probability_expression[size]

	table.insert(ruins, base_entity)
end

data:extend(ruins)
