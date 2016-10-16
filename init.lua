ranks = {}

local input, errstr = io.open(minetest.get_worldpath().."/ranks.dat", "r")
if input then
	ranks = minetest.deserialize(input:read("*a") or {})
	io.close(input)
else
	print("[rank] "..minetest.get_worldpath().."/ranks.dat failed to load! ("..errstr..")")
end

function color(hex)
	return core.get_color_escape_sequence(hex)
end

rank_colors = {
	wood = "#60311b",
	stone = "#7f7f7f",
	coal = "#2e2e2e",
	iron = "#baada3",
	copper = "#b64100",
	bronze = "#cd7f32",
	gold = "#ffd700",
	mese = "#a6a600",
	diamond = "#0096ff",
	obsidian = "#1a1a1a",
	air = "#c8e7ff",
	void = "#410041",
	admin = "#ff0000",
	moderator = "#0000ff"
}

minetest.register_privilege("rank", {description = "Can change ranks.", give_to_singleplayer = false})

minetest.register_chatcommand("rank", {
	description = "Set a player's rank",
	params = "<name> wood|stone|coal|iron|copper|gold|mese|diamond|obsidian|air|void|moderator|admin",
	privs = {server = true, rank = true},
	func = function(name, param)
		local target = param:split(' ')[1]
		local param = param:split(' ')[2]
		param = param:lower()
		if not param then return false, "Invalid Usage." end
		if param == "wood" or param == "stone" or param == "coal" or param == "iron" or param == "copper" or param == "gold" or param == "mese"
			or param == "diamond" or param == "obsidian" or param == "air" or param == "void" or param == "admin" or param == "moderator" or param == "bronze" then
			if minetest.get_player_by_name(target) then
				minetest.get_player_by_name(target):set_nametag_attributes({text = "                                          ["..color(rank_colors[param])..param..color("#ffffff").."]: "..target})
				ranks[target] = param
				minetest.chat_send_player(name, target.."'s rank has been changed to "..param..".")
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Rank: "..param))
		end
	end
})

minetest.register_on_joinplayer(function(player)
	minetest.after(0, function()
		local name = player:get_player_name()
		if ranks[name] and name ~= minetest.setting_get("name") then
			player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
		elseif name == minetest.setting_get("name") then
			player:set_nametag_attributes({text = "                                          ["..color(rank_colors["admin"]).."admin"..color("#ffffff").."]: "..name})
			ranks[name] = "admin"
		else
			ranks[name] = "wood"
			player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
		end
	end)
end)

minetest.register_on_shutdown(function()
	print("[rank] Shutting down. Saving ranks.")
	local stream, err = io.open(minetest.get_worldpath().."/ranks.dat", "w")
	if stream then
		stream:write(minetest.serialize(ranks))
		io.close(stream)
	else
		print("[rank] "..minetest.get_worldpath().."/ranks.dat failed to load! ("..err..")")
	end
end)

minetest.register_on_chat_message(function(name, message)
	if string.find(message, '/') and string.find(message, '/') == 1 then
		minetest.chat_send_all("<["..minetest.colorize(rank_colors[ranks[name]], ranks[name]).."] "..name.."> "..message)
	else
		return
	end
	return ""
end)

minetest.register_chatcommand("rankup", {
	description = "Increse your rank.",
	privs = {interact = true},
	params = "",
	func = function(name, param)
		local rank = ranks[name] or "wood"
		local player = minetest.get_player_by_name(name)
		local wielditem = player:get_wielded_item()
		if rank == "wood" then
			if wielditem:get_count() >= 40 and wielditem:get_name() == "default:stone" then
				wielditem:set_count(wielditem:get_count() - 25)
				player:set_wielded_item(wielditem)
				ranks[name] = "stone"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors.stone).."stone"..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 40 stone to upgrade."))
			end
		elseif rank == "stone" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:coalblock" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "coal"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 coal blocks to upgrade."))
			end
		elseif rank == "coal" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:steelblock" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "iron"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 iron blocks to upgrade."))
			end
		elseif rank == "iron" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:copperblock" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "copper"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 copper blocks to upgrade."))
			end
		elseif rank == "copper" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:bronzeblock" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "bronze"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 bronze blocks to upgrade."))
			end
		elseif rank == "bronze" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:goldblock" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "gold"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 bronze blocks to upgrade."))
			end
		elseif rank == "gold" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:mese" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "mese"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 mese blocks to upgrade."))
			end
		elseif rank == "mese" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:diamondblock" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "diamond"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 mese blocks to upgrade."))
			end
		elseif rank == "diamond" then
			if wielditem:get_count() >= 20 and wielditem:get_name() == "default:obsidian" then
				wielditem:set_count(wielditem:get_count() - 15)
				player:set_wielded_item(wielditem)
				ranks[name] = "obsidian"
				player:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
				minetest.chat_send_all("Congradulations "..name.." for upgrading to the "..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").." rank!")
			else
				minetest.chat_send_player(name, minetest.colorize("#ff0000", "ERROR: You need to hold 20 obsidian blocks to upgrade."))
			end
		elseif rank == "obsidian" then
			minetest.chat_send_player(name, "You can't upgrade any more unless you got a donor rank.")
		elseif rank == "air" or rank == "void" then
			minetest.chat_send_player(name, "You cannot upgarade a donor rank.")
		elseif rank == "moderator" then
			minetest.chat_send_player(name, "Ask the admin for an upgade, Not me.")
		elseif rank == "admin" then
			minetest.chat_send_player(name, "You are already an admin, what more do you want?")
		else
			minetest.chat_send_player(name, "You have an invalid rank.")
			minetest.kick_player(name, "You have an invalid rank. If you rejoin, this will be fixed.")
			if minetetest.setting_get("name") then minetest.chat_send_player(minetest.setting_get("name"), name.." has an invalid rank.") end
		end
	end
})
