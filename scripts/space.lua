local common = require("common")

local Public = {}

local SOLAR_WIND_SPAWN_CHANCE_PER_TICK = 1 / 24

local OUT_OF_BOUNDS_D2 = (common.MOON_RADIUS * (2 ^ (1 / 2)) * 1.5 + 5) ^ 2
local SOLAR_WIND_MIN_VELOCITY = 0.2
local MAX_AGE = SOLAR_WIND_MIN_VELOCITY * 2 * 32 * (common.MOON_RADIUS + 150) * 1.5

local ROD_DEFLECTION_STRENGTH = 1 / 10
local ROD_MAX_RANGE_SQUARED = 25 * 25

local CHANCE_DAMAGE_CHARACTER = 1 / 40
local COOLDOWN_DISTANCE = 1

-- These shouldn't be crazy different such that the player doesn't get punished much if they don't figure this bit out:
local CHANCE_MUTATE_BELT_URANIUM_IN_CHECK = 1 / 15000
local CHANCE_MUTATE_INVENTORY_URANIUM_IN_CHECK = 1 / 45000 -- shouldn't be greater than 1 over the max chest capacity for our algorithm to make sense.

local ASTEROID_TO_PERCENTAGE_RATE = {
	["small-metallic-asteroid-planetary"] = 0.75,
	["medium-metallic-asteroid-planetary"] = 0.5,
	["small-carbonic-asteroid-planetary"] = 5,
	["medium-carbonic-asteroid-planetary"] = 1.75,
	["small-oxide-asteroid-planetary"] = 4,
	["medium-oxide-asteroid-planetary"] = 1.5,
}

