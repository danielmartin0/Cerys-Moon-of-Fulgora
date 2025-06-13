if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

local common = require("common")
local radiative_towers = require("scripts.radiative-tower")

if storage.radiative_towers and storage.radiative_towers.towers then
	for r = 1, common.LAMP_COUNT do
		local existing_lamps = surface.find_entities_filtered({ name = "radiative-tower-lamp-" .. r })
		for _, lamp in pairs(existing_lamps) do
			lamp.destroy()
		end
	end

	for _, tower in pairs(storage.radiative_towers.towers) do
		local e = tower.entity

		if e and e.valid then
			local temperature_above_zero = e.temperature - radiative_towers.TEMPERATURE_ZERO
			local heating_radius = radiative_towers.heating_radius_from_temperature_above_zero(temperature_above_zero)

			for _, lamp in pairs(tower.lamps or {}) do
				if lamp and lamp.valid then
					lamp.destroy()
				end
			end
			tower.lamps = nil

			if heating_radius > 0 then
				local new_lamp = e.surface.create_entity({
					name = "radiative-tower-lamp-" .. heating_radius,
					position = e.position,
					force = e.force,
				})
				new_lamp.destructible = false
				new_lamp.minable_flag = false
				tower.current_lamp = new_lamp
			end
		end
	end
end

if surface.map_gen_settings.height < common.CERYS_RADIUS * 1.5 then
	game.print(
		"[CERYS]: Deleting ribbonworld Cerys that was created prior to Cerys v1.4.17. (Ribbonworld support was added in this version.)",
		{ color = common.WARN_COLOR }
	)
	game.delete_surface("cerys")
end
