 
-- Golden 7's Deluxe example machine
--
-- By Vanessa Dannenberg
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
		{   2, "lemon"   ,  "lemon"   ,  "lemon"   ,   "lemon"  ,  "lemon"   },

		{   4, "melon"   ,  "melon"   ,  "melon"   ,   "melon"  ,  "melon"   },

		{   5, "cherry"  ,  "cherry"  ,  "cherry"  ,  nil       ,  nil       },
		{   6, "cherry"  ,  "cherry"  ,  "cherry"  ,  "cherry"  ,  nil       },
		{   7, "cherry"  ,  "cherry"  ,  "cherry"  ,  "cherry"  ,  "cherry"  },

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

		{  90, "7"       ,  "7"       ,  "7"       ,  "7"       ,  "7"       },

		{ 100, "77"      ,  "77"      ,  "77"      ,  "77"      ,  "77"      },

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

		button_rows_posx = 6.25,			-- X starting pos for "n Lines"/"Bet n" buttons, Y pos for Spin button
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

--[[

NOTES:

Geometry:
---------

"IU" = the size of an item in inventory units.  For most things, scaling is
done such that 64 pixels in the image fits exactly 1 IU, though 1 IU in the
formspec doesn't necessarily correspond with any specific number of screen
pixels (but that's not important here).

Minetest normally uses exact values for sizes, but due to legacy screwiness in
how formspecs are rendered, positioning is done at a scale of about 1.2422:1
in the horizontal direction, and 1.1538:1 in the vertical direction, at least
for most stuff, and some stuff isn't exact-size either.

Furthermore, Minetest doesn't treat the upper-left corner of a formspec as
the (0,0) origin, but rather, somewhat below and to the right of that spot
(officially it's off by (0.5, 0.5) IU, but in reality, the offset is closer to
half of that).

A 1x1 IU label/graphic that should be displayed at position (2,2) will end up
being 1x1 in size as intended, but positioned at about (2.484,2.308) plus the
origin point.

The Minislots display engine will position the imagery to such that there's a
thin shaded border around the machine's graphics, and it will correct for the
above-mentioned legacy scaling and positioning where it can.

The upper overlay, reel underlay, and line win overlays are 939x704 px	--> 14.6667 x 11 IU
The lower overlay image is 939x128 px									--> 13 x 2 IU
A single reel image is 128x576 px										--> 2 x 9  IU

A digit glyph is 48x80 px, or 0.75 IU, but will be displayed at 75%, 45% or 40%
of that IU size, depending on line height (to fit in large values)		--> 0.563, 0.338, or 0.30 IU
The "Bal", "Bet" and "Win" labels are 128x80 px, but should be narrower	--> 1.125 x line-height IU
The "Line Win" label is 256x80 px, should be displayed at 50% width		--> 3.0 x screen_line_height_3 IU
A colon or parenthesis is 24x80 pixels, displayed at 50% digit width	--> 0.188 x screen_line_height_3 IU
The "Scatter Win" is 384x80 px, should be displayed at 50% width		--> 3.0 x screen_line_height_3 IU
The "Bonus Win" label is 352x80 px, should be displayed at 50% width	--> 2.75 x screen_line_height 3 IU
The cash slot is 320x128 px and is normally shown at full-size			--> 5.0 x 2.0 IU

Note that the cash slot can be almost any size/shape and can be placed
anywhere, so that you could, for example, draw it to look like a coin slot,
with all the chrome and corrugated edging and such, and position it at the top
of the form, to mimic turn-of-the-century-styled machines.  That said, bear in
mind that when you click on it, you're taken to the "cash intake" screen,
where the cash slot image is also shown, at the same size, and in there, it
has to fit in between the single intake slot and the inventory slots.

The "screen" in the lower overlay is 384x112 px, or 6.0 x 0.875 IU.

The currency label is 96x80 px, and if printed, is positioned 25% of a digit's
width after the end of the amount.  It is scaled to the 1.333 times a digit's
width to keep it's relative scale correct.

The "Win" label, if printed, will appear half a digit glyph's width after the
Bet amount's currency label.

Balance, Bet, Win, Scatter Win, and Bonus Win amounts are printed immediately
next to their labels.  Be sure you leave a little space on the right in the
images, as needed.

The scatter and bonus highlight boxes are displayed at 1.333 times the width
of the reel, and positioned 1/6 reel width above and left, thus centering it
over the symbol.  This is to allow some kind of "glow" or other effect to
appear just outside of the highlight box itself.  The nominal size of the
image is 171 px square, but because Minetest does not support full alpha on
overlaid images in a formspec, you'll have to fake it by dithering the alpha.
Draw this image large enough and the downscaling will blur the dithering,
making it look like real alpha, mostly.  That is why the images in this
machine are drawn at 512 px square.

The various labels, parenthesis, and colon were drawn with The GIMP using the
"Liberation Sans Narrow Bold Condensed" font, 85 point height, with the inter-
character spacing set as small as the wording would allow (usually -4.0).
Anti-aliasing enabled, "Full" hinting.  Text positioned two pixels from the
left, baseline at 60 (so the lower left corner of the "B" in "Bal:" is at
(2,60) according to GIMP).

The numerals use "Century Schoolbook L Bold" font, same size, settings, etc.
Same vertical positioning, and horizontally-centered`.

Reels always show three symbols' of height, not counting the overlap at the
top and bottom to allow for symbols to be positioned "off-screen".


How wild cards work:
--------------------

[WILD!] is basically "don't care", as far as the engine's concerned, and will
match the highest entry in the table that can theoretically form a match,
regardless of how many symbols actually match.

For example, suppose you get a normal-looking spin showing
[WILD!][77][77][lemon][cherry] on a line.  That won't match anything, because
there's no match line that only needs one symbol, nor any match lines that
allow for a match consisting of only three "7" symbols of any kind.

On the other hand, suppose you get [WILD!][WILD!][WILD!][2bar][cherry].  Sounds
like it should match the {"2bar", "2bar", "2bar", "2bar", nil} entry, but
it'll pick the {"3bar", "3bar", "3bar", nil, nil} entry, because that one also
matches, but it's worth more.

This extends to as many reels as the machine has, and as many [WILD!]'s as
there are in a pay line, regardless of where in the line they appear (so long
as the symbols that precede and follow the [WILD!]'s can form valid matches,
of course).

A pay line consisting of all [WILD!]'s is equivalent to whatever the highest
winning combination is in your machine (five [JACKPOT]'s here).

]]--
