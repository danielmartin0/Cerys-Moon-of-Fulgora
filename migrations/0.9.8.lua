local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

local common = require("common")
local lithium_brines = surface.find_entities_filtered({ name = "lithium-brine" })

local adjusted_lithium_position = {
	x = common.LITHIUM_POSITION.x * common.get_cerys_surface_stretch_factor(surface),
	y = common.LITHIUM_POSITION.y / common.get_cerys_surface_stretch_factor(surface),
}

for _, entity in pairs(lithium_brines) do
	if entity and entity.valid then
		local dx = entity.position.x - adjusted_lithium_position.x
		local dy = entity.position.y - adjusted_lithium_position.y
		local d2 = dx * dx + dy * dy
		if d2 > 25 * 25 then
			game.print(
				"[CERYS]: Migrating save: destroying bugged lithium brine at "
					.. entity.position.x
					.. ", "
					.. entity.position.y
			)
			entity.destroy()
		end
	end
end
