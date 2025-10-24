local common = require("common")
local lib = require("lib")
local find = lib.find

local Public = {}

function Public.update_plutonium_productivity_modifier()
	local max_level = 0

	for _, force in pairs(game.forces) do
		local tech = force.technologies["cerys-plutonium-productivity"]
		local level = tech.level
		max_level = math.max(max_level, level - 1) -- If we're at level 8, we've done level 7
	end

	local modifier = 1.0 + (max_level * 0.1)

	storage.plutonium_productivity_modifier = modifier

	return modifier
end

local spd = common.PARTICLE_SIMULATION_SPEED
local ASTEROID_SPAWN_DISTANCE_FROM_EDGE = 60
local WIND_SPAWN_DISTANCE_FROM_EDGE = 70

local MIN_ELECTROMAGNETIC_INTERACTION_DISTANCE = 2

local ROD_MAX_RANGE = 25
local ROD_MAX_RANGE_SQUARED = ROD_MAX_RANGE * ROD_MAX_RANGE
local ROD_DEFLECTION_STRENGTH = 8 / 4.5 * spd ^ 2

local MIN_INITIAL_VELOCITY = 0.15 * spd
local MAX_AGE = MIN_INITIAL_VELOCITY * 2 * 32 * (common.CERYS_RADIUS + 150) * 10
local MIN_SPEED_THRESHOLD = 0.025
local MIN_SPEED_THRESHOLD_SQUARED = MIN_SPEED_THRESHOLD * MIN_SPEED_THRESHOLD
local PARTICLE_SHRINK_TIME = 14

local CHANCE_DAMAGE_CHARACTER = common.HARD_MODE_ON and 1 or 0.011

local CHANCE_MUTATE_BELT_URANIUM = 1 / 267
local CHANCE_MUTATE_INVENTORY_URANIUM = 1 / 8000

local ASTEROID_TO_PERCENTAGE_RATE = {
	["small-metallic-asteroid-planetary"] = 0.8,
	["medium-metallic-asteroid-planetary"] = 1.3,
	["small-carbonic-asteroid-planetary"] = 4,
	["medium-carbonic-asteroid-planetary"] = 2,
	["small-oxide-asteroid-planetary"] = 4,
	["medium-oxide-asteroid-planetary"] = 2,
}

if script.active_mods["cupric-asteroids"] then
	ASTEROID_TO_PERCENTAGE_RATE["small-cupric-asteroid-planetary"] = 0.8
	ASTEROID_TO_PERCENTAGE_RATE["medium-cupric-asteroid-planetary"] = 1.3
end

local MAX_CHUNKS_ON_GROUND = 20

