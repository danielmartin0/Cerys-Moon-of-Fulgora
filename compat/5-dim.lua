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
