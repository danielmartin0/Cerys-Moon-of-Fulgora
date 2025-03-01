local Public = {}

Public.DEBUG_DISABLE_FREEZING = false
Public.DEBUG_CERYS_START = false
Public.DEBUG_HEATERS_FUELED = false
Public.DEBUG_NUCLEAR_REACTOR_START = false

Public.HARDCORE_ON = settings.startup["cerys-hardcore-mode"].value

Public.CERYS_RADIUS = 128
-- Public.CERYS_RADIUS = 142
Public.RADIATIVE_TOWER_SHIFT_PIXELS = 109
Public.REACTOR_POSITION_SEED = { x = 20, y = 29 }
Public.LITHIUM_ACTUAL_POSITION = { x = 100, y = -4 }
Public.FACTORIO_UNDO_FROZEN_TINT = { 1, 0.91, 0.82, 1 }
Public.LAMP_COUNT = 17
Public.DAY_LENGTH_MINUTES = 5 -- Fulgora is 3 minutes
Public.FIRST_CRYO_REPAIR_RECIPES_NEEDED = 75
Public.SOLAR_IMAGE_CIRCLE_SIZE = 2400 -- Not an exact science
Public.SOLAR_IMAGE_SIZE = 4096
Public.REPROCESSING_U238_TO_U235_RATIO = 20
Public.WARN_COLOR = { r = 255, g = 90, b = 54 }

-- TODO: Add widths and heights of map generated factory entities

Public.ROCK_TILES = {
	"cerys-ash-cracks",
	"cerys-ash-cracks-frozen",
	"cerys-ash-cracks-frozen-from-dry-ice",
	"cerys-ash-dark",
	"cerys-ash-dark-frozen",
	"cerys-ash-dark-frozen-from-dry-ice",
	-- "cerys-ash-flats", -- Never included in the published mod
	-- "cerys-ash-flats-frozen", -- Never included in the published mod
	-- "cerys-ash-flats-frozen-from-dry-ice", -- Never included in the published mod
	"cerys-ash-light",
	"cerys-ash-light-frozen",
	"cerys-ash-light-frozen-from-dry-ice",
	"cerys-pumice-stones",
	"cerys-pumice-stones-frozen",
	"cerys-pumice-stones-frozen-from-dry-ice",
}

Public.SPACE_TILES_AROUND_CERYS = {
	"out-of-map",
	"empty-space",
	"cerys-empty-space",
	"cerys-empty-space-2",
	"cerys-empty-space-3",
}

Public.GAS_NAMES = {
	"steam",
	"methane",
	"petroleum-gas",
	"fusion-plasma",
}

function Public.get_cerys_surface_stretch_factor(cerys_surface)
	local height_starts_stretching = Public.CERYS_RADIUS * (Public.HARDCORE_ON and 2.4 or 1.6)
	local max_stretch_factor = 6

	local stretch_factor = math.min(
		max_stretch_factor,
		height_starts_stretching / math.min(cerys_surface.map_gen_settings.height / 2, height_starts_stretching)
	)

	return stretch_factor
end

function Public.cerys_surface_stretch_factor_for_math()
	if Public.HARDCORE_ON then
		return "min(6, (cerys_radius * 2.4) / min(map_height / 2, cerys_radius * 2.4))"
	else
		return "min(6, (cerys_radius * 1.6) / min(map_height / 2, cerys_radius * 1.6))"
	end
end

function Public.get_cerys_semimajor_axis(cerys_surface)
	return Public.CERYS_RADIUS * Public.get_cerys_surface_stretch_factor(cerys_surface)
end

return Public
