 
-- Golden 7's example machine
--
-- By Vanessa "VanessaE" Dannenberg
--
-- Most symbol images taken from clker.com
-- others drawn or rendered by me.

minislots.register_machine({
	name = "golden7s",  -- becomes the node name e.g. "minislots:golden7s"
	description = "Golden 7's slot machine",
	machine_shape = "upright",
	lines = {           -- reel symbol pay line positions: 0 = center, -1 = top, +1 = bottom
		{  0,  0,  0 }, -- pay line 1: center symbol on each reel
		{ -1, -1, -1 }, -- pay line 2: top symbol on each reel
		{  1,  1,  1 }, -- pay line 3: bottom symbol on each reel
		{ -1,  0,  1 }, -- pay line 4: top of reel 1, center of 2, bottom of 3
		{  1,  0, -1 },
		{ -1, -1,  0 },
		{  1,  1,  0 },
		{  0, -1, -1 },
		{  0,  1,  1 }
	},
	symbols = {			-- must be in the same order as the symbols in the reel image
		"bar",			-- but ignore the first one and last two in the image, they're wrap-
		"lemon",		-- arounds/repeats and are handled specially.
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
		9        -- there's room for one more, if desired
	},
	betbuttons = { -- line bet amount on each button, from left to right
		1,
		2,
		5,
		10,
		25
	},
	matches = { -- nil == don't care about that reel in a given match
		{   1, "lemon"   ,  "lemon"   ,  "lemon"   },

		{   2, "melon"   ,  "melon"   ,  "melon"   },

		{   2, "cherry"  ,  "cherry"  ,  nil       },
		{   3, "cherry"  ,  "cherry"  ,  "cherry"  },

		{   5, "bell"    ,  "bell"    ,  nil       },
		{   6, "bell"    ,  "bell"    ,  "bell"    },

		{  10,
			{"bar", "2bar", "3bar"},
			{"bar", "2bar", "3bar"},
			{"bar", "2bar", "3bar"}
		},

		{  15, "bar"     ,  "bar"     ,  "bar"     },
		{  20, "2bar"    ,  "2bar"    ,  "2bar"    },
		{  25, "3bar"    ,  "3bar"    ,  "3bar"    },


		{  25,
			{"7", "77", "777"},
			{"7", "77", "777"},
			{"7", "77", "777"}
		},

		{  30, "7"       ,  "7"       ,  "7"       },
		{  45, "77"      ,  "77"      ,  "77"      },
		{  60, "777"     ,  "777"     ,  "777"     },

		{ 200, "jackpot" ,  "jackpot" ,  "jackpot" },

	},
	paytable_desc = {
		{ "@lemon", "@lemon", "@lemon", " pays 1" },
		{ "@melon", "@melon", "@melon", " pays 2" },
		{ "@cherry","@cherry", "@X", " pays 2" },
		{ "@cherry","@cherry", "@cherry", " pays 3" },
		{ "@bell","@bell", "@X", " pays 5" },
		{ "@bell","@bell", "@bell", " pays 6" },
		{ "Any three mixed ", "@bar", "/", "@2bar", "/", "@3bar", " pays 10" },
		{ "@bar", "@bar", "@bar", " pays 15" },
		{ "@2bar", "@2bar", "@2bar", " pays 20" },
		{ "@3bar", "@3bar", "@3bar", " pays 25" },
		{ "Any three mixed ", "@7", "/", "@77", "/", "@777", " pays 25" },
		{ "@7", "@7", "@7", " pays 30" },
		{ "@77", "@77", "@77", " pays 45" },
		{ "@777", "@777", "@777", " pays 60" },
		{ "@jackpot", "@jackpot", "@jackpot", " pays 200" },
		{ "@wild", " matches any symbol except ", "@scatter", " ", "@bonus", " or ", "@jackpot" },
		{ "All wins are multiplied by your line bet." }
	},
	paylines_desc = {
		"Paylines 1 - 3:",
		"@1 3",
		"Paylines 4 and 5:",
		"@4 5",
		"@wrap",
		"Paylines 6 and 7:",
		"@6 7",
		"Paylines 8 and 9:",
		"@8 9"
	},
	maxbalance = 3260000,			-- 65535 50 Mg notes, minus maximum possible payout, minus a fudge amount
	currency_min = 1,				-- smallest and largest denominations of minegeld to allow
	currency_max = 100,
	bet_initiates_spin = true,		-- Most machines initiate a spin when the user presses a "Bet n" button, using
									-- the selected bet value.

									-- timings should be an even multiple of the step interval (usually 0.1s)
	reel_fast_timeout = 0.2,		-- time between "frames" while spinning fast, medium speed, or slow
	reel_medium_timeout = 0.1,
	reel_slow_timeout = 0.1,
	cutover_frames = 5,				-- number of frames to run for each fast, medium, and slow cycle
	inter_reel_steps = 4,			-- number of frames between stopping reels (using slow timeout)

	win_delay = 0.5,				-- time to wait after reels stop before showing winning lines
	line_timeout = 1,				-- time to wait between cycling among winning lines
	half_stops_weight = 25,			-- likelihood that a reel will stop between symbols, max 100 (if you want to
									-- disable that behavior and always land on a symbol, set this to 1).
	min_scatter = 2,				-- minimum number of scatter symbols needed before computing a scatter win
	scatter_value = 3,				-- value of the scatter symbol, will be multiplied by number visible * line bet
	min_bonus = 3,					-- minimum number of symbols needed to trigger the bonus round
	initiate_bonus = function(spin, def)
		return 123
	end,
	wild_doesnt_match = {
		jackpot = true
	},
	wild_multiplier = 1,				-- For every wild that contributes to a line win, multiply win by this
										-- (so one wild mult. by this, two mult. by twice this, etc)

	geometry = {						-- all measures are in Minetest formspec "inventory slots" units
		base_user_interface_width = 13,	-- width of the user interface
		upper_section_height = 11,		-- height of the upper section (the reels et. al)
		lower_section_height = 2,		-- height of lower section (screen, buttons)

		reel_posx = 1,					-- X/Y position of first reel, others drawn as indicated below
		reel_posy = 1,

		reel_sizex = 3,					-- Nominal X/Y size of one reel.  Note that reels are drawn with a
		reel_sizey = 9,					-- spacing of 1.3333 times their width (creates a 1 IU gap in this
										-- machine).

		button_rows_posx = 6.25,		-- X starting pos for "n Lines"/"Bet n" buttons, Y pos for Spin button
		spin_cashout_posx = 11.25,		-- X pos for Spin and Cash-out/Quit buttons
		button_rows_posy = 11.14,		-- Y pos for "n Lines" row, and Cash Out/Quit button

		main_button_size = 0.8,			-- X/Y size of Lines/Bet buttons; X*2 x Y for Spin and Cash Out
		main_button_spacing = 0.9,		-- X/Y Spacing between Lines/Bet buttons, and between Spin and
										-- Cash Out buttons

		button_help_sizex = 1.6,		-- Size and position of the "Help / Pays" button
		button_help_sizey = 0.8,
		button_help_posx = 0.125,
		button_help_posy = 10.0938,

		screen_posx = 0.125,			-- X/Y position of top-left corner of lower screen (i.e. (0,0))
		screen_posy = 11.094,

		screen_line_height = 0.875,		-- Height of line 1, and 2 in 2-line mode.  In 3-line mode, line 2
										-- hight will be 2/3 of this, and line 3 height will be 1/3 of it.

		label_medium_sizex = 1.125,		-- X size of "Bal:", "Bet:", "Win:".
		line_win_label_sizex = 2.0,		-- X size of "Line Win" label
		scatter_win_label_sizex = 3.0,	-- X size of "Scatter Win:" label
		bonus_win_label_sizex = 2.75,	-- X size of "Bonus Win:" label

		digit_glyph_sizex = 0.75,		-- Nominal X size of digits, before scaling down as noted below

		cash_slot_sizex = 5.0,			-- X/Y size and position of the cash slot
		cash_slot_sizey = 0.8125,
		cash_slot_posx = 7.9063,
		cash_slot_posy = 10.0938,
		cash_slot_cin_posx = 1.9,		-- X/Y position within the "cash intake" form (uses the same size as
		cash_slot_cin_posy = 2.27,		-- above)

		paytable_column1 = 0.6,			-- position of left/right columns in the paytable screen.
		paytable_column2 = 6.85,
		paytable_posy = 0.5,
		paytable_lineheight = 0.65,		-- height of a pay table line. sets the Y spacing of the lines, and the
										-- X/Y size of reel symbols shown therein, minus a bit of padding.
		paytable_textheight = 0.45,		-- height of printed text within said line, which will be vert. centered
		paytable_textshift = 0.075,		-- use this to fine tune the text vertical position relative to symbols

		paylines_column1 = 1,			-- position of left and right columns in paylines screen
		paylines_column2 = 7.25,
		paylines_posy = 1,				-- position of first row
		paylines_sizex = 5,				-- size of the pay lines graphic
		paylines_sizey = 4,
		paylines_lineheight = 0.65,		-- text line height and font height
		paylines_textheight = 0.40,
		paylines_img_padding = 0.25		-- extra blank space to add below pay lines graphic
	}
})
