local repair = require("scripts.repair")
local common = require("common")

local Public = {}
local Private = {}

Public.REACTOR_TICK_INTERVAL = 3

local TEMPERATURE_ZERO = 15
local TEMPERATURE_LOSS_RATE = 3

local RANGE_SQUARED = 68 ^ 2
local DAMAGE_TICK_DELAY = 30

local BASE_DAMAGE = 68

function Public.tick_reactor(surface)
	if not (storage.cerys and storage.cerys.reactor) then
		return
	end

	local reactor = storage.cerys.reactor

	local e = reactor.entity
	if not (e and e.valid) then
		return
	end

	if reactor.stage == repair.REACTOR_STAGE_ENUM.frozen then
		if not e.frozen and game.tick > reactor.creation_tick + 300 then
			local e2 = surface.create_entity({
				name = "cerys-fulgoran-reactor-wreck",
				position = e.position,
				force = e.force,
				fast_replace = true,
			})

			if e2 and e2.valid then
				e2.destructible = false

				if e and e.valid then
					e.destroy()
				end

				reactor.entity = e2
			end

			reactor.stage = repair.REACTOR_STAGE_ENUM.needs_excavation
		end
	elseif reactor.stage == repair.REACTOR_STAGE_ENUM.active then
		Private.drain_reactor(e)

		if e.burner.currently_burning then
			Private.create_radiation(surface, e)
		end
	end
end

function Private.drain_reactor(reactor_entity)
	if reactor_entity.temperature > TEMPERATURE_ZERO then
		reactor_entity.temperature = reactor_entity.temperature
			- TEMPERATURE_LOSS_RATE * (Public.REACTOR_TICK_INTERVAL / 60)
	end
end

function Private.create_radiation(surface, reactor_entity)
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

	local speed = 0.7 + 0.3 * math.random()

	local x_velocity = math.cos(angle) * speed
	local y_velocity = math.sin(angle) * speed
	local velocity = { x = x_velocity, y = y_velocity }

	local distance_from_reactor = 5
	local position = {
		x = reactor_entity.position.x + distance_from_reactor * math.cos(angle),
		y = reactor_entity.position.y + distance_from_reactor * math.sin(angle),
	}

	local e = surface.create_entity({
		name = "cerys-radiation-particle",
		position = position,
	})

	table.insert(storage.cerys.radiation_particles, {
		entity = e,
		age = 0,
		velocity = velocity,
		position = position,
	})
end

function Public.tick_2_radiation(surface)
	if not (storage.cerys and storage.cerys.radiation_particles) then
		return
	end

	local damage = BASE_DAMAGE * settings.global["cerys-gamma-radiation-damage-multiplier"].value

	for _, particle in ipairs(storage.cerys.radiation_particles) do
		if (not particle.damage_tick) or (particle.damage_tick < game.tick - DAMAGE_TICK_DELAY) then
			local chars =
				surface.find_entities_filtered({ name = "character", position = particle.position, radius = 1.5 })

			for _, char in ipairs(chars) do
				if char and char.valid then
					local player = char.player
					if player and player.valid then
						player.play_sound({
							path = "cerys-radiation-impact",
							volume_modifier = 0.2,
						})
					end

					char.damage(damage, game.forces.neutral, "laser")
					particle.damage_tick = game.tick
				end
			end
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
				local d2 = (particle.position.x - common.REACTOR_POSITION.x) ^ 2
					+ (particle.position.y - common.REACTOR_POSITION.y) ^ 2

				if d2 > RANGE_SQUARED then
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

return Public
