local merge = require("lib").merge

--== Find a suitable planet for Cerys to orbit if Fulgora is gone. ==--

if not data.raw.planet["fulgora"] or data.raw.planet["fulgora"].hidden then
	local new_planet = nil
	for _, planet in pairs(data.raw.planet) do
		if planet.lightning_properties and not planet.hidden then
			new_planet = planet.name
			log("[CERYS]: Fulgora does not exist, changing orbit to " .. new_planet)
			break
		end
	end
	if new_planet then
		PlanetsLib:update({
			type = "planet",
			name = "cerys",
			orbit = merge(data.raw.planet["cerys"].orbit, {
				parent = {
					type = "planet",
					name = new_planet,
				},
			}),
		})

		if data.raw["space-connection"]["fulgora-cerys"] then
			data:extend({
				merge(data.raw["space-connection"]["fulgora-cerys"], {
					name = new_planet .. "-cerys",
					subgroup = "planet-connections",
					from = new_planet,
					icons = {
						{
							icon = "__space-age__/graphics/icons/planet-route.png",
							icon_size = 64,
						},
						{
							icon = data.raw.planet[new_planet].icon,
							icon_size = data.raw.planet[new_planet].icon_size or 64,
							scale = 0.333 * (64 / (data.raw.planet[new_planet].icon_size or 64)),
							shift = { -6, -6 },
						},
						{
							icon = data.raw.planet["cerys"].icon,
							icon_size = data.raw.planet["cerys"].icon_size or 64,
							scale = 0.333 * (64 / (data.raw.planet["cerys"].icon_size or 64)),
							shift = { 6, 6 },
						},
					},
				}),
			})
			data.raw["space-connection"]["fulgora-cerys"] = nil
		end
	end
end
