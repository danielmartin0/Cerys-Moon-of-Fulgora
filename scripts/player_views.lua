local Public = {}

--- Checks whether `target` would be visible in `player`'s viewport if that
--- viewport were centered on `center` at the given `zoom` level.
---@param player table   -- used for display_resolution/display_scale
---@param center MapPosition -- where the view is centered
---@param target MapPosition -- the position to test
---@return boolean
function Public.can_see_position(player_index, center, target)
    local player 
    if storage.players_cache[player_index] then
        player = storage.players_cache[player_index]
    else
        Public.do_player_view_changed{player_index=player_index}
        player = storage.players_cache[player_index]
    end
   
    if player.details_not_seen then
        return false
    end
    -- Factorio renders 32 pixels per tile at zoom = 1 and scale = 1.
    -- Visible world width/height (in tiles) = screen pixels / (32 * scale * zoom)
    --local half_width = player.half_width
    --local half_height = player.half_height

    local dx = target.x - center.x
    if dx > player.half_width or -dx > player.half_width then
        return false
    end
    local dy = target.y - center.y

    return not (dy > player.half_height) and not (-dy > player.half_height)
end

local screen_safety_factor = 5 --Factor of safety to pad "screen" by to prevent pop-in from particles
local screen_safety_factor_width = 10
function Public.do_player_view_changed(event) --Run when player view has changed
    local player = game.players[event.player_index]
    if true or not storage.players_cache[event.player_index] or storage.players_cache[event.player_index].tick + 2 < event.tick then
        storage.players_cache[event.player_index] = {
            display_resolution = player.display_resolution,
            display_scale = player.display_scale,
            zoom = player.zoom,
            looking_at_cerys = player.surface and player.surface.name == "cerys",
            tick = event.tick,
            zoom_limits = player.zoom_limits
	    }
        local cache = storage.players_cache[event.player_index]
        cache.half_width = screen_safety_factor_width + screen_safety_factor + cache.display_resolution.width / (cache.display_scale * 32 * cache.zoom) / 2
        cache.half_height = screen_safety_factor + cache.display_resolution.height / (cache.display_scale * 32 * cache.zoom) / 2
        cache.details_not_seen = cache.half_width>cache.zoom_limits.furthest_game_view.distance
        --print(serpent.block(cache))
    end
    storage.update_solar_wind_render = true
    
    
    
    
end






return Public
