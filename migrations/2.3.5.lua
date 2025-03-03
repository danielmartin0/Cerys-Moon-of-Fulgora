if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

local ice_decals = surface.find_decoratives_filtered({ name = "cerys-ice-decal-white" })

for _, decal in pairs(ice_decals) do
	local tile = surface.get_tile(decal.position)
	if tile and tile.valid then
		local is_dry_ice = string.find(tile.name, "dry%-ice")
		if not is_dry_ice then
			surface.destroy_decoratives({
				name = "cerys-ice-decal-white",
				position = decal.position,
			})
		end
	end
end
