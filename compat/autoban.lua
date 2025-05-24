local lib = require("lib")
local find = lib.find
local common = require("common")

--== Automated recipe bans ==--

for _, recipe in pairs(data.raw.recipe) do
	if recipe.results then
		local should_ban = false

		local produces_softbanned = false
		local requires_softbanned = false

		local produces_electric_engine_unit = false
		local produces_lubricant = false
		local produces_barrel = false
		local produces_science_pack = false

		local ends_in_recycling = recipe.name.sub(recipe.name, -10) == "-recycling"
		local is_cerys_recipe = recipe.name.sub(recipe.name, 1, 6) == "cerys-"
			or recipe.name == "mixed-oxide-waste-centrifuging"

		for _, product in pairs(recipe.results) do
			if product.name then
				if find(common.SOFTBANNED_RESOURCES, product.name) then
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
				if data.raw.tool[product.name] then
					produces_science_pack = true
				end
			end
		end

		for _, ingredient in pairs(recipe.ingredients or {}) do
			if find(common.SOFTBANNED_RESOURCES, ingredient.name) then
				requires_softbanned = true
				break
			end
		end

		local excluded = produces_barrel
			or ends_in_recycling
			or requires_softbanned
			or is_cerys_recipe
			or produces_science_pack

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
			log("[CERYS] Restricting " .. recipe.name)
			PlanetsLib.restrict_surface_conditions(recipe, common.AMBIENT_RADIATION_MAX)
		end
	end
end
