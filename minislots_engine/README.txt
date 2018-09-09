NOTES
=====

Geometry:
---------

"IU" = the size of an item in inventory units.  For most things, scaling is done such that 64 pixels in the image fits exactly 1 IU, though 1 IU in the formspec doesn't necessarily correspond with any specific number of screen pixels (but that's not important here).

Minetest normally uses exact values for sizes, but due to legacy screwiness in how formspecs are rendered, positioning is done at a scale of about 1.2422:1 in the horizontal direction, and 1.1538:1 in the vertical direction, at least for most stuff, and some stuff isn't exact-size either.

Furthermore, Minetest doesn't treat the upper-left corner of a formspec as the (0,0) origin, but rather, somewhat below and to the right of that spot (officially it's off by (0.5, 0.5) IU, but in reality, the offset is closer to half of that).

A 1x1 IU label/graphic that should be displayed at position (2,2) will end up being 1x1 in size as intended, but positioned at about (2.484,2.308) plus the origin point.

The Minislots display engine will position the imagery to such that there's a thin shaded border around the machine's graphics, and it will correct for the above-mentioned legacy scaling and positioning where it can.

The cash slot can be almost any size/shape and can be placed anywhere, so that you could, for example, draw it to look like a coin slot, with all the chrome and corrugated edging and such, and position it at the top of the form, to mimic turn-of-the-century-styled machines.  That said, bear in mind that when you click on it, you're taken to the "cash intake" screen, where the cash slot image is also shown, at the same size, and in there, it has to fit in between the single intake slot and the inventory slots.

The currency label, if printed, is positioned 25% of a digit's width after the end of the amount.  It is scaled to the 1.333 times a digit's width to keep it's relative scale correct.  It should indicate "Minegeld" in some manner, usually "Mg", as that's what this engine uses internally (from Dan Duncombe's "currency" mod).

The "Win" label, if printed, will appear half a digit glyph's width after the Bet amount's currency label.

Balance, Bet, Win, Scatter Win, and Bonus Win amounts are printed immediately next to their labels.  Be sure you leave a little space on the right in the images, as needed.

The scatter and bonus highlight boxes are displayed at 1.333 times the width of the reel, and positioned 1/6 of the reel width above and left, thus centering it over the symbol.  This is to allow some kind of "glow" or other effect to appear just outside of the highlight box itself.  The nominal size of the image is 1.333 times the width of the reel, square, but because Minetest does not support full alpha on overlaid images in a formspec, you'll have to fake it by dithering the alpha.  Draw this image large enough and the downscaling will blur the dithering, making it look like real alpha, mostly. Hence, the images used in these example machines are considerably over-sized.

The various labels, parenthesis, and colon were drawn with The GIMP using the "Liberation Sans Narrow Bold Condensed" font, 85 point height, with the inter-character spacing set as small as the wording would allow (usually -4.0).  Anti-aliasing enabled, "Full" hinting.  Text positioned two pixels from the left, baseline at 60 (so the lower left corner of the "B" in "Bal:" is at (2,60) according to GIMP).

The numerals use "Century Schoolbook L Bold" font, same size, settings, etc. Same vertical positioning, and horizontally-centered.

Reels always show three symbols' of height, not counting the overlap at the top and bottom to allow for symbols to be positioned "off-screen".


Geometry for the 3-reel "Golden 7's" machine:

The upper overlay, reel underlay, and line win overlays are 832x704 px	--> 13 x 11 IU
The lower overlay image is 832x128 px									--> 13 x 2 IU
A single reel image is 192x576 px										--> 3 x 9  IU

A digit glyph is 48x80 px, or 0.75 IU, but will be displayed at 75%, 45% or 40%
of that IU size, depending on line height (to fit in large values)		--> 0.563, 0.338, or 0.30 IU
The currency label is 96x80 px											--> 0.4 x screen_line_height_3 IU
The "Bal", "Bet" and "Win" labels are 128x80 px, but should be narrower	--> 1.125 x line_height IU
The "Line Win" label is 256x80 px, should be displayed at 50% width		--> 3.0 x screen_line_height_3 IU
A colon or parenthesis is 24x80 pixels, displayed at 50% digit width	--> 0.188 x screen_line_height_3 IU
The "Scatter Win" is 384x80 px, should be displayed at 50% width		--> 3.0 x screen_line_height_3 IU
The "Bonus Win" label is 352x80 px, should be displayed at 50% width	--> 2.75 x screen_line_height 3 IU
The cash slot is 320x128 px and is normally shown at full-size			--> 5.0 x 2.0 IU
The "screen" in the lower overlay is 384x112 px							--> 6.0 x 0.875 IU.
The Scatter and Bonus highlight boxes are 768x768px						--> 4.0 x 4.0 IU

Geometry or the 5-reel "Golden 7's Deluxe" machine:

The upper overlay, reel underlay, and line win overlays are 939x704 px	--> 14.667 x 11 IU
The lower overlay image is 939x128 px									--> 13 x 2 IU
A single reel image is 128x576 px										--> 2 x 9  IU

A digit glyph is 48x80 px, or 0.75 IU, but will be displayed at 75%, 45% or 40%
of that IU size, depending on line height (to fit in large values)		--> 0.563, 0.338, or 0.30 IU
The currency label is 96x80 px											--> 0.4 x screen_line_height_3 IU
The "Bal", "Bet" and "Win" labels are 128x80 px, but should be narrower	--> 1.125 x line_height IU
The "Line Win" label is 256x80 px, should be displayed at 50% width		--> 3.0 x screen_line_height_3 IU
A colon or parenthesis is 24x80 pixels, displayed at 50% digit width	--> 0.188 x screen_line_height_3 IU
The "Scatter Win" is 384x80 px, should be displayed at 50% width		--> 3.0 x screen_line_height_3 IU
The "Bonus Win" label is 352x80 px, should be displayed at 50% width	--> 2.75 x screen_line_height 3 IU
The cash slot is 320x128 px and is normally shown at full-size			--> 5.0 x 2.0 IU
The "screen" in the lower overlay is 384x112 px							--> or 6.0 x 0.875 IU.
The Scatter and Bonus highlight boxes are 512x512 px					--> 2.667 x 2.667 IU


How wild cards work:
--------------------

[WILD!] is basically "don't care", as far as the engine's concerned, and will match the highest entry in the table that can theoretically form a match, regardless of how many symbols actually match.

For example, suppose you get a normal-looking spin showing [WILD!][77][77][lemon][cherry] on a line.  That won't match anything, because there's no match line that only needs one symbol, nor any match lines that allow for a match consisting of only three "7" symbols of any kind.

On the other hand, suppose you get [WILD!][WILD!][WILD!][2bar][cherry].  Sounds like it should match the {"2bar", "2bar", "2bar", "2bar", nil} entry, but it'll pick the {"3bar", "3bar", "3bar", nil, nil} entry, because that one also matches, but it's worth more.

This extends to as many reels as the machine has, and as many [WILD!]'s as there are in a pay line, regardless of where in the line they appear (so long as the symbols that precede and follow the [WILD!]'s can form valid matches, of course).

A pay line consisting of all [WILD!]'s is equivalent to whatever the highest winning combination is in your machine (five [JACKPOT]'s here).
