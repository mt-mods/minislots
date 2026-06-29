exclude_files = {".luacheckrc"}

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