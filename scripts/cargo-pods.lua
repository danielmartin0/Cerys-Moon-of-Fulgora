local Public = {}

local warn_color = { r = 255, g = 90, b = 54 }

function Public.tick_10_check_cargo_pods()
	if not storage.cerys_cargo_pods_seen_on_platforms then
		storage.cerys_cargo_pods_seen_on_platforms = {}
	end
	if not storage.cerys_cargo_pod_canceled_whisper_ticks then
		storage.cerys_cargo_pod_canceled_whisper_ticks = {}
	end

	for _, force in pairs(game.forces) do
		for _, platform in pairs(force.platforms) do
			if platform and platform.valid and platform.surface and platform.surface.valid then
				local planet_name = nil
				if platform.space_location and platform.space_location.valid and platform.space_location.name then
					planet_name = platform.space_location.name
				end

				local tech_unlocked = force.technologies["cerys-cargo-drops"].researched

				if planet_name == "cerys" and not tech_unlocked then
					local cargo_pods = platform.surface.find_entities_filtered({ type = "cargo-pod" })

					for _, pod in pairs(cargo_pods) do
						if pod and pod.valid and not storage.cerys_cargo_pods_seen_on_platforms[pod.unit_number] then
							local pod_contents = pod.get_inventory(defines.inventory.cargo_unit).get_contents()

							local only_construction_robots_or_players = true

							for _, item in pairs(pod_contents) do
								if item.name ~= "construction-robot" then
									only_construction_robots_or_players = false
								end
							end

							local nearby_hubs = platform.surface.find_entities_filtered({
								name = { "space-platform-hub", "cargo-bay" },
								position = pod.position,
								radius = 4,
							})

							local launched_from_platform = #nearby_hubs > 0

							storage.cerys_cargo_pods_seen_on_platforms[pod.unit_number] = {
								launched_from_platform = launched_from_platform,
								entity = pod,
								platform_index = platform.index,
							}

							if launched_from_platform and not only_construction_robots_or_players then
								Public.destroy_pod_on_platform(pod, platform)
							end
						end
					end
				end
			end
		end
	end
end

function Public.destroy_pod_on_platform(pod, platform)
	local hub = platform.hub
	if hub and hub.valid then
		local pod_inventory = pod.get_inventory(defines.inventory.cargo_unit)
		local hub_inventory = hub.get_inventory(defines.inventory.hub_main)

		if pod_inventory and hub_inventory then
			for _, item in pairs(pod_inventory.get_contents()) do
				hub_inventory.insert(item)
			end
		end
	end

	for _, player in pairs(game.connected_players) do
		if
			player.valid
			and player.surface
			and player.surface.valid
			and player.surface.index == platform.surface.index
		then
			local whisper_hash = platform.index .. "-" .. player.name

			local last_whisper_tick = storage.cerys_cargo_pod_canceled_whisper_ticks[whisper_hash]

			if (not last_whisper_tick) or (game.tick - last_whisper_tick >= 60 * 10) then
				player.print({
					"cerys.cargo-pod-canceled",
					"[space-platform=" .. platform.index .. "]",
					"[technology=cerys-cargo-drops]",
				}, { color = warn_color })

				storage.cerys_cargo_pod_canceled_whisper_ticks[whisper_hash] = game.tick
			end
		end
	end

	local pod_unit_number = pod.unit_number

	pod.destroy()

	storage.cerys_cargo_pods_seen_on_platforms[pod_unit_number] = nil
end

return Public
