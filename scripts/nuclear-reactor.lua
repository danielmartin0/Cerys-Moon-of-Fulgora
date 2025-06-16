local repair = require("scripts.reactor-repair")
local find = require("lib").find
local common = require("common")

local Public = {}

Public.REACTOR_TICK_INTERVAL = 3

local TEMPERATURE_ZERO = 15
local TEMPERATURE_LOSS_RATE = 2.5

local RANGE_SQUARED = 61 ^ 2
local DAMAGE_TICK_DELAY = 30

local BASE_DAMAGE = 70

local RADIATION_BAIL_CHANCE = 0.2

Public.REACTOR_NAME_TO_STAGE = {
	["cerys-fulgoran-reactor"] = repair.REACTOR_STAGE_ENUM.active,
	["cerys-fulgoran-reactor-wreck"] = repair.REACTOR_STAGE_ENUM.needs_excavation,
	["cerys-fulgoran-reactor-wreck-cleared"] = repair.REACTOR_STAGE_ENUM.needs_scaffold,
	["cerys-fulgoran-reactor-wreck-scaffolded"] = repair.REACTOR_STAGE_ENUM.needs_repair,
	["cerys-fulgoran-reactor-scaffolded"] = repair.REACTOR_STAGE_ENUM.needs_repair,
	["cerys-fulgoran-reactor-wreck-frozen"] = repair.REACTOR_STAGE_ENUM.frozen,
}

function Public.tick_reactor(surface, player_looking_at_surface)
	if not (storage.cerys and storage.cerys.reactor) then
		return
	end

	Public.register_reactor_if_missing(surface)

	local reactor = storage.cerys.reactor

	local e = reactor.entity
	if not (e and e.valid) then
		return
	end

	if reactor.stage == repair.REACTOR_STAGE_ENUM.frozen then
		if (not e.frozen) and game.tick > reactor.creation_tick + 300 then
			local e2 = surface.create_entity({
				name = "cerys-fulgoran-reactor-wreck",
				position = e.position,
				force = e.force,
				fast_replace = true,
			})

			if e2 and e2.valid then
				e2.minable_flag = false
				e2.destructible = false

				if e and e.valid then
					e.destroy()
				end

				reactor.entity = e2
			end

			reactor.stage = repair.REACTOR_STAGE_ENUM.needs_excavation
		end
	elseif reactor.stage == repair.REACTOR_STAGE_ENUM.active then
		Public.cool_reactor(e)

		if player_looking_at_surface and e.burner.currently_burning then
			Public.create_radiation(surface, e)
		end
	end
end

function Public.cool_reactor(reactor_entity)
	if reactor_entity.temperature > TEMPERATURE_ZERO then
		reactor_entity.temperature = reactor_entity.temperature
			- TEMPERATURE_LOSS_RATE * (Public.REACTOR_TICK_INTERVAL / 60)
	end
end

function Public.create_radiation(surface, reactor_entity)
	if math.random() < RADIATION_BAIL_CHANCE then
		return
	end

	local player_looking_at_surface = false
	for _, player in pairs(game.connected_players) do
		if player.valid and player.surface and player.surface.valid and player.surface.index == surface.index then
			player_looking_at_surface = true
		end
	end
	if not player_looking_at_surface then
		return
	end

	local angle = math.random() * 2 * math.pi

	local speed = 0.58 + 0.4 * math.random()

	local x_velocity = math.cos(angle) * speed
	local y_velocity = math.sin(angle) * speed
	local velocity = { x = x_velocity, y = y_velocity }

	local distance_from_reactor = 5
	local position = {
		x = reactor_entity.position.x + distance_from_reactor * math.cos(angle),
		y = reactor_entity.position.y + distance_from_reactor * math.sin(angle),
	}

	local e = surface.create_entity({
		name = "cerys-gamma-radiation",
		position = position,
	})

	table.insert(storage.cerys.radiation_particles, {
		entity = e,
		age = 0,
		velocity = velocity,
		position = position,
		spawn_position = position,
	})
end

