--[[

	TechAge
	=======

	Copyright (C) 2019 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information
	
	TA2 Steam pipes for the Steam Engine

]]--

-- for lazy programmers
local S = function(pos) if pos then return minetest.pos_to_string(pos) end end
local P = minetest.string_to_pos
local M = minetest.get_meta

-- Load support for intllib.
local MP = minetest.get_modpath("tubelib2")
local I,_ = dofile(MP.."/intllib.lua")


local Pipe = tubelib2.Tube:new({
	dirs_to_check = {1,2,3,4,5,6},
	max_tube_length = 6, 
	show_infotext = false,
	primary_node_names = {"techage:steam_pipeS", "techage:steam_pipeA"}, 
	secondary_node_names = {"techage:cylinder", "techage:cylinder_on", "techage:boiler2"},
	after_place_tube = function(pos, param2, tube_type, num_tubes)
		minetest.swap_node(pos, {name = "techage:steam_pipe"..tube_type, param2 = param2})
	end,
})

Pipe:register_on_tube_update(function(node, pos, out_dir, peer_pos, peer_in_dir)
	minetest.registered_nodes[node.name].after_tube_update(node, pos, out_dir, peer_pos, peer_in_dir)
end)

techage.SteamPipe = Pipe


minetest.register_node("techage:steam_pipeS", {
	description = I("TA2 Steam Pipe"),
	tiles = {
		"techage_steam_pipe.png^[transformR90",
		"techage_steam_pipe.png^[transformR90",
		"techage_steam_pipe.png",
		"techage_steam_pipe.png",
		"techage_steam_hole.png",
		"techage_steam_hole.png",
	},
	
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if not Pipe:after_place_tube(pos, placer, pointed_thing) then
			minetest.remove_node(pos)
			return true
		end
		return false
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		Pipe:after_dig_tube(pos, oldnode)
	end,
	
	paramtype2 = "facedir", -- important!
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-1/8, -1/8, -4/8,  1/8, 1/8, 4/8},
		},
	},
	on_rotate = screwdriver.disallow, -- important!
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {crumbly=3, cracky=3, snappy=3},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("techage:steam_pipeA", {
	description = I("TA2 Steam Pipe"),
	tiles = {
		"techage_steam_knee2.png",
		"techage_steam_hole2.png^[transformR180",
		"techage_steam_knee.png^[transformR270",
		"techage_steam_knee.png",
		"techage_steam_knee2.png",
		"techage_steam_hole2.png",
	},
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		Pipe:after_dig_tube(pos, oldnode)
	end,
	
	paramtype2 = "facedir", -- important!
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-1/8, -4/8, -1/8, 1/8, 1/8, 1/8},
			{-1/8, -1/8, -4/8, 1/8, 1/8, -1/8},
		},
	},
	on_rotate = screwdriver.disallow, -- important!
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {crumbly=3, cracky=3, snappy=3, not_in_creative_inventory=1},
	sounds = default.node_sound_metal_defaults(),
	drop = "techage:steam_pipeS",
})
