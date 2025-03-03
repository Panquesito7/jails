--[[
Jails mod by ShadowNinja.
--]]

jails = {
	jails = {},
	filename = minetest.get_worldpath() .. "/jails.lua",
	default = 0,
	announce = minetest.settings:get_bool("jails.announce"),
	teleportDelay = tonumber(minetest.settings:get("jails.teleport_delay")) or 30,
}

local modPath = minetest.get_modpath(minetest.get_current_modname()) .. DIR_DELIM
dofile(modPath .. "api.lua")
dofile(modPath .. "commands.lua")

minetest.register_privilege("jailer", { 
	description = "Can jail players",
	give_to_singleplayer = false,
	give_to_admin = true,
})

local function keepInJail(player)
	local jailName, jail = jails:getJail(player:get_player_name())
	if jail then
		player:set_pos(jail.pos)
		return true -- Don't spawn normaly
	end
end

minetest.register_on_joinplayer(keepInJail)
minetest.register_on_respawnplayer(keepInJail)

local stepTime = 0
minetest.register_globalstep(function(dtime)
	stepTime = stepTime + dtime
	if stepTime < jails.teleportDelay then
		return
	end
	stepTime = 0
	for _, player in pairs(minetest.get_connected_players()) do
		keepInJail(player)
	end
end)

jails:load()