function Public.tick_2_radiation(surface)
	if not (storage.cerys and storage.cerys.radiation_particles) then
		return
	end

	local damage = BASE_DAMAGE * (common.HARD_MODE_ON and 2 or 1)

	local i = 1
	while i <= #storage.cerys.radiation_particles do
		local particle = storage.cerys.radiation_particles[i]
		if (not particle.irradiation_tick) or (particle.irradiation_tick < game.tick - DAMAGE_TICK_DELAY) then
			local chars =
				surface.find_entities_filtered({ type = "character", position = particle.position, radius = 1 })

			for _, char in ipairs(chars) do
				if char and char.valid then
					local player = char.player
					if player and player.valid then
						player.play_sound({
							path = "cerys-radiation-impact",
							volume_modifier = 0.2,
						})
					end

					char.damage(damage, game.forces.neutral, "impact")
					particle.irradiation_tick = game.tick
				end
			end

			local storage_tanks = surface.find_entities_filtered({
				type = "storage-tank",
				position = particle.position,
				radius = 1.5,
			})

			local should_remove = false
			for _, tank in ipairs(storage_tanks) do
				if tank and tank.valid and tank.fluids_count then
					local fluid_contents = tank.get_fluid_contents()

					local stop = true
					for fluid_name, _ in pairs(fluid_contents) do
						if find(common.GAS_NAMES, fluid_name) then
							stop = false
							break
						end
					end

					local fill_fraction = tank.get_fluid_count() / tank.fluids_count
					if fill_fraction < 1 and math.random() > fill_fraction then
						stop = false
					end

					if stop then
						if particle.entity and particle.entity.valid then
							particle.entity.destroy()
						end
						should_remove = true
						break
					end
				end
			end

			if should_remove then
				table.remove(storage.cerys.radiation_particles, i)
			else
				i = i + 1
			end
		else
			i = i + 1
		end
	end
end

function Public.tick_1_move_radiation(tick)
	local i = 1
	while i <= #storage.cerys.radiation_particles do
		local particle = storage.cerys.radiation_particles[i]
		local e = particle.entity
		local v = particle.velocity

		if e.valid then
			e.teleport({ x = e.position.x + v.x, y = e.position.y + v.y })
			particle.position = { x = e.position.x, y = e.position.y }
			particle.age = particle.age + 1

			if tick % 10 == 0 then
				local d2 = (particle.position.x - (particle.spawn_position and particle.spawn_position.x or 0)) ^ 2
					+ (particle.position.y - (particle.spawn_position and particle.spawn_position.y or 0)) ^ 2

				if d2 > RANGE_SQUARED and math.random() < 0.4 then
					if particle.entity and particle.entity.valid then
						particle.entity.destroy()
					end

					table.remove(storage.cerys.radiation_particles, i)
				else
					i = i + 1
				end
			else
				i = i + 1
			end
		else
			table.remove(storage.cerys.radiation_particles, i)
		end
	end
end

function Public.register_reactor_if_missing(surface)
	local reactor = storage.cerys.reactor

	if not (reactor and reactor.entity and reactor.entity.valid) then
		local reactors = surface.find_entities_filtered({
			name = {
				"cerys-fulgoran-reactor",
				"cerys-fulgoran-reactor-wreck-cleared",
				"cerys-fulgoran-reactor-wreck",
				"cerys-fulgoran-reactor-wreck-frozen",
				"cerys-fulgoran-reactor-wreck-scaffolded",
				"cerys-fulgoran-reactor-scaffolded",
			},
		})

		if #reactors > 0 then
			local e = reactors[1]

			if e and e.valid then
				if e.name == "cerys-fulgoran-reactor-wreck-cleared" then
					e.minable_flag = true
				else
					e.minable_flag = false
				end
				e.destructible = false

				local stage = Public.REACTOR_NAME_TO_STAGE[e.name]
				if not stage then
					stage = repair.REACTOR_STAGE_ENUM.active
				end

				storage.cerys.reactor = {
					stage = stage,
					entity = e,
					creation_tick = game.tick,
				}
			end
		end
	end
end

return Public
