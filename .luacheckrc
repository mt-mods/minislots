exclude_files = {".luacheckrc"}
max_line_length = 200

globals = {
	"minislots"
}

read_globals = {
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Luanti
	"minetest", "core",
	"ItemStack",

	-- MTG
	"creative", "default",
}