local common = require("common")
local cooling = require("scripts.cooling")
local lib = require("lib")

local surface = lib.generated_cerys_surface()
if not surface then
	return
end

if not storage.cerys then
	return
end

if not storage.cerys.heat_pipes then
	return
end

local old_heat_pipes = storage.cerys.heat_pipes
local new_heat_pipes = {}

for _, entity in pairs(old_heat_pipes) do
	if entity and entity.valid then
		table.insert(new_heat_pipes, entity)
	end
end

storage.cerys.heat_pipes = new_heat_pipes
