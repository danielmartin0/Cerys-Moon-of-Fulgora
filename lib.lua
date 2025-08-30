local util = require("util")
local common = require("common")

local Public = {}

function Public.get_cerys_surface_stretch_factor(cerys_surface)
	local height_starts_stretching = common.CERYS_RADIUS * (common.HARD_MODE_ON and 2.4 or 1.6)
	local max_stretch_factor = 6

	local stretch_factor = math.min(
		max_stretch_factor,
		height_starts_stretching / math.min(cerys_surface.map_gen_settings.height / 2, height_starts_stretching)
	)

	return stretch_factor
end

function Public.cerys_surface_stretch_factor_for_math()
	if common.HARD_MODE_ON then
		return "min(6, (cerys_radius * 2.4) / min(map_height / 2, cerys_radius * 2.4))"
	else
		return "min(6, (cerys_radius * 1.6) / min(map_height / 2, cerys_radius * 1.6))"
	end
end

function Public.get_cerys_semimajor_axis(cerys_surface)
	return common.CERYS_RADIUS * Public.get_cerys_surface_stretch_factor(cerys_surface)
end

function Public.generated_cerys_surface()
	local surface = game.surfaces["cerys"]
	if not (surface and surface.valid) then
		return false
	end

	local some_chunk_generated = false

	for chunk in surface.get_chunks() do
		if surface.is_chunk_generated(chunk) then
			some_chunk_generated = true
			break
		end
	end

	if not some_chunk_generated then
		return false
	end

	return surface
end

function Public.can_mine_fulgoran_towers(force)
	if not force then
		return false
	end

	if not force.technologies[common.FULGORAN_TOWER_MINING_TECH_NAME] then
		return false
	end

	if not force.technologies[common.FULGORAN_TOWER_MINING_TECH_NAME].researched then
		return false
	end

	return true
end

function Public.make_radiative_towers_minable()
	if storage.radiative_towers then
		for _, tower in pairs(storage.radiative_towers.towers or {}) do
			if tower.entity and tower.entity.valid and not tower.is_player_tower then
				tower.entity.minable_flag = true
			end
		end

		for _, tower in pairs(storage.radiative_towers.contracted_towers or {}) do
			if tower.entity and tower.entity.valid then
				tower.entity.minable_flag = true
			end
		end
	end
end

function Public.merge(old, new)
	old = util.table.deepcopy(old)

	for k, v in pairs(new) do
		if v == "nil" then
			old[k] = nil
		else
			old[k] = v
		end
	end

	return old
end

Public.find = function(tbl, f, ...)
	if type(f) == "function" then
		for k, v in pairs(tbl) do
			if f(v, k, ...) then
				return v, k
			end
		end
	else
		for k, v in pairs(tbl) do
			if v == f then
				return v, k
			end
		end
	end
	return nil
end

return Public
