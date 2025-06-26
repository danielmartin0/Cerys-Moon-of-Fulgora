local Public = {}

--== Prevent burner inserters from being restricted on Cerys: ==--

if data.raw["inserter"]["burner-inserter"] then
	local burner_inserter = data.raw["inserter"]["burner-inserter"]
	PlanetsLib.relax_surface_conditions(burner_inserter, {
		property = "temperature",
		min = 255,
	})
	PlanetsLib.relax_surface_conditions(burner_inserter, {
		property = "oxygen",
		min = 0,
	})
end

-- This override is because many mods add their science packs to all modded labs. If a mod wants to mark Cerys as a dependency and extend these inputs intentionally, that is fine.
data.raw.lab["cerys-lab"].inputs = {
	"automation-science-pack",
	"logistic-science-pack",
	"cerysian-science-pack",
	"utility-science-pack",
	"cryogenic-science-pack",
}

data.raw.lab["cerys-lab-dummy"].inputs = {
	"fulgoran-cryogenics-progress",
}
data.raw.lab["cerys-lab-dummy"].next_upgrade = nil
data.raw.lab["cerys-lab"].next_upgrade = nil
data.raw.reactor["cerys-fulgoran-reactor"].next_upgrade = nil
data.raw["assembling-machine"]["cerys-fulgoran-cryogenic-plant"].next_upgrade = nil

--== Fix mods installing faulty next_upgrade on Cerys entities (5-dim, etc): ==--

local collision_mask_util = require("collision-mask-util")

for prototype in pairs(defines.prototypes.entity) do
	for _, entity in pairs(data.raw[prototype] or {}) do
		if string.sub(entity.name, 1, 6) == "cerys-" or string.sub(entity.name, 1, 21) == "radiative-tower-lamp-" then
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
end

return Public