function Public.spawn_asteroid(surface, y_position)
	y_position = y_position or -(common.MOON_RADIUS + 60)

	local random_value = math.random() * 100
	local chosen_name = nil
	local running_total = 0
	for name, weight in pairs(ASTEROID_TO_PERCENTAGE_RATE) do
		running_total = running_total + weight
		if random_value <= running_total then
			chosen_name = name
			break
		end
	end

	if not chosen_name then
		return
	end

	local x = math.random(-common.MOON_RADIUS * 1.5, common.MOON_RADIUS * 1.5)

	local e = surface.create_entity({
		name = chosen_name,
		position = { x = x, y = y_position },
	})

	if e and e.valid then
		storage.cerys.asteroids[#storage.cerys.asteroids + 1] = e
	end
end

function Public.tick_2_try_spawn_solar_wind_particle(surface)
	if math.random() < SOLAR_WIND_SPAWN_CHANCE_PER_TICK * 2 then
		local y = math.random(-common.MOON_RADIUS - 6, common.MOON_RADIUS + 6)

		local e = surface.create_entity({
			name = "cerys-solar-wind-particle",
			position = { x = -(common.MOON_RADIUS + math.random(65, 70)), y = y },
		})

		table.insert(storage.cerys.solar_wind_particles, {
			entity = e,
			age = 0,
			velocity = Public.initial_solar_wind_velocity(),
			position = { x = -(common.MOON_RADIUS + 150), y = y },
		})
	end
end

function Public.initial_solar_wind_velocity()
	local x_velocity = SOLAR_WIND_MIN_VELOCITY + math.random() * 0.1
	local y_velocity = 0.3 * (math.random() - 0.5) ^ 3

	return { x = x_velocity, y = y_velocity }
end

local max_charging_rod_energy = prototypes.entity["charging-rod"].electric_energy_source_prototype.buffer_capacity
local MIN_ELECTROMAGNETIC_DISTANCE = 0.005

function Public.tick_9_solar_wind_deflection()
	for _, particle in ipairs(storage.cerys.solar_wind_particles) do
		local p_particle = particle.position

		for unit_number, rod in pairs(storage.cerys.charging_rods) do
			local p_rod = rod.rod_position

			local dx = p_particle.x - p_rod.x
			local dy = p_particle.y - p_rod.y
			local d2 = dx * dx + dy * dy

			-- Bound the minimum distance
			if d2 == 0 then
				local random_angle = math.random() * 2 * math.pi
				dx = MIN_ELECTROMAGNETIC_DISTANCE * math.cos(random_angle)
				dy = MIN_ELECTROMAGNETIC_DISTANCE * math.sin(random_angle)
				d2 = dx * dx + dy * dy
			elseif d2 < MIN_ELECTROMAGNETIC_DISTANCE * MIN_ELECTROMAGNETIC_DISTANCE then
				local scale = MIN_ELECTROMAGNETIC_DISTANCE / math.sqrt(d2)
				dx = dx * scale
				dy = dy * scale
				d2 = dx * dx + dy * dy
			end

			if d2 < ROD_MAX_RANGE_SQUARED then
				local rod_e = rod.entity

				if rod_e and rod_e.valid then
					if rod_e.energy > 0 then
						local sign = storage.cerys.charging_rod_is_negative[rod_e.unit_number] and 1 or -1

						local charged_fraction = rod_e.energy / max_charging_rod_energy

						local deflection = ROD_DEFLECTION_STRENGTH * charged_fraction * sign

						local dvx = dx / (d2 ^ (5 / 4)) * deflection
						local dvy = dy / (d2 ^ (5 / 4)) * deflection

						local v = particle.velocity
						v.x = v.x + dvx
						v.y = v.y + dvy
						particle.velocity = v
					end
				else
					local lamp = rod.lamp
					if lamp and lamp.valid then
						lamp.destroy()
					end
					storage.cerys.charging_rods[unit_number] = nil
				end
			end
		end
	end
end

function Public.tick_1_move_solar_wind()
	local i = 1
	while i <= #storage.cerys.solar_wind_particles do
		local particle = storage.cerys.solar_wind_particles[i]
		local e = particle.entity
		local v = particle.velocity

		if e.valid then
			e.teleport({ x = e.position.x + v.x, y = e.position.y + v.y })
			particle.position = { x = e.position.x, y = e.position.y }
			particle.age = particle.age + 1
			i = i + 1
		else
			table.remove(storage.cerys.solar_wind_particles, i)
		end
	end
end

function Public.tick_240_clean_up_cerys_solar_wind_particles()
	local i = 1
	while i <= #storage.cerys.solar_wind_particles do
		local particle = storage.cerys.solar_wind_particles[i]
		local kill = false
		if particle.age > MAX_AGE then
			kill = true
		elseif particle.position.x ^ 2 + particle.position.y ^ 2 > OUT_OF_BOUNDS_D2 then
			kill = true
		end

		if kill then
			if particle.entity and particle.entity.valid then
				particle.entity.destroy()
			end

			table.remove(storage.cerys.solar_wind_particles, i)
		else
			i = i + 1
		end
	end
end

function Public.tick_240_clean_up_cerys_asteroids()
	local i = 1
	while i <= #storage.cerys.asteroids do
		local e = storage.cerys.asteroids[i]

		if e and e.valid then
			local d2 = e.position.x ^ 2 + e.position.y ^ 2
			if d2 > OUT_OF_BOUNDS_D2 then
				e.destroy()

				table.remove(storage.cerys.asteroids, i)
			else
				i = i + 1
			end
		else
			table.remove(storage.cerys.asteroids, i)
		end
	end
end

local container_names = {}
for _, e in pairs(prototypes["entity"]) do
	if e.type == "container" or e.type == "logistic-container" then
		table.insert(container_names, e.name)
	end
end

local belt_names = {}
for _, e in pairs(prototypes["entity"]) do
	if e.type == "transport-belt" then
		table.insert(belt_names, e.name)
	end
end

local CHANCE_CHECK_BELT = 1 / 20
function Public.tick_10_solar_wind_collisions(surface)
	for _, particle in ipairs(storage.cerys.solar_wind_particles) do
		if not Public.particle_is_in_cooldown(particle) then
			local chars =
				surface.find_entities_filtered({ name = "character", position = particle.position, radius = 1 })
			if #chars > 0 then
				local e = chars[1]
				if e and e.valid then
					local inv = e.get_main_inventory()
					if inv and inv.valid then
						local irradiated = Public.irradiate_inventory(inv)
						if irradiated then
							particle.damage_tick = game.tick

							surface.create_entity({
								name = "plutonium-explosion",
								position = e.position,
							})
						end
					end

					if math.random() < CHANCE_DAMAGE_CHARACTER then
						local player = e.player
						if player and player.valid then
							player.play_sound({
								path = "cerys-radiation-impact",
								volume_modifier = 0.2,
							})
						end

						e.damage(15, game.forces.neutral, "laser")

						particle.damage_tick = game.tick
					end
				end
			end
		end

		if not Public.particle_is_in_cooldown(particle) then
			local containers = surface.find_entities_filtered({
				name = container_names,
				position = particle.position,
				radius = 1,
			})

			if #containers > 0 then
				local e = containers[1]
				if e and e.valid then
					local inv = e.get_inventory(defines.inventory.chest)
					if inv and inv.valid then
						local irradiated = Public.irradiate_inventory(inv)
						if irradiated then
							particle.damage_tick = game.tick

							surface.create_entity({
								name = "plutonium-explosion",
								position = e.position,
							})
						end
					end
				end
			end
		end

		if (math.random() < CHANCE_CHECK_BELT) and not Public.particle_is_in_cooldown(particle) then
			local belts = surface.find_entities_filtered({
				name = belt_names,
				position = particle.position,
				radius = 1,
			})
			if #belts > 0 then
				local e = belts[1]
				if e and e.valid then
					local lines = {
						e.get_transport_line(1),
						e.get_transport_line(2),
					}

					for _, line in pairs(lines) do
						local contents = line.get_detailed_contents()
						for _, item in pairs(contents) do
							if
								item.stack.name == "uranium-238"
								and math.random()
									< (CHANCE_MUTATE_BELT_URANIUM_IN_CHECK / CHANCE_CHECK_BELT) * item.stack.count
							then
								item.stack.set_stack({
									name = "plutonium-239",
									count = item.stack.count,
									quality = item.stack.quality,
								})

								surface.create_entity({
									name = "plutonium-explosion",
									position = e.position,
								})

								particle.damage_tick = game.tick
							end
						end
					end
				end
			end
		end
	end
end

function Public.particle_is_in_cooldown(particle)
	if not particle.damage_tick then
		return false
	end

	local v2 = particle.velocity.x ^ 2 + particle.velocity.y ^ 2
	local speed = math.sqrt(v2)

	local cooldown_time = COOLDOWN_DISTANCE / speed
	if game.tick < particle.damage_tick + cooldown_time then
		return true
	end

	particle.damage_tick = nil
	return false
end

function Public.irradiate_inventory(inv)
	for _, quality in pairs(prototypes.quality) do
		local name = quality.name
		local count = inv.get_item_count({ name = "uranium-238", quality = name })
		if count then
			-- TODO: Knuth algorithm for Poisson distribution
			if math.random() < count * CHANCE_MUTATE_INVENTORY_URANIUM_IN_CHECK then
				local removed = inv.remove({ name = "uranium-238", count = 100, quality = name })
				inv.insert({ name = "plutonium-239", count = 1, quality = name })
				if removed > 1 then
					inv.insert({ name = "uranium-238", count = removed - 1, quality = name })
				end

				return true
			end
		end
	end

	return false
end

local ASTEROIDS_TO_DROPS = {
	["small-metallic-asteroid-planetary"] = { ["metallic-asteroid-chunk"] = 1 },
	["small-carbonic-asteroid-planetary"] = { ["carbonic-asteroid-chunk"] = 1 },
	["small-oxide-asteroid-planetary"] = { ["oxide-asteroid-chunk"] = 1 },
}

script.on_event(defines.events.on_entity_died, function(event)
	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	local surface = entity.surface

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	local drop_info = ASTEROIDS_TO_DROPS[entity.name]
	if not drop_info then
		return
	end

	local drop_name, drop_count = next(drop_info)

	local force = event.force

	if not (force and force.valid) then
		return
	end

	for _ = 1, drop_count do
		-- TODO: Support modded belts
		local belts = surface.find_entities_filtered({ name = Public.belt_names, position = entity.position })

		local placed = false
		if #belts > 0 and belts[1].valid then
			local belt = belts[1]
			local line_index, line_pos = belt.get_item_insert_specification(entity.position)

			if line_index and line_pos then
				local line = belt.get_transport_line(line_index)

				if line and line.valid then
					placed = line.insert_at(line_pos, { name = drop_name, count = 1 })
				end
			end
		end

		if not placed then
			local position = surface.find_non_colliding_position("item-on-ground", entity.position, 2, 0.2)

			if not position then
				return
			end

			local e = surface.create_entity({
				name = "item-on-ground",
				position = position,
				force = force,
				stack = { name = drop_name, count = drop_count },
			})
			if e and e.valid then
				e.to_be_looted = true
				e.order_deconstruction(force)
			end
		end
	end
end)

Public.belt_names = { "transport-belt", "fast-transport-belt", "express-transport-belt", "turbo-transport-belt" }

return Public
