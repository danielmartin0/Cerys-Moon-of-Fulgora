if not storage.cerys then
	return
end

local surface = game.surfaces["cerys"]
if not surface or not surface.valid then
	return
end

storage.cerys.ground_chunks = {}
local ground_chunks = surface.find_entities_filtered({ name = "item-on-ground" })

for _, entity in pairs(ground_chunks) do
	if entity and entity.valid and entity.stack and entity.stack.name then
		if
			entity.stack.name == "metallic-asteroid-chunk"
			or entity.stack.name == "carbonic-asteroid-chunk"
			or entity.stack.name == "oxide-asteroid-chunk"
		then
			if #storage.cerys.ground_chunks < 15 then
				storage.cerys.ground_chunks[#storage.cerys.ground_chunks + 1] = entity
			else
				entity.destroy()
			end
		end
	end
end