function Public.try_spawn_asteroid(surface)
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

	if not prototypes.entity[chosen_name] then
		return
	end

	local semimajor_axis = lib.get_cerys_semimajor_axis(surface)
	local x = math.random(-semimajor_axis - 70, semimajor_axis + 70)

	local y_position = -(common.CERYS_RADIUS + ASTEROID_SPAWN_DISTANCE_FROM_EDGE)

	if y_position < -surface.map_gen_settings.height / 2 then
		local trial_position = -surface.map_gen_settings.height / 2 + 0.5
		local tile_1 = surface.get_tile(0, trial_position - 32)
		local tile_2 = surface.get_tile(0, trial_position)

		if tile_1 and tile_1.valid and find(common.SPACE_TILES_AROUND_CERYS, tile_1.name) then
			y_position = trial_position - 32
		elseif tile_2 and tile_2.valid and find(common.SPACE_TILES_AROUND_CERYS, tile_2.name) then
			y_position = trial_position
		else
			surface.set_tiles({ { name = "cerys-empty-space-2", position = { 0, trial_position } } })
			y_position = trial_position
		end
	end

	local e = surface.create_entity({
		name = chosen_name,
		position = { x = x, y = y_position },
	})

	if e and e.valid then
		storage.cerys.asteroids[#storage.cerys.asteroids + 1] = e
	end
end

function Public.spawn_solar_wind_particle(surface)
	local d = common.CERYS_RADIUS / lib.get_cerys_surface_stretch_factor(surface)

	local y = math.random(-d - 8, d + 8)

	local semimajor_axis = lib.get_cerys_semimajor_axis(surface)
	local x = -(semimajor_axis + WIND_SPAWN_DISTANCE_FROM_EDGE - math.random(0, 10))

	local r = rendering.draw_sprite({
		sprite = "cerys-solar-wind-particle",
		target = { x = x, y = y },
		surface = surface,
		render_layer = "air-object",
	})

	table.insert(storage.cerys.solar_wind_particles, {
		rendering = r,
		age = 0,
		velocity = Public.initial_solar_wind_velocity(),
		position = { x = x, y = y },
	})
end

function Public.initial_solar_wind_velocity()
	local x_velocity = MIN_INITIAL_VELOCITY + math.random() * 0.1 / 3 * spd
	local y_velocity = 0.2 * (math.random() - 0.5) ^ 3 * spd

	return { x = x_velocity, y = y_velocity }
end

Public.SOLAR_WIND_DEFLECTION_TICK_INTERVAL = 6

function Public.tick_solar_wind_deflection()
	local particles = storage.cerys.solar_wind_particles
	local rods = storage.cerys.charging_rods
	local rod_is_positive = storage.cerys.charging_rod_is_positive
	local deflection_tick_interval = Public.SOLAR_WIND_DEFLECTION_TICK_INTERVAL

	for rod_unit_number, rod in pairs(rods) do
		local p_rod = rod.rod_position

		for i = 1, #particles do
			local particle = particles[i]
			local p_particle = particle.position

			if
				not (
					p_particle.x - p_rod.x > ROD_MAX_RANGE
					or p_rod.x - p_particle.x > ROD_MAX_RANGE
					or p_particle.y - p_rod.y > ROD_MAX_RANGE
					or p_rod.y - p_particle.y > ROD_MAX_RANGE
				)
			then
				local dx = p_particle.x - p_rod.x
				local dy = p_particle.y - p_rod.y
				local d2 = dx * dx + dy * dy

				-- Bound the minimum distance
				if d2 == 0 then
					local random_angle = math.random() * 2 * math.pi
					dx = MIN_ELECTROMAGNETIC_INTERACTION_DISTANCE * math.cos(random_angle)
					dy = MIN_ELECTROMAGNETIC_INTERACTION_DISTANCE * math.sin(random_angle)
					d2 = dx * dx + dy * dy
				elseif d2 < MIN_ELECTROMAGNETIC_INTERACTION_DISTANCE * MIN_ELECTROMAGNETIC_INTERACTION_DISTANCE then
					local scale = MIN_ELECTROMAGNETIC_INTERACTION_DISTANCE / math.sqrt(d2)
					dx = dx * scale
					dy = dy * scale
					d2 = dx * dx + dy * dy
				end

				if d2 < ROD_MAX_RANGE_SQUARED then
					local polarity_fraction
					if particle.is_ghost then
						polarity_fraction = (rod_is_positive[rod_unit_number] and 1 or -1)
							* (rod.max_polarity_fraction or 1)
					else
						polarity_fraction = rod.polarity_fraction
					end

					if polarity_fraction and polarity_fraction ~= 0 then
						local deflection = polarity_fraction * ROD_DEFLECTION_STRENGTH * deflection_tick_interval / 60

						local dvx = dx / (d2 ^ (7 / 4)) * deflection
						local dvy = dy / (d2 ^ (7 / 4)) * deflection

						local v = particle.velocity

						if particle.marked_for_death_tick then
							dvx = dvx / 3
							dvy = dvy / 3
						end

						v.x = v.x + dvx
						v.y = v.y + dvy

						particle.velocity = v
					end
				end
			end
		end
	end
end

function Public.tick_1_move_solar_wind()
	local i = 1
	while i <= #storage.cerys.solar_wind_particles do
		local particle = storage.cerys.solar_wind_particles[i]
		local r = particle.rendering
		local v = particle.velocity

		if r and r.valid then
			local p = { x = particle.position.x + v.x, y = particle.position.y + v.y }
			particle.position = p
			r.target = p
			particle.age = particle.age + 1

			if particle.marked_for_death_tick then
				local ticks_until_death = PARTICLE_SHRINK_TIME - (game.tick - particle.marked_for_death_tick)

				if ticks_until_death < 0 then
					if particle.rendering and particle.rendering.valid then
						particle.rendering.destroy()
					end
					table.remove(storage.cerys.solar_wind_particles, i)
				else
					if particle.rendering and particle.rendering.valid then
						local scale_factor = math.max(0.00001, ticks_until_death / PARTICLE_SHRINK_TIME) ^ (1 / 2)
						particle.rendering.x_scale = scale_factor
						particle.rendering.y_scale = scale_factor
					end
				end
			end

			i = i + 1
		else
			table.remove(storage.cerys.solar_wind_particles, i)
		end
	end
end

local deepfreeze_factor = common.PARTICLE_NOBODY_LOOKING_SLOWDOWN_FACTOR
function Public.tick_5_solar_wind_destroy_check(surface)
	local i = 1
	while i <= #storage.cerys.solar_wind_particles do
		local particle = storage.cerys.solar_wind_particles[i]
		local v = particle.velocity

		local speed_squared = v.x * v.x + v.y * v.y

		if speed_squared < MIN_SPEED_THRESHOLD_SQUARED then
			if not particle.marked_for_death_tick then
				particle.marked_for_death_tick = game.tick
			end
		elseif particle.is_ghost and not particle.survived_first_check then
			local player_looking_at_surface = false

			for _, player in pairs(game.connected_players) do
				if player.surface == surface then
					player_looking_at_surface = true
				end
			end

			if player_looking_at_surface then
				particle.survived_first_check = true
			else
				if math.random() < 1 / deepfreeze_factor then
					particle.survived_first_check = true
				else
					particle.marked_for_death_tick = 0
				end
			end
		end

		i = i + 1
	end
end

function Public.tick_240_clean_up_cerys_solar_wind_particles(surface)
	local stretch_factor = lib.get_cerys_surface_stretch_factor(surface)
	local radius = common.CERYS_RADIUS
	local semimajor_axis = radius * stretch_factor
	local semiminor_axis = radius / stretch_factor

	local i = 1
	while i <= #storage.cerys.solar_wind_particles do
		local particle = storage.cerys.solar_wind_particles[i]

		local kill = false
		if particle.age > MAX_AGE then
			kill = true
		else
			if particle.is_ghost then
				if
					particle.position.x > (semimajor_axis + 20)
					or particle.position.x < (-semimajor_axis - 20)
					or particle.position.y > (semiminor_axis + 20)
					or particle.position.y < (-semiminor_axis - 20)
				then
					kill = true
				end
			else
				if
					particle.position.x > (semimajor_axis + WIND_SPAWN_DISTANCE_FROM_EDGE + 5)
					or particle.position.x < (-semimajor_axis - WIND_SPAWN_DISTANCE_FROM_EDGE - 5)
					or particle.position.y > (semiminor_axis + WIND_SPAWN_DISTANCE_FROM_EDGE + 5)
					or particle.position.y < (-semiminor_axis - WIND_SPAWN_DISTANCE_FROM_EDGE - 5)
				then
					kill = true
				end
			end
		end

		if kill then
			if particle.rendering and particle.rendering.valid then
				particle.rendering.destroy()
			end

			table.remove(storage.cerys.solar_wind_particles, i)
		else
			i = i + 1
		end
	end
end

function Public.tick_240_clean_up_cerys_asteroids(surface)
	local i = 1
	while i <= #storage.cerys.asteroids do
		local e = storage.cerys.asteroids[i]

		if e and e.valid then
			local semimajor_axis = lib.get_cerys_semimajor_axis(surface)

			if e.position.y > (semimajor_axis + ASTEROID_SPAWN_DISTANCE_FROM_EDGE + 5) then
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

local CHANCE_CHECK_BELT = 1 -- now that we have audiovisual effects, this needs to be 1
function Public.tick_8_solar_wind_collisions(surface, probability_multiplier)
	local particles = storage.cerys.solar_wind_particles

	for i = 1, #particles do
		local particle = particles[i]

		if not particle.is_ghost then
			local chars =
				surface.find_entities_filtered({ name = "character", position = particle.position, radius = 1.2 })
			if #chars > 0 then
				local e = chars[1]
				if e and e.valid then
					local check = not (particle.last_checked_inv and particle.last_checked_inv == e.unit_number)

					if check then
						particle.last_checked_inv = e.unit_number

						local inv = e.get_main_inventory()
						if inv and inv.valid then
							local irradiated = Public.irradiate_inventory(
								surface,
								inv,
								e.force,
								e.position,
								probability_multiplier,
								true
							)
							if irradiated then
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
									volume_modifier = 0.25,
								})
							end

							local damage = (
								settings.startup["cerys-high-damage-mode"]
								and settings.startup["cerys-high-damage-mode"].value
							) -- Setting stored in Cerys Start mod
									and 80
								or 5

							e.damage(damage, game.forces.neutral, "impact")
						end
					end
				end
			end

			local containers = surface.find_entities_filtered({
				type = { "container", "logistic-container" },
				position = particle.position,
				radius = 3,
				-- has_item_inside = "uranium-238", -- this would only catch normal quality
			})

			if #containers > 0 then
				local e = containers[1]
				if e and e.valid then
					local check = not (particle.last_checked_inv and particle.last_checked_inv == e.unit_number)
						and e.name ~= "cerys-fulgoran-radiative-tower-contracted-container"
						and e.has_items_inside()

					if check then
						local p = e.position
						local prototype_collision_box = e.prototype.collision_box

						local is_inside = particle.position.x > p.x + prototype_collision_box.left_top.x - 0.1
							and particle.position.x < p.x + prototype_collision_box.right_bottom.x + 0.1
							and particle.position.y > p.y + prototype_collision_box.left_top.y - 0.1
							and particle.position.y < p.y + prototype_collision_box.right_bottom.y + 0.1
						if is_inside then
							particle.last_checked_inv = e.unit_number

							local inv = e.get_inventory(defines.inventory.chest)
							if inv and inv.valid then
								local irradiated = Public.irradiate_inventory(
									surface,
									inv,
									e.force,
									e.position,
									probability_multiplier
								)
								if irradiated then
									surface.create_entity({
										name = "plutonium-explosion",
										position = e.position,
									})
								end
							end
						end
					end
				end
			end

			-- Note: Uranium on belts is more susceptible to slower wind. This is acceptable for now on a flavor basis of neutron capture.
			if CHANCE_CHECK_BELT >= 1 or (math.random() < CHANCE_CHECK_BELT) then
				local belts = surface.find_entities_filtered({
					type = "transport-belt",
					position = particle.position,
					radius = 0.5,
				})
				if #belts > 0 then
					local e = belts[1]
					if e and e.valid then
						local lines = {
							e.get_transport_line(1),
							e.get_transport_line(2),
						}

						local has_uranium = false
						for _, line in pairs(lines) do
							local contents = line.get_detailed_contents()

							for _, item in pairs(contents) do
								if item.stack.name == "uranium-238" then
									has_uranium = true

									local productivity_modifier = storage.plutonium_productivity_modifier or 1.0
									local increase = (CHANCE_MUTATE_BELT_URANIUM / CHANCE_CHECK_BELT)
										* probability_multiplier
										* settings.global["cerys-plutonium-generation-rate-multiplier"].value
										* productivity_modifier

									storage.accrued_probability_units = (storage.accrued_probability_units or 0)
										+ increase

									local mutate = storage.accrued_probability_units > 1

									if mutate then
										storage.accrued_probability_units = storage.accrued_probability_units - 1

										item.stack.set_stack({
											name = "plutonium-239",
											count = item.stack.count,
											quality = item.stack.quality,
										})

										if e.force and e.force.valid then
											e.force
												.get_item_production_statistics(surface)
												.on_flow("plutonium-239", item.stack.count)
											e.force
												.get_item_production_statistics(surface)
												.on_flow("uranium-238", -item.stack.count)
										end

										surface.create_entity({
											name = "plutonium-explosion",
											position = e.position,
										})
									end

									break
								end
							end
						end

						if has_uranium then
							Public.irradiation_chance_effect(surface, e.position)
						end
					end
				end
			end
		end
	end
