local lib = require("lib")

local cerys_surface = lib.generated_cerys_surface()
local cerys_index = cerys_surface and cerys_surface.valid and cerys_surface.index or nil

if storage.cerys then
	storage.charging_rods = storage.charging_rods or storage.cerys.charging_rods or {}
	storage.charging_rod_is_positive = storage.charging_rod_is_positive
		or storage.cerys.charging_rod_is_positive
		or {}
	storage.rod_registrations = storage.rod_registrations or storage.cerys.rod_registrations or {}
	storage.solar_wind_particles = storage.solar_wind_particles or storage.cerys.solar_wind_particles or {}
	if storage.given_charging_rod_performance_warning == nil then
		storage.given_charging_rod_performance_warning = storage.cerys.given_charging_rod_performance_warning or false
	end
	storage.cerys.charging_rods = nil
	storage.cerys.charging_rod_is_positive = nil
	storage.cerys.rod_registrations = nil
	storage.cerys.solar_wind_particles = nil
	storage.cerys.off_cerys_state_count = nil
	storage.cerys.given_charging_rod_performance_warning = nil
else
	storage.charging_rods = storage.charging_rods or {}
	storage.charging_rod_is_positive = storage.charging_rod_is_positive or {}
	storage.rod_registrations = storage.rod_registrations or {}
	storage.solar_wind_particles = storage.solar_wind_particles or {}
	if storage.given_charging_rod_performance_warning == nil then
		storage.given_charging_rod_performance_warning = false
	end
end

local function surface_index_of_rod(rod)
	if rod.surface_index then
		return rod.surface_index
	end
	if rod.entity and rod.entity.valid and rod.entity.surface and rod.entity.surface.valid then
		return rod.entity.surface.index
	end
	return cerys_index
end

local function surface_index_of_particle(particle)
	if particle.surface_index then
		return particle.surface_index
	end
	if particle.rendering and particle.rendering.valid and particle.rendering.surface and particle.rendering.surface.valid then
		return particle.rendering.surface.index
	end
	return cerys_index
end

for unit_number, rod in pairs(storage.charging_rods) do
	local s_idx = surface_index_of_rod(rod)
	if cerys_index and s_idx and s_idx ~= cerys_index then
		if rod.entity and rod.entity.valid then
			rod.entity.destroy()
		end
		storage.charging_rods[unit_number] = nil
		storage.charging_rod_is_positive[unit_number] = nil
	else
		rod.surface_index = s_idx
	end
end

local i = 1
while i <= #storage.solar_wind_particles do
	local particle = storage.solar_wind_particles[i]
	local s_idx = surface_index_of_particle(particle)
	if cerys_index and s_idx and s_idx ~= cerys_index then
		if particle.rendering and particle.rendering.valid then
			particle.rendering.destroy()
		end
		table.remove(storage.solar_wind_particles, i)
	else
		particle.surface_index = s_idx
		i = i + 1
	end
end

storage.off_cerys_state_count = 0
