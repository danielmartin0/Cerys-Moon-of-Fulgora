local Public = {}

Public.DEBUG_DISABLE_FREEZING = false
Public.DEBUG_HEATERS_FUELED = false
Public.DEBUG_NUCLEAR_REACTOR_START = false
Public.DEBUG_CHARGING_RODS_FULL = false

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
	max = 300,
}
Public.AMBIENT_RADIATION_MIN = {
	property = "cerys-ambient-radiation",
	min = 400,
}

Public.HARD_MODE_ON = settings.startup["cerys-hardcore-mode"].value

Public.CERYS_RADIUS = 127
-- Public.CERYS_RADIUS = 142

Public.PARTICLE_SIMULATION_SPEED = 1

Public.RADIATIVE_TOWER_SHIFT_PIXELS = 109
Public.REACTOR_POSITION_SEED = { x = 20, y = 29 }
Public.LITHIUM_ACTUAL_POSITION = { x = 93, y = 0 }
Public.FACTORIO_UNDO_FROZEN_TINT = { 1, 0.91, 0.82, 1 }
-- Public.LAMP_COUNT = 17
Public.LAMP_COUNT = 30 -- Accounting for quality
Public.DAY_LENGTH_MINUTES = 6 -- Fulgora is 3 minutes
Public.FIRST_CRYO_REPAIR_RECIPES_NEEDED = 50
Public.DEFAULT_CRYO_REPAIR_RECIPES_NEEDED = Public.HARD_MODE_ON and 200 or 100 -- Having more than two distinct values is a bad idea
Public.DEFAULT_CRUSHER_REPAIR_RECIPES_NEEDED = 20
Public.REACTOR_CONCRETE_TO_EXCAVATE = 4000
Public.BASE_REACTOR_REPAIR_RECIPES_NEEDED = Public.HARD_MODE_ON and 1000 or 400

Public.SOLAR_IMAGE_CIRCLE_SIZE = 2400 -- Not an exact science
Public.SOLAR_IMAGE_SIZE = 4096
Public.REPROCESSING_U238_TO_U235_RATIO = 10
Public.TELEPORTER_POSITION = { x = -70.5, y = -29.5 }

Public.WARN_COLOR = { r = 255, g = 90, b = 54 }
Public.FRIENDLY_COLOR = { r = 227, g = 250, b = 192 }

Public.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS = 16
Public.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_HARD_MODE = 10
Public.FULGORAN_RADIATIVE_TOWER_HEATING_RADIUS_PLAYER = 13
Public.MAX_HEATING_RADIUS = 30

Public.REACTOR_COOLING_PER_SECOND = 2.5

Public.DEFAULT_FULGORA_IMAGE_SIZE = 2048

Public.FULGORAN_TOWER_MINING_TECH_NAME = "cerys-radiative-heaters"

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

Public.KNOWN_GAS_NAMES = {
	"steam",
	"methane",
	"petroleum-gas",
	"fusion-plasma",
	"oxygen",
	"hydrogen",
}

Public.SOFTBANNED_RESOURCES = {
	"heavy-oil",
	"crude-oil",
	"coal",
	"steam",
	-- "stone", -- having stone is OK as long as you don't make power
}

Public.TILE_REPLACEMENTS = {
	["concrete"] = "cerys-concrete-minable",
	["refined-concrete"] = "cerys-refined-concrete",
	["hazard-concrete-left"] = "cerys-hazard-concrete-left",
	["hazard-concrete-right"] = "cerys-hazard-concrete-right",
	["refined-hazard-concrete-left"] = "cerys-refined-hazard-concrete-left",
	["refined-hazard-concrete-right"] = "cerys-refined-hazard-concrete-right",
	["frozen-concrete"] = "cerys-frozen-concrete-minable",
	["frozen-refined-concrete"] = "cerys-frozen-refined-concrete",
	["frozen-hazard-concrete-left"] = "cerys-frozen-hazard-concrete-left",
	["frozen-hazard-concrete-right"] = "cerys-frozen-hazard-concrete-right",
	["frozen-refined-hazard-concrete-left"] = "cerys-frozen-refined-hazard-concrete-left",
	["frozen-refined-hazard-concrete-right"] = "cerys-frozen-refined-hazard-concrete-right",
	["foundation"] = "cerys-foundation",
	["ice-platform"] = "cerys-ice-platform",
}

Public.TILE_REPLACEMENTS_INVERSE = {}
for name, replacement in pairs(Public.TILE_REPLACEMENTS) do
	Public.TILE_REPLACEMENTS_INVERSE[replacement] = name
end

return Public