end

function Public.irradiation_chance_effect(surface, position)
	surface.play_sound({
		path = "cerys-radiation-exposure",
		position = position,
		volume_modifier = 0.12,
	})

	for _ = 1, 8 do
		surface.create_particle({
			name = "solar-wind-exposure-particle",
			position = {
				x = position.x + (math.random() - 0.5),
				y = position.y + (math.random() - 0.5),
			},
			movement = {
				(math.random() - 0.5) * 0.3,
				(math.random() - 0.5) * 0.3,
			},
			height = 0.3,
			vertical_speed = 0.03,
			frame_speed = 1,
		})
	end
end

function Public.irradiate_inventory(surface, inv, force, position, probability_multiplier, no_effect)
	local uranium_count = 0
	local mutated = false
	for _, quality in pairs(prototypes.quality) do
		local name = quality.name
		local count = inv.get_item_count({ name = "uranium-238", quality = name })
		if count and count > 0 then
			uranium_count = uranium_count + count

			-- Throw in some rng to cause double and triple transitions:
			local random_increase = 1
			local rng = math.random()
			if rng < 0.01 then
				random_increase = 6
			elseif rng < 0.06 then
				random_increase = 3
			elseif rng > 0.85 then
				random_increase = 0.5
			end

			local productivity_modifier = storage.plutonium_productivity_modifier or 1.0

			local increase = count
				* CHANCE_MUTATE_INVENTORY_URANIUM
				* random_increase
				* probability_multiplier
				* settings.global["cerys-plutonium-generation-rate-multiplier"].value
				* productivity_modifier

			storage.accrued_probability_units = (storage.accrued_probability_units or 0) + increase

			local number_mutated = storage.accrued_probability_units - (storage.accrued_probability_units % 1)

			if number_mutated > 0 then
				storage.accrued_probability_units = storage.accrued_probability_units - number_mutated

				local removed = inv.remove({ name = "uranium-238", count = 100, quality = name })
				inv.insert({ name = "plutonium-239", count = number_mutated, quality = name })
				if removed > number_mutated then
					inv.insert({ name = "uranium-238", count = removed - number_mutated, quality = name })
				end

				if force and force.valid then
					force.get_item_production_statistics(surface).on_flow("plutonium-239", number_mutated)
					force.get_item_production_statistics(surface).on_flow("uranium-238", -number_mutated)
				end

				mutated = true
			end
		end
	end

	local effect_count = math.ceil(uranium_count / 1000)

	if not no_effect then
		for _ = 1, effect_count do
			Public.irradiation_chance_effect(surface, position)
		end
	end

	return mutated
