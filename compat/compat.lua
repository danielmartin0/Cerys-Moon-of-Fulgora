-- This override is because many mods add their science packs to all modded labs. If a mod wants to mark Cerys as a dependency and extend these inputs, that is fine.
data.raw.lab["cerys-lab"].inputs = {
	"automation-science-pack",
	"logistic-science-pack",
	"cerys-science-pack",
	"utility-science-pack",
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
