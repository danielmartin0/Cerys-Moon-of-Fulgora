local lib = require("lib")
local find = lib.find
local common = require("common")

-- This override is because many mods add their science packs to all modded labs. If a mod wants to mark Cerys as a dependency and extend these inputs, that is fine.
data.raw.lab["cerys-lab"].inputs = {
	"automation-science-pack",
	"logistic-science-pack",
	"cerysian-science-pack",
	"utility-science-pack",
	"cryogenic-science-pack",
} -- Also set elsewhere

data.raw.lab["cerys-lab-dummy"].inputs = {
	"fulgoran-cryogenics-progress",
}
data.raw.lab["cerys-lab-dummy"].next_upgrade = nil
data.raw.lab["cerys-lab"].next_upgrade = nil
data.raw.reactor["cerys-fulgoran-reactor"].next_upgrade = nil
data.raw["assembling-machine"]["cerys-fulgoran-cryogenic-plant"].next_upgrade = nil

--== 5-dim, etc: ==--

local collision_mask_util = require("collision-mask-util")

for prototype in pairs(defines.prototypes.entity) do
	for _, entity in pairs(data.raw[prototype] or {}) do
		local next_upgrade = data.raw[prototype][entity.next_upgrade or ""]
		if next_upgrade then
			local collision_mask_1 = collision_mask_util.get_mask(entity)
			local collision_mask_2 = collision_mask_util.get_mask(next_upgrade)
			if not collision_mask_util.masks_are_same(collision_mask_1, collision_mask_2) then
				entity.next_upgrade = nil
			end

			if entity.fast_replaceable_group ~= next_upgrade.fast_replaceable_group then
				entity.next_upgrade = nil
			end
		end
		if not entity.minable then
			entity.next_upgrade = nil
		end
	end
end

--== Prevent burner inserters from being restricted on Cerys: ==--

if data.raw["inserter"]["burner-inserter"] then
	local burner_inserter = data.raw["inserter"]["burner-inserter"]
	if burner_inserter.surface_conditions then
		for i, surface_condition in pairs(burner_inserter.surface_conditions) do
			if surface_condition.property and surface_condition.property == "oxygen" then
				table.remove(burner_inserter.surface_conditions, i)
			end
		end
	end
end

--== Automated recipe bans ==--

for _, recipe in pairs(data.raw.recipe) do
	if recipe.results then
		local should_ban = false

		local produces_softbanned = false
		local requires_softbanned = false

		local produces_electric_engine_unit = false
		local produces_lubricant = false
		local produces_barrel = false
		local ends_in_recycling = recipe.name.sub(recipe.name, -10) == "-recycling"
		local starts_with_cerys = recipe.name.sub(recipe.name, 1, 6) == "cerys-"

		for _, product in pairs(recipe.results) do
			if product.name and (find(common.SOFTBANNED_RESOURCES, product.name)) then
				produces_softbanned = true
			end
			if product.name == "electric-engine-unit" then
				produces_electric_engine_unit = true
			end
			if product.name == "lubricant" then
				produces_lubricant = true
			end
			if product.name == "barrel" then
				produces_barrel = true
			end
		end
		for _, ingredient in pairs(recipe.ingredients or {}) do
			if find(common.SOFTBANNED_RESOURCES, ingredient.name) then
				requires_softbanned = true
				break
			end
		end

		local excluded = produces_barrel or ends_in_recycling or requires_softbanned or starts_with_cerys

		if not excluded then
			if produces_softbanned then
				should_ban = true
			elseif produces_lubricant then
				should_ban = true
			elseif
				produces_electric_engine_unit
				and (recipe.name ~= "electric-engine-unit" and data.raw.recipe["electric-engine-unit"])
			then
				should_ban = true
			end
		end

		if should_ban then
			log("[CERYS] Restricting temperature: " .. recipe.name)
			PlanetsLib.restrict_surface_conditions(recipe, {
				property = "temperature",
				min = 255,
			})
		end
	end
end
