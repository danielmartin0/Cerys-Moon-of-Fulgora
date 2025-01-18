local Public = {}

Public.DEBUG_DISABLE_FREEZING = false
Public.DEBUG_CERYS_START = false
Public.DEBUG_HEATERS_FUELED = false
Public.DEBUG_NUCLEAR_REACTOR_START = false

Public.MOON_RADIUS = 142
Public.RADIATIVE_TOWER_SHIFT_PIXELS = 109
Public.REACTOR_POSITION = { x = 21, y = 29 }
Public.LITHIUM_POSITION = { x = 111, y = -5 }
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

Public.GAS_NAMES = {
	"steam",
	"methane",
	"petroleum-gas",
	"fusion-plasma",
}

Public.FACTORIO_UNDO_FROZEN_TINT = { 1, 0.91, 0.82, 1 }

return Public
