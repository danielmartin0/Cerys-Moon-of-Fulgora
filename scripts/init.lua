local common = require("common")
local repair = require("reactor-repair")
local terrain = require("terrain")

local Public = {}

function Public.initialize_cerys(surface) -- Must run before terrain generation
	if storage.cerys and surface and surface.valid then
		return
	end

	Public.delete_cerys_storage_if_necessary()

	if not surface then
		surface = game.planets["cerys"].create_surface()
	end

	if not surface.valid then
		game.delete_surface("cerys")
		surface = game.planets["cerys"].create_surface()
	end

	surface.min_brightness = 0.2
	surface.brightness_visual_weights = { 0.12, 0.15, 0.12 }

	Public.ensure_cerys_storage_and_tables()
	Public.create_reactor(surface)

	return surface
end

function Public.create_reactor(surface)
	local name = common.DEBUG_NUCLEAR_REACTOR_START and "cerys-fulgoran-reactor"
		or "cerys-fulgoran-reactor-wreck-frozen"

	local entities = surface.find_entities_filtered({
		area = {
			{ common.REACTOR_POSITION.x - 11, common.REACTOR_POSITION.y - 11 },
			{ common.REACTOR_POSITION.x + 11, common.REACTOR_POSITION.y + 11 },
		},
	})

	for _, entity in pairs(entities) do
		if entity and entity.valid and entity.type == "character" then
			entity.teleport({ 0, 0 })
		else
			entity.destroy()
		end
	end

	local e = surface.create_entity({
		name = name,
		position = common.REACTOR_POSITION,
		force = "player",
	})

	e.minable_flag = false
	e.destructible = false

	local stage = common.DEBUG_NUCLEAR_REACTOR_START and repair.REACTOR_STAGE_ENUM.active
		or repair.REACTOR_STAGE_ENUM.frozen

	storage.cerys.reactor = {
		stage = stage,
		entity = e,
		creation_tick = game.tick,
	}
end

script.on_init(function()
	if common.DEBUG_MOON_START then
		Public.initialize_cerys()
	end
end)

script.on_event(defines.events.on_surface_created, function(event)
	local surface_index = event.surface_index
	local surface = game.surfaces[surface_index]

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	Public.initialize_cerys(surface)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	if not storage.cerys then
		-- Hold on tiger. You must have generated the surface in a non-standard way. Let's run this first:
		Public.initialize_cerys(surface)
	end

	terrain.on_cerys_chunk_generated(event, surface)
end)

function Public.delete_cerys_storage_if_necessary()
	local surface = game.surfaces["cerys"]
	if storage.cerys and not (surface and surface.valid) then
		-- Reset the cerys table:
		storage.cerys = nil
	end
end

function Public.ensure_cerys_storage_and_tables()
	if not storage.cerys then
		storage.cerys = {
			initialization_version = script.active_mods["Cerys-Moon-of-Fulgora"],
		}
	end

	if not storage.cerys.charging_rods then
		storage.cerys.charging_rods = {}
	end

	if not storage.cerys.charging_rod_is_negative then
		storage.cerys.charging_rod_is_negative = {}
	end

	if not storage.cerys.solar_wind_particles then
		storage.cerys.solar_wind_particles = {}
	end

	if not storage.cerys.radiation_particles then
		storage.cerys.radiation_particles = {}
	end

	if not storage.cerys.asteroids then
		storage.cerys.asteroids = {}
	end

	if not storage.cerys.heating_towers then
		storage.cerys.heating_towers = {}
	end

	if not storage.cerys.heating_towers_contracted then
		storage.cerys.heating_towers_contracted = {}
	end

	if not storage.cerys.broken_cryo_plants then
		storage.cerys.broken_cryo_plants = {}
	end

	if not storage.background_renderings then
		storage.background_renderings = {}
	end

	if not storage.accrued_probability_units then
		storage.accrued_probability_units = 0
	end
end

return Public
