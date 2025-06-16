local Public = {}

Public.DEBUG_DISABLE_FREEZING = false
Public.DEBUG_CERYS_START = false
Public.DEBUG_HEATERS_FUELED = false
Public.DEBUG_NUCLEAR_REACTOR_START = false

Public.GRAVITY_MIN = {
	property = "gravity",
	min = 0.15,
}
Public.FIVE_PRESSURE_MIN = {
	property = "pressure",
	min = 5,
}
Public.TEN_PRESSURE_MIN = {
	property = "pressure",
	min = 10,
}
Public.AMBIENT_RADIATION_MAX = {
	property = "cerys-ambient-radiation",
	max = 200,
}
Public.AMBIENT_RADIATION_MIN = {
	property = "cerys-ambient-radiation",
	min = 400,
}

Public.HARD_MODE_ON = settings.startup["cerys-hardcore-mode"].value

Public.CERYS_RADIUS = 128
-- Public.CERYS_RADIUS = 142
Public.RADIATIVE_TOWER_SHIFT_PIXELS = 109
Public.REACTOR_POSITION_SEED = { x = 20, y = 29 }
Public.LITHIUM_ACTUAL_POSITION = { x = 93, y = 0 }
Public.FACTORIO_UNDO_FROZEN_TINT = { 1, 0.91, 0.82, 1 }
-- Public.LAMP_COUNT = 17
Public.LAMP_COUNT = 30 -- Accounting for quality
Public.DAY_LENGTH_MINUTES = 6 -- Fulgora is 3 minutes
Public.FIRST_CRYO_REPAIR_RECIPES_NEEDED = 60
Public.SOLAR_IMAGE_CIRCLE_SIZE = 2400 -- Not an exact science
Public.SOLAR_IMAGE_SIZE = 4096
Public.REPROCESSING_U238_TO_U235_RATIO = 20
Public.TELEPORTER_POSITION_SEED = { x = -76, y = 2 }

Public.WARN_COLOR = { r = 255, g = 90, b = 54 }
Public.FRIENDLY_COLOR = { r = 227, g = 250, b = 192 }

Public.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS = 16
Public.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_HARD_MODE = 10
Public.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_PLAYER = 13

Public.ROCK_TILES = {
	"cerys-ash-cracks",
	"cerys-ash-cracks-frozen",
	"cerys-ash-cracks-frozen-from-dry-ice",
	"cerys-ash-dark",
	"cerys-ash-dark-frozen",
	"cerys-ash-dark-frozen-from-dry-ice",
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
}

Public.GAS_NAMES = {
	"steam",
	"methane",
	"petroleum-gas",
	"fusion-plasma",
}

Public.SOFTBANNED_RESOURCES = {
	"heavy-oil",
	"crude-oil",
	"coal",
	"steam",
	-- "stone", -- having stone is OK as long as you don't make power
}

function Public.get_cerys_surface_stretch_factor(cerys_surface)
	local height_starts_stretching = Public.CERYS_RADIUS * (Public.HARD_MODE_ON and 2.4 or 1.6)
	local max_stretch_factor = 6

	local stretch_factor = math.min(
		max_stretch_factor,
		height_starts_stretching / math.min(cerys_surface.map_gen_settings.height / 2, height_starts_stretching)
	)

	return stretch_factor
end

function Public.cerys_surface_stretch_factor_for_math()
	if Public.HARD_MODE_ON then
		return "min(6, (cerys_radius * 2.4) / min(map_height / 2, cerys_radius * 2.4))"
	else
		return "min(6, (cerys_radius * 1.6) / min(map_height / 2, cerys_radius * 1.6))"
	end
end

function Public.get_cerys_semimajor_axis(cerys_surface)
	return Public.CERYS_RADIUS * Public.get_cerys_surface_stretch_factor(cerys_surface)
end

return Public
