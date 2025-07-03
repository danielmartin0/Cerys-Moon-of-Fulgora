local surface = game.surfaces["cerys"]
if not (surface and surface.valid) then
	return
end

surface.wind_speed = 0
surface.wind_orientation_change = 0