end

local function asteroids_to_drops()
	local scale = math.floor(math.max(math.min(game.difficulty_settings.technology_price_multiplier, 20), 1))

	-- if script.active_mods["Krastorio2-spaced-out"] or script.active_mods["Krastorio2"] then
	-- 	scale = scale * 2
	-- end

	return {
		["small-metallic-asteroid-planetary"] = { ["metallic-asteroid-chunk"] = scale },
		["small-carbonic-asteroid-planetary"] = { ["carbonic-asteroid-chunk"] = scale },
		["small-oxide-asteroid-planetary"] = { ["oxide-asteroid-chunk"] = scale },
		["small-cupric-asteroid-planetary"] = { ["cupric-asteroid-chunk"] = scale },
	}
end

script.on_event(defines.events.on_entity_died, function(event)
	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	local surface = entity.surface

	if not (surface and surface.valid and surface.name == "cerys") then
		return
	end

	local drop_info = asteroids_to_drops()[entity.name]
	if not drop_info then
		return
	end

	local drop_name, drop_count = next(drop_info)

	local force = event.force

	if not (force and force.valid) then
		return
	end

	for _ = 1, drop_count do
		local belts = surface.find_entities_filtered({ type = "transport-belt", position = entity.position })

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
				if settings.global["cerys-mark-chunks-to-be-looted"].value then
					e.to_be_looted = true
				end

				if settings.global["cerys-mark-chunks-for-deconstruction"].value then
					e.order_deconstruction(force)
				end

				storage.cerys.ground_chunks = storage.cerys.ground_chunks or {}

				local i = 1
				while i <= #storage.cerys.ground_chunks do
					local chunk = storage.cerys.ground_chunks[i]
					if not (chunk and chunk.valid) then
						table.remove(storage.cerys.ground_chunks, i)
					else
						i = i + 1
					end
				end

				storage.cerys.ground_chunks[#storage.cerys.ground_chunks + 1] = e

				while #storage.cerys.ground_chunks > MAX_CHUNKS_ON_GROUND do
					local oldest = table.remove(storage.cerys.ground_chunks, 1)
					if oldest and oldest.valid then
						oldest.destroy()
					end
				end
			end
		end
	end
end)

return Public
