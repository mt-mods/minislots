--  Minislots game engine

minislots = {}

minislots.modpath = minetest.get_modpath(minetest.get_current_modname())
local machinelist = minetest.get_dir_list(minislots.modpath.."/machines", true)

dofile(minislots.modpath.."/engine.lua")
