 
-- Golden 7's Deluxe example machine
--
-- By Vanessa "VanessaE" Dannenberg
--
-- Most symbol images taken from clker.com
-- others drawn or rendered by me.

minislots.register_machine({
	name = "golden7s_deluxe",
	description = "Golden 7's Deluxe slot machine",
	machine_shape = "standard",
	lines = {           -- reel symbol pay line positions: 0 = center, -1 = top, +1 = bottom
		{  0,  0,  0,  0,  0 }, -- pay line 1: center symbol on each reel
		{ -1, -1, -1, -1, -1 }, -- 2: top symbol on each reel
		{  1,  1,  1,  1,  1 }, -- 3: bottom symbol on each reel
		{ -1, -1,  0,  1,  1 }, -- 4: top of reels 1 and 2, center of 3, bottom of 4 and 5
		{  1,  1,  0, -1, -1 }, -- 5: bottom of reels 1, 2, center 3, top 4, 5
		{ -1, -1, -1,  0,  1 }, -- 6: top of 1, 2, 3, center 4, bottom 5
		{  1,  1,  1,  0, -1 }, -- 7: bottom of 1, 2, 3, center 4, top 5
		{ -1,  0,  1,  1,  1 }, -- 8: top of 1, center 2, bottom 3, 4, 5
		{  1,  0, -1, -1, -1 }, -- 9: bottom of 1, center 2, top 3, 4, 5
		{  1,  0, -1,  0,  1 }, -- 10: bottom 1, center 2, top 3, center 4, bottom 5
		{ -1,  0,  1,  0, -1 }, -- 11: top 1, center 2, bottom 3, center 4, top 5
		{  0, -1, -1, -1, -1 }, -- 12: center 1, top 2, 3, 4, 5
		{  0,  1,  1,  1,  1 }, -- 13: center 1, bottom 2, 3, 4, 5
		{ -1, -1, -1, -1,  0 }, -- 14: top 1, 2, 3, 4, center 5
		{  1,  1,  1,  1,  0 }, -- 15: bottom 1, 2, 3, 4, center 5
	},
	symbols = {
		"bar",
		"lemon",
		"77",
		"cherry",
		"jackpot",
		"melon",
		"2bar",
		"lemon",
		"wild",
		"7",
		"bell",
		"scatter",
		"3bar",
		"777",
		"melon",
		"bonus"
	},
	linebuttons = { -- number of lines on each button, from left to right
		1,
		3,
		5,
		9,
		15
	},
	betbuttons = { -- line bet amount on each button, from left to right
		1,
		2,
		5,
		10,
		25
	},
	matches = { -- nil == don't care about that reel in a given match
		{   1, "lemon"   ,  "lemon"   ,  nil       ,   nil      ,  nil       },
		{   2, "lemon"   ,  "lemon"   ,  "lemon"   ,   nil      ,  nil       },
		{   3, "lemon"   ,  "lemon"   ,  "lemon"   ,   "lemon"  ,  nil       },
		{   5, "lemon"   ,  "lemon"   ,  "lemon"   ,   "lemon"  ,  "lemon"   },

		{   5, "melon"   ,  "melon"   ,  "melon"   ,   nil      ,  nil       },
		{   6, "melon"   ,  "melon"   ,  "melon"   ,   "melon"  ,  nil       },
		{   7, "melon"   ,  "melon"   ,  "melon"   ,   "melon"  ,  "melon"   },

		{   7, "cherry"  ,  "cherry"  ,  nil       ,  nil       ,  nil       },
		{   8, "cherry"  ,  "cherry"  ,  "cherry"  ,  nil       ,  nil       },
		{   9, "cherry"  ,  "cherry"  ,  "cherry"  ,  "cherry"  ,  nil       },
		{  10, "cherry"  ,  "cherry"  ,  "cherry"  ,  "cherry"  ,  "cherry"  },

		{  10, "bell"    ,  "bell"    ,  "bell"    ,  nil       ,  nil       },
		{  15, "bell"    ,  "bell"    ,  "bell"    ,  "bell"    ,  nil       },
		{  20, "bell"    ,  "bell"    ,  "bell"    ,  "bell"    ,  "bell"    },

		{  30, "bar"     ,  "bar"     ,  "bar"     ,  nil       ,  nil       },
		{  35, "bar"     ,  "bar"     ,  "bar"     ,  "bar"     ,  nil       },
		{  40, "bar"     ,  "bar"     ,  "bar"     ,  "bar"     ,  "bar"     },

		{  50, "2bar"    ,  "2bar"    ,  "2bar"    ,  nil       ,  nil       },
		{  55, "2bar"    ,  "2bar"    ,  "2bar"    ,  "2bar"    ,  nil       },
		{  60, "2bar"    ,  "2bar"    ,  "2bar"    ,  "2bar"    ,  "2bar"    },

		{  70, "3bar"    ,  "3bar"    ,  "3bar"    ,  nil       ,  nil       },
		{  75, "3bar"    ,  "3bar"    ,  "3bar"    ,  "3bar"    ,  nil       },
		{  80, "3bar"    ,  "3bar"    ,  "3bar"    ,  "3bar"    ,  "3bar"    },

		{  80, "7"       ,  "7"       ,  "7"       ,  nil       ,  nil       },
		{  85, "7"       ,  "7"       ,  "7"       ,  "7"       ,  nil       },
		{  90, "7"       ,  "7"       ,  "7"       ,  "7"       ,  "7"       },

		{  90, "77"      ,  "77"      ,  "77"      ,  nil       ,  nil       },
		{  95, "77"      ,  "77"      ,  "77"      ,  "77"      ,  nil       },
		{ 100, "77"      ,  "77"      ,  "77"      ,  "77"      ,  "77"      },

		{ 100, "777"     ,  "777"     ,  "777"     ,  nil       ,  nil       },
		{ 125, "777"     ,  "777"     ,  "777"     ,  "777"     ,  nil       },

		{ 150, "777"     ,  "777"     ,  "777"     ,  "777"     ,  "777"     },

		{ 300, "jackpot" ,  "jackpot" ,  "jackpot" , "jackpot"  ,  "jackpot" },

	},
	maxbalance = 3260000,			-- 65535 50 Mg notes, minus maximum possible payout, minus a fudge amount
	bet_initiates_spin = true,		-- Most machines initiate a spin when the user presses a "Bet n" button, using
									-- the selected bet value.

									-- timings should be an even multiple of the step interval (usually 0.1s)
	reel_fast_timeout = 0.2,		-- time between "frames" while spinning fast, medium speed, or slow
	reel_medium_timeout = 0.1,
	reel_slow_timeout = 0.1,
	win_delay = 0.5,				-- time to wait after reels stop before showing winning lines
	line_timeout = 1,				-- time to wait between cycling among winning lines
	inter_reel_steps = 3,			-- number of "frames" between stopping reels (using slow timeout)
	half_stops_weight = 5,			-- likelihood that a reel will stop between symbols, max 100 (if you want to
									-- disable that behavior and always land on a symbol, set this to 1).
	min_scatter = 3,				-- minimum number of scatter symbols needed before computing a scatter win
	scatter_value = 3,				-- value of the scatter symbol, will be multiplied by number visible * line bet
	min_bonus = 4,					-- minimum number of symbols needed to trigger the bonus round
	initiate_bonus = function(spin, def)
		print("[minislots] Bonus round triggered.")
		return 400
	end,
	geometry = {							-- all measures are in Minetest formspec "inventory slots" units

		base_user_interface_width = 14.667,	-- width of the user interface
		upper_section_height = 11,			-- height of the upper section (the reels et. al)
		lower_section_height = 2,			-- height of lower section (screen, buttons)

		reel_sizex = 2,						-- Nominal X/Y size of one reel.  Note that reels are drawn with a
		reel_sizey = 9,						-- spacing of 1.3333 times their width (creates a 1 IU gap in this
											-- machine), centered and leaving a 1 IU space at the far left/right.

		button_rows_posx = 6.9,				-- X starting pos for "n Lines"/"Bet n" buttons, Y pos for Spin button
		spin_cashout_posx = 12.75,			-- X pos for Spin and Cash-out/Quit buttons
		button_rows_posy = 11.14,			-- Y pos for "n Lines" row, and Cash Out/Quit button

		main_button_size = 0.8,				-- X/Y size of Lines/Bet buttons; X*2 x Y for Spin and Cash Out
		main_button_spacing = 0.9,			-- X/Y Spacing between Lines/Bet buttons, and between Spin and
											-- Cash Out buttons

		screen_posx = 0.125,				-- X/Y position of top-left corner of lower screen (i.e. (0,0))
		screen_posy = 11.094,

		screen_line_height = 0.875,			-- Height of line 1, and 2 in 2-line mode.  In 3-line mode, line 2
											-- hight will be 2/3 of this, and line 3 height will be 1/3 of it.

		label_medium_sizex = 1.125,			-- X size of "Bal:", "Bet:", "Win:".
		line_win_label_sizex = 2.0,			-- X size of "Line Win" label
		scatter_win_label_sizex = 3.0,		-- X size of "Scatter Win:" label
		bonus_win_label_sizex = 2.75,		-- X size of "Bonus Win:" label

		digit_glyph_sizex = 0.75,			-- Nominal X size of digits, before scaling down as noted below

		cash_slot_sizex = 5.0,				-- X/Y size and position of the cash slot
		cash_slot_sizey = 0.8125,
		cash_slot_posx = 9.5781,
		cash_slot_posy = 10.0938,
		cash_slot_cin_posx = 1.9,			-- X/Y position within the "cash intake" form (uses the same size as
		cash_slot_cin_posy = 2.27			-- above)
	}
})
