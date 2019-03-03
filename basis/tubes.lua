--[[

	TechAge
	=======

	Copyright (C) 2019 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information
	
	Tubes based on tubelib2

]]--



-- used for registered nodes
techage.KnownNodes = {
	["techage:tubeS"] = true,
	["techage:tubeA"] = true,
}


local Tube = tubelib2.Tube:new({
	                -- North, East, South, West, Down, Up
	dirs_to_check = {1,2,3,4,5,6},
	max_tube_length = 200, 
	show_infotext = false,
	primary_node_names = {"techage:tubeS", "techage:tubeA"}, 
	after_place_tube = function(pos, param2, tube_type, num_tubes, tbl)
		minetest.swap_node(pos, {name = "techage:tube"..tube_type, param2 = param2})
	end,
})

techage.Tube = Tube

minetest.register_node("techage:tubeS", {
	description = "TechAge Tube",
	tiles = { -- Top, base, right, left, front, back
		"techage_tube.png^[transformR90",
		"techage_tube.png^[transformR90",
		"techage_tube.png",
		"techage_tube.png",
		"techage_hole.png",
		"techage_hole.png",
	},
	
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if not Tube:after_place_tube(pos, placer, pointed_thing) then
			minetest.remove_node(pos)
			return true
		end
		return false
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		Tube:after_dig_tube(pos, oldnode, oldmetadata)
	end,
	
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-2/8, -2/8, -4/8,  2/8, 2/8, 4/8},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = { -1/4, -1/4, -1/2,  1/4, 1/4, 1/2 },
	},
	collision_box = {
		type = "fixed",
		fixed = { -1/4, -1/4, -1/2,  1/4, 1/4, 1/2 },
	},
	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {choppy=2, cracky=3, stone=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("techage:tubeA", {
	description = "TechAge Tube",
	tiles = { -- Top, base, right, left, front, back
		"techage_knee2.png",
		"techage_hole2.png^[transformR180",
		"techage_knee.png^[transformR270",
		"techage_knee.png",
		"techage_knee2.png",
		"techage_hole2.png",
	},
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		Tube:after_dig_tube(pos, oldnode, oldmetadata)
	end,
	
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-2/8, -4/8, -2/8,  2/8, 2/8,  2/8},
			{-2/8, -2/8, -4/8,  2/8, 2/8, -2/8},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = { -1/4, -1/2, -1/2,  1/4, 1/4, 1/4 },
	},
	collision_box = {
		type = "fixed",
		fixed = { -1/4, -1/2, -1/2,  1/4, 1/4, 1/4 },
	},
	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {choppy=2, cracky=3, stone=1, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "techage:tubeS",
})

minetest.register_craft({
	output = "techage:tubeS 4",
	recipe = {
		{"default:steel_ingot", "", "group:wood"},
		{"", "group:wood", ""},
		{"group:wood", "", "default:tin_ingot"},
	},
})