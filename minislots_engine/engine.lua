-- Minislots game engine
-- by Vanessa "VanessaE" Dannenberg

local mtver = minetest.get_version()

math.randomseed(os.time())

local words_numbers = {  -- image widths, in pixels
	[0] = { "ZERO",	0   },
	{ "ONE",		41  },
	{ "TWO",		48  },
	{ "THREE", 		64  },
	{ "FOUR",		53  },
	{ "FIVE",		41  },
	{ "SIX",		32  },
	{ "SEVEN",		62  },
	{ "EIGHT",		59  },
	{ "NINE",		45  },
	{ "TEN",		38  },
	{ "ELEVEN",		72  },
	{ "TWELVE",		79  },
	{ "THIRTEEN",	94  },
	{ "FOURTEEN",	100 },
	{ "FIFTEEN", 	76  },
	{ "SIXTEEN",	81  },
	{ "SEVENTEEN",	112 },
	{ "EIGHTEEN",	95  },
	{ "NINETEEN",	94  }
}

local words_tens = {
	{ "", 0, 0 }, 
	{ "TWENTY",		84  },
	{ "THIRTY",		70  },
	{ "FORTY",		61  },
	{ "FIFTY",		52  },
	{ "SIXTY",		57  },
	{ "SEVENTY",	88  },
	{ "EIGHTY",		71  },
	{ "NINETY",		70  }
}

local words_magnitudes = {
	{ "HUNDRED",	96  },
	{ "THOUSAND",	110 },
	{ "MILLION",	77  }
}

function minislots.spin_reels(def)
	local spin = { [1] = {}, [2] = {}, [3] = {} }
	for reel = 1, def.constants.numreels do
		local n = math.random(2, def.constants.numsymbols*2+1)/2
		if math.random(1, 100) >= def.half_stops_weight then n = math.floor(n) end

-- force the all-wilds win shown in the cabinet graphics, 3-reel
--		local n = 10
--		if reel == 2 then n = 9 end
--		if reel == 3 then n = 8 end

-- force the all-wilds win shown in the cabinet graphics, 5-reel
--		local n = 10
--		if reel == 3 then n = 9 end
--		if reel > 3 then n = 8 end

-- force a no-win spin
--		local n = 1
--		if reel == 2 then n = 4 end
--		if reel == 3 then n = 10 end

--		local n = 12 -- force a scatter win

--		local n = 16 -- force a bonus win + 3 line wins

		spin[1][reel] = { n-1, def.symbols[n-1] }
		spin[2][reel] = { n,   def.symbols[n]   }
		spin[3][reel] = { n+1, def.symbols[n+1] }
	end
	return spin
end

function minislots.reset_reels(def)
	local resetspin = { [1] = {}, [2] = {}, [3] = {} }
	for reel = 1, def.constants.numreels do
		resetspin[1][reel] = { 0, def.symbols[0] }
		resetspin[2][reel] = { 1, def.symbols[1] }
		resetspin[3][reel] = { 2, def.symbols[2] }
	end
	return resetspin
end

function minislots.check_win(spin, def, maxlines)
	local allwins = { total = 0, line_wins_total = 0 }
	local paylinecontent = {}
	allwins.scatter = { count = 0, pos = {} }
	allwins.bonus = { value = -1, count = 0, pos = {} }

	for payline,paylineoffsets in ipairs(def.lines) do
		local highestwin = nil
		if payline > maxlines then break end
		paylinecontent[payline] = {}
		for _,m in ipairs(def.matches) do
			local matchwin = true
			for reel = 1, def.constants.numreels do
				local row = paylineoffsets[reel]+2
				paylinecontent[payline][reel] = spin[row][reel][2]
				if m[reel+1] and (spin[row][reel][2] ~= m[reel+1]) and spin[row][reel][2] ~= "wild" then
					matchwin = false
					break
				end
			end
			if matchwin then
				highestwin = m[1]
			end
		end
		if highestwin then
			table.insert(allwins, { payline = payline, value = highestwin, symbols = paylinecontent[payline]})
		end
	end

	for row = 1, 3 do
		for reel = 1, def.constants.numreels do
			if spin[row][reel][2] == "scatter" then
				allwins.scatter.count = allwins.scatter.count + 1
				table.insert(allwins.scatter.pos, { reel, row } )
			elseif spin[row][reel][2] == "bonus" then
				allwins.bonus.count = allwins.bonus.count + 1
				table.insert(allwins.bonus.pos, { reel, row } )
			end
		end
	end

	if #allwins > 0 then
		for _, win in ipairs(allwins) do
			allwins.line_wins_total = allwins.line_wins_total + win.value
		end
	end

	return allwins
end

local horizscale = 0.805	-- scaling to apply to any position values that need it (will be most)
local vertscale = 0.867
local hanchor = 0.23		-- the position of (0,0) relative to the upper-left formspec corner
local vanchor = 0.24

function minislots.register_machine(mdef)
	local def = table.copy(mdef)
	def.constants = {}

	if string.sub(mtver.string, 1, 4) == "5.0." then
		print("[Minislots] 5.0.x engine detected, Adjusting display to compensate.")
		horizscale = 0.800
	end

	def.constants.cashout_screen_hposscale = 0.0175
	def.constants.cashout_screen_ctrx = (def.geometry.base_user_interface_width/2)*horizscale - hanchor
	def.constants.cashoutticketimg_posx = (def.geometry.base_user_interface_width/2 - 3.75)*horizscale - hanchor

	def.constants.form_header = "size["..(def.geometry.base_user_interface_width*0.785)..","..
								((def.geometry.upper_section_height+def.geometry.lower_section_height)*0.823).."]"
	def.constants.mainpref   = "image[-"..hanchor..",-"..vanchor..";"..
								def.geometry.base_user_interface_width..","..def.geometry.upper_section_height..";"
	def.constants.screenposx = def.geometry.screen_posx * horizscale - hanchor
	def.constants.screenposy = def.geometry.screen_posy * vertscale - vanchor
	def.constants.lscrnpref = "image["..def.constants.screenposx

	def.constants.lscrnypos1  = ","..(def.constants.screenposy)..";"
	def.constants.lscrnypos2  = ","..(def.constants.screenposy + def.geometry.screen_line_height * vertscale)..";"

	def.constants.cslotposx = def.geometry.cash_slot_posx * horizscale - hanchor
	def.constants.cslotposy = def.geometry.cash_slot_posy * vertscale - vanchor
	def.constants.cslotbtnszx = def.geometry.cash_slot_sizex * 0.8455
	def.constants.cslotbtnszy = def.geometry.cash_slot_sizey * 1.0241

	def.constants.spincoutposx = def.geometry.spin_cashout_posx * horizscale - hanchor
	def.constants.spinposy = def.geometry.button_rows_posy * vertscale - vanchor
	def.constants.coutposy = (def.geometry.button_rows_posy
								+ def.geometry.main_button_spacing) * vertscale - vanchor
	def.constants.spincoutsizex = def.geometry.main_button_size*2
	def.constants.spincoutsizey = def.geometry.main_button_size
	def.constants.spincoutbtnszx = def.constants.spincoutsizex * 0.91
	def.constants.spincoutbtnszy = def.constants.spincoutsizey * 1.05

	def.constants.reelspc = def.geometry.reel_sizex*1.3333
	def.constants.highlightboxszx = def.geometry.reel_sizex*1.3333
	def.constants.highlightboxszy = def.geometry.reel_sizey/3*1.3333
	def.constants.highlightboxoffsx = 1-(def.geometry.reel_sizex/6)
	def.constants.highlightboxoffsy = 1-(def.geometry.reel_sizey/18)

	def.constants.screenlnht2 = def.geometry.screen_line_height * 0.6667
	def.constants.screenlnht3 = def.geometry.screen_line_height * 0.3333
	def.constants.digitmed = def.geometry.digit_glyph_sizex * 0.45
	def.constants.digitsm = def.geometry.digit_glyph_sizex * 0.4
	def.constants.lscrnypos3  = ","..(def.constants.screenposy + (def.geometry.screen_line_height + def.constants.screenlnht2) * vertscale)..";"
	def.constants.medlblsz1 = def.geometry.label_medium_sizex..","..def.geometry.screen_line_height..";"
	def.constants.medlblsz2 = def.geometry.label_medium_sizex..","..def.constants.screenlnht2..";"
	def.constants.posy3 = def.constants.screenposy + (def.geometry.screen_line_height + def.constants.screenlnht2) * vertscale
	def.constants.lnwinlblsz = def.geometry.line_win_label_sizex..","..def.constants.screenlnht3..";"
	def.constants.parensize = def.geometry.digit_glyph_sizex/4
	def.constants.parenlblsz = def.constants.parensize..","..def.constants.screenlnht3..";"
	def.constants.ln3dig = def.geometry.digit_glyph_sizex/4

	def.constants.numreels = #def.lines[1]
	def.constants.numsymbols = #def.symbols
	def.symbols[#def.symbols+1] = def.symbols[1]
	def.symbols[0] = def.symbols[def.constants.numsymbols]

	def.constants.fast_med_cutover = def.cutover_frames*2
	def.constants.med_slow_cutover = def.constants.fast_med_cutover + def.cutover_frames*2
	def.constants.slow_stop_cutover = def.constants.med_slow_cutover + def.cutover_frames*2
	def.constants.last_step = def.inter_reel_steps * (def.constants.numreels-1) + def.constants.slow_stop_cutover
	def.constants.reel_wraparound_buf = def.constants.numsymbols*10

	def.constants.basename			= "minislots_"..def.name.."_"

	def.constants.emptyimg			= "minislots_empty_img.png"

	def.constants.reelimg 			= def.constants.basename.."reel_background.png"
	def.constants.reelshadowimg		= ":0,0="..def.constants.basename.."reel_shadow.png]"
	def.constants.scatterhlimg		= def.constants.highlightboxszx..","..def.constants.highlightboxszy..";"..
										def.constants.basename.."highlight_scatter.png]"
	def.constants.bonushlimg		= def.constants.highlightboxszx..","..def.constants.highlightboxszy..";"..
										def.constants.basename.."highlight_bonus.png]"
	def.constants.cashslotscrnbg	= def.constants.basename.."cash_slot_screen_background.png"

	def.constants.symbolsfast		= def.constants.basename.."reel_symbols_fast.png"
	def.constants.symbolsmedium		= def.constants.basename.."reel_symbols_medium.png"
	def.constants.symbolsslow		= def.constants.basename.."reel_symbols_slow.png"
	def.constants.symbolsstopped	= def.constants.basename.."reel_symbols_stopped.png"

	def.constants.ballabelimg		= def.constants.basename.."label_balance.png]"
	def.constants.betlabelimg		= def.constants.basename.."label_bet.png]"
	def.constants.winlabelimg		= def.constants.basename.."label_win.png]"
	def.constants.linewinlabelimg	= def.constants.basename.."label_linewin.png]"
	def.constants.scatterwinlabelimg = def.geometry.scatter_win_label_sizex..","..def.constants.screenlnht3..";"..def.constants.basename.."label_scatterwin.png]"
	def.constants.bonuswinlabelimg	= def.geometry.bonus_win_label_sizex..","..def.constants.screenlnht3..";"..def.constants.basename.."label_bonuswin.png]"
	def.constants.curlabelimg		= ";"..def.constants.basename.."label_currency.png"

	def.constants.lparenimg			= def.constants.basename.."glyph_lparen.png]"
	def.constants.rparenimg			= def.constants.basename.."glyph_rparen.png]"
	def.constants.colonimg			= def.constants.basename.."glyph_colon.png]"

	def.constants.lnbetpref			= def.geometry.main_button_size..","..def.geometry.main_button_size..";"

	def.constants.behindreels		= def.constants.mainpref..def.constants.basename.."behind_reels.png]"
	def.constants.overlay_upper 	= def.constants.mainpref..def.constants.basename.."overlay_upper.png]"

	def.constants.buttonspin		= "image["..def.constants.spincoutposx..","..def.constants.spinposy..";"..
										def.constants.spincoutsizex..","..def.constants.spincoutsizey..";"..
										def.constants.basename.."button_spin.png]"..
										"image_button["..def.constants.spincoutposx..","..def.constants.spinposy..
										";"..def.constants.spincoutbtnszx..","..def.constants.spincoutbtnszy..";"..
										def.constants.emptyimg..";spin;]"
	def.constants.buttonspin_dis	= "image["..def.constants.spincoutposx..","..def.constants.spinposy..";"..
										def.constants.spincoutsizex..","..def.constants.spincoutsizey..";"..
										def.constants.basename.."button_spin_dis.png]"

	def.constants.buttoncashout		= "image["..def.constants.spincoutposx..","..def.constants.coutposy..";"..
										def.constants.spincoutsizex..","..def.constants.spincoutsizey..";"..
										def.constants.basename.."button_cash_out.png]"..
										"image_button["..def.constants.spincoutposx..","..def.constants.coutposy..";"..
										def.constants.spincoutbtnszx..","..def.constants.spincoutbtnszy..";"..
										def.constants.emptyimg..";cout;]"
	def.constants.buttoncashout_dis = "image["..def.constants.spincoutposx..","..def.constants.coutposy..";"..
										def.constants.spincoutsizex..","..def.constants.spincoutsizey..";"..
										def.constants.basename.."button_cash_out_dis.png]"

	def.constants.buttonquit		= "image["..def.constants.spincoutposx..","..def.constants.coutposy..";"..
										def.constants.spincoutsizex..","..def.constants.spincoutsizey..";"..
										def.constants.basename.."button_quit.png]"..
										"image_button_exit["..def.constants.spincoutposx..","..def.constants.coutposy..";"..
										def.constants.spincoutbtnszx..","..def.constants.spincoutbtnszy..";"..
										def.constants.emptyimg..";quit;]"

	def.constants.buttoncashslot	= "image["..def.constants.cslotposx..","..def.constants.cslotposy..";"..
										def.geometry.cash_slot_sizex..","..def.geometry.cash_slot_sizey..";"..
										def.constants.basename.."cash_slot.png]"..
										"image_button["..def.constants.cslotposx..","..def.constants.cslotposy..";"..
										def.constants.cslotbtnszx..","..def.constants.cslotbtnszy..";"..
										def.constants.emptyimg..";cslot;]"
	def.constants.button_cslot_close = def.constants.basename.."cash_slot_screen_close_button.png"

	def.constants.reelsymsizex		= def.geometry.reel_sizex*64
	def.constants.reelsymsizey		= def.geometry.reel_sizey/3*64

	def.constants.reelcombinepref	= ","..(vertscale-vanchor)..";"..
										(def.geometry.reel_sizex)..","..(def.geometry.reel_sizey)..";"..
										def.constants.reelimg..
										"^[combine:"..def.constants.reelsymsizex.."x"..
										def.constants.reelsymsizey

	def.constants.reelunderlightpref = def.constants.basename.."reel_underlight_"
	def.constants.overlaylinepref	= def.constants.basename.."overlay_line_"
	def.constants.overlay_lower		= "image[-"..hanchor..","..(11*vertscale-vanchor)..";"..
										def.geometry.base_user_interface_width..","..def.geometry.lower_section_height..";"..
										def.constants.basename.."overlay_lower.png]"

	def.constants.upperbezel		= def.constants.mainpref.."minislots_golden7s_overlay_upper_bezel.png]"
	def.constants.cashoutbackground	= def.constants.mainpref.."minislots_blue_img.png]"
	def.constants.cashoutticketimg	= "image["..def.constants.cashoutticketimg_posx..","..(3.5-vanchor)..
										";8,3;minislots_cashout_ticket.png]"
						

	def.constants.buttons_n_lines = {}
	def.constants.buttons_bet_n = {}

	for i, value in ipairs(def.linebuttons) do
		def.constants.buttons_n_lines[value] = {}
		local posx = ((def.geometry.button_rows_posx
						+ (i-1)*def.geometry.main_button_spacing) * horizscale - hanchor)

		for _, state in ipairs( {"dis", "off", "on"} ) do
			def.constants.buttons_n_lines[value][state] = "image["..posx..","..def.constants.spinposy..";"..
				def.constants.lnbetpref..def.constants.basename.."button_lines_"..state.."_"..value..
				".png]image_button["..posx..","..def.constants.spinposy..";"..
				def.constants.lnbetpref.."minislots_empty_img.png;lines_"..value..";]"
		end
	end

	for i, value in ipairs(def.betbuttons) do
		def.constants.buttons_bet_n[value] = {}

		local posx = ((def.geometry.button_rows_posx
						+ (i-1)*def.geometry.main_button_spacing) * horizscale - hanchor)

		for _, state in ipairs( {"dis", "off", "on"} ) do
			def.constants.buttons_bet_n[value][state] = "image["..posx..","..def.constants.coutposy..";"..
				def.constants.lnbetpref..def.constants.basename.."button_bet_"..state.."_"..value..
				".png]image_button["..posx..","..def.constants.coutposy..";"..
				def.constants.lnbetpref.."minislots_empty_img.png;bet_"..value..";]"
		end
	end

	def.constants.digits = {}
	for i = 0, 9 do
		def.constants.digits[tostring(i)] = def.constants.basename.."glyph_digit_"..i..".png"
	end

	local mesh = ""
	local tiles = {}
	local cbox = {}

	if def.machine_shape == "standard" then
		mesh = "minislots_generic_machine_standard.obj"
		cbox = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5,    0.5, 0.5, 0.5 },
				{-0.5,  0.5, -0.1875, 0.5, 1.5, 0.5 },
			}
		}
	elseif def.machine_shape == "big" then
		mesh = "minislots_generic_model_bigslot.obj"
		cbox = {
			type = "fixed",
			fixed = { -1, -0.5, -0.5, 1.5, 3.5, 1.5 }
		}
	end

	minetest.register_node(":minislots:"..def.name, {
		description = def.description,
		drawtype = "mesh",
		mesh = mesh,
		tiles = { "minislots_"..def.name.."_cabinet_graphics.png" },
		node_box = cbox,   -- this is used to create proper collision info.
		paramtype2 = "facedir",
		selection_box = cbox,
		is_ground_content = false,
		groups = {cracky = 1, level = 2},
		sounds = default.node_sound_metal_defaults(),
		machine_def = table.copy(def),
		on_timer = minislots.cycle_states,
		on_construct = function(pos)
			local def = minetest.registered_items["minislots:"..def.name].machine_def
			local meta = minetest.get_meta(pos)
			local resetspin = minislots.reset_reels(def)
			local balance = 0
			local linebet = 1
			local maxlines = 1
			local emptywins = {
				scatter = { count = 0, pos = {} },
				bonus = { value = -1, count = 0, pos = {} }
			}
			meta:set_int("balance", balance)
			meta:set_int("last_cashout", 0)
			meta:set_int("linebet", linebet)
			meta:set_int("maxlines", maxlines)
			meta:set_int("bonus_result", -1)
			meta:set_string("state", "stopped")
			meta:set_string("spin", minetest.serialize(resetspin))
			meta:set_string("allwins", minetest.serialize(emptywins))
			meta:mark_as_private({"balance", "last_cashout", "linebet", "maxlines", "bonus_result", "state", "spin", "allwins"})

			meta:set_string("formspec", minislots.generate_display(def, "stopped", resetspin, emptywins, balance, linebet, maxlines))

			local inv = meta:get_inventory()
			inv:set_size("main", 1)
		end,
		after_place_node = function(pos, placer, itemstack)
			local meta = minetest.get_meta(pos)
			local owner = placer:get_player_name()
			meta:set_string("owner", owner)
		end,
		can_dig = function(pos, player)
			local meta = minetest.get_meta(pos)
			local name = player and player:get_player_name()
			local owner = meta:get_string("owner")
			local inv = meta:get_inventory()
			return name == owner and meta:get_int("balance") == 0
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			local def = minetest.registered_items["minislots:"..def.name].machine_def
			local player_name = player:get_player_name()
			local meta = minetest.get_meta(pos)
			local state = meta:get_string("state")
			local spin = minetest.deserialize(meta:get_string("spin"))
			local balance = meta:get_int("balance")
			local linebet = meta:get_int("linebet")
			local maxlines = meta:get_int("maxlines")
			local timer = minetest.get_node_timer(pos)
			local last_cashout = nil
			timer:stop()
			local inv = meta:get_inventory()
			inv:remove_item("main", stack)
			local state = "stopped"
			meta:set_string("state", state)
			meta:set_int("last_cashout", balance)
			meta:set_string("formspec", minislots.generate_display(def, state, spin, {}, balance, linebet, maxlines, nil, last_cashout))
			minetest.show_formspec(player_name, "minislots:cash_intake",
				minislots.generate_cashslot_form(def, pos, balance))
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local sn = stack:get_name()
			if string.find(sn, "minegeld") then
				local mg = tonumber(string.sub(sn, 19))
				if not mg then mg = 1 end
				local balance = meta:get_int("balance")
				if balance < (def.maxbalance - mg*stack:get_count()) then
					balance = balance + mg*stack:get_count()
					meta:set_int("balance", balance)
					return -1
				else
					return 0
				end
			end
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			local def = minetest.registered_items["minislots:"..def.name].machine_def
			local player_name = sender:get_player_name()
			local meta = minetest.get_meta(pos)
			local state = meta:get_string("state")
			local spin = minetest.deserialize(meta:get_string("spin"))
			local balance = meta:get_int("balance")
			local linebet = meta:get_int("linebet")
			local maxlines = meta:get_int("maxlines")
			local timer = minetest.get_node_timer(pos)
			timer:stop()

			local allfields = minetest.serialize(fields)
			if fields.cslot then
				local meta = minetest.get_meta(pos)
				local balance = meta:get_int("balance")
				local player_name = sender:get_player_name()
				minetest.show_formspec(player_name, "minislots:cash_intake",
					minislots.generate_cashslot_form(def, pos, balance))
				return
			end

			if fields.cout then
				if balance > 0 and balance <= def.maxbalance then
					local state = "stopped"
					local last_cashout = balance
					balance = 0
					meta:set_string("state", state)
					meta:set_int("last_cashout", balance)
					meta:set_int("balance", balance)
					meta:set_string("formspec", minislots.generate_display(def, state, spin, {}, balance, linebet, maxlines, nil, last_cashout))

					local fifties = math.floor(last_cashout/50)
					local tens = math.floor((last_cashout - fifties*50)/10)
					local fives = math.floor((last_cashout - fifties*50 - tens*10)/5)
					local ones = math.floor(last_cashout - fifties*50 - tens*10 - fives*5)
					local inv = sender:get_inventory()
					if (fifties == 0 or inv:room_for_item("main", "currency:minegeld_50 "..fifties))
					  and (tens == 0 or inv:room_for_item("main", "currency:minegeld_10 "..tens))
					  and (fives == 0 or inv:room_for_item("main", "currency:minegeld_5 "..fives))
					  and (ones == 0 or inv:room_for_item("main", "currency:minegeld "..ones)) then

						if fifties > 0 then inv:add_item("main", "currency:minegeld_50 "..fifties) end
						if tens > 0 then inv:add_item("main", "currency:minegeld_10 "..tens) end
						if fives > 0 then inv:add_item("main", "currency:minegeld_5 "..fives) end
						if ones > 0 then inv:add_item("main", "currency:minegeld "..ones) end
					end
					return
				end
			elseif fields.quit then
				local allwins = minislots.check_win(spin, def, maxlines)
				meta:set_string("allwins", minetest.serialize(allwins))
				local state = "stopped"
				meta:set_string("state", state)
				meta:set_string("formspec", minislots.generate_display(def, state, spin, {}, balance, linebet, maxlines))
				return
			elseif fields.spin then
				if state == "stopped" or string.find(state, "win") then
					if maxlines*linebet > balance or balance > def.maxbalance then return end
					local node = minetest.get_node(pos)
					local spin = minislots.spin_reels(def)
					local allwins = minislots.check_win(spin, def, maxlines)
					meta:set_string("spin", minetest.serialize(spin))
					meta:set_string("allwins", minetest.serialize(allwins))
					meta:set_string("state", "start")
					minislots.cycle_states(pos)
					return
				end
			elseif string.find(allfields, "bet_") then
				local s1 = string.sub(allfields, 15)
				local s2 = string.find(s1, '"')
				local linebet = tonumber(string.sub(s1, 1, s2-1)) or 1
				if def.bet_initiates_spin then
					if maxlines*linebet > balance or balance > def.maxbalance then return end
					meta:set_int("linebet", linebet)
					local node = minetest.get_node(pos)
					local spin = minislots.spin_reels(def)
					local allwins = minislots.check_win(spin, def, maxlines)
					meta:set_string("spin", minetest.serialize(spin))
					meta:set_string("allwins", minetest.serialize(allwins))
					meta:set_string("state", "start")
					minislots.cycle_states(pos)
					return
				else
					if maxlines*linebet <= balance then
						local state = "stopped"
						meta:set_string("state", state)
						meta:set_int("linebet", linebet)
						meta:set_string("formspec", minislots.generate_display(def, state, spin, {}, balance, linebet, maxlines, true))
					end
				end
			elseif string.find(allfields, "lines_") then
				local s1 = string.sub(allfields, 17)
				local s2 = string.find(s1, '"')
				local maxlines = tonumber(string.sub(s1, 1, s2-1)) or 1
				if maxlines*linebet <= balance then
					local state = "stopped"
					meta:set_string("state", state)
					meta:set_int("maxlines", maxlines)
					meta:set_string("formspec", minislots.generate_display(def, state, spin, {}, balance, linebet, maxlines, true))
				end
			end
		end
	})
end


--###################
-- the state machine
--###################

function minislots.cycle_states(pos)
	local node = minetest.get_node(pos)
	local def = minetest.registered_items[node.name].machine_def

	local meta = minetest.get_meta(pos)
	local state = meta:get_string("state")

	local spin = minetest.deserialize(meta:get_string("spin"))
	local linebet = meta:get_int("linebet")
	local maxlines = meta:get_int("maxlines")
	local balance = meta:get_int("balance")
	local allwins = minetest.deserialize(meta:get_string("allwins"))
	local numscatter = (allwins and allwins.scatter and allwins.scatter.count) or 0
	local numbonus = (allwins and allwins.bonus and allwins.bonus.count) or 0

	local timeout = 0
	print("[Minislots] state machine is at "..state)

	if state == "start" then
		balance = meta:get_int("balance") - linebet*maxlines
		meta:set_int("balance", balance)
		state = "spinning_fast_0"
		timeout = def.reel_fast_timeout
	elseif string.find(state, "spinning_fast_") then
		local c = tonumber(string.sub(state, 15))
		c = c + 2
		if c >= def.constants.fast_med_cutover then
			state = "spinning_medm_"..def.constants.fast_med_cutover
			timeout = def.reel_medium_timeout
		else
			state = "spinning_fast_"..c
			timeout = def.reel_fast_timeout
		end
	elseif string.find(state, "spinning_medm_") then
		local c = tonumber(string.sub(state, 15))
		c = c + 2
		if c >= def.constants.med_slow_cutover then
			state = "spinning_slow_"..def.constants.med_slow_cutover
			timeout = def.reel_slow_timeout
		else
			state = "spinning_medm_"..c
			timeout = def.reel_medium_timeout
		end
	elseif string.find(state, "spinning_slow_") then
		local c = tonumber(string.sub(state, 15))
		c = c + 2
		if c >= def.constants.slow_stop_cutover then
			state = "reels_stopping_"..def.constants.slow_stop_cutover
			timeout = def.reel_slow_timeout
		else
			state = "spinning_slow_"..c
			timeout = def.reel_slow_timeout
		end
	elseif string.find(state, "reels_stopping_") then
		local sr = tonumber(string.sub(state, 16))
		sr = sr + 1
		if sr <= def.constants.last_step then
			state = "reels_stopping_"..sr
			timeout = def.reel_slow_timeout
		else
			if numscatter >= def.min_scatter or numbonus >= def.min_bonus then
				state = "stopped"
				timeout = 0.1
			else
				state = "stopped"
				timeout = def.win_delay
			end
		end
	elseif state == "stopped" then
		if #allwins > 0 then
			balance = balance + allwins.line_wins_total*linebet
			allwins.total = allwins.total + allwins.line_wins_total*linebet
		end
		if numscatter >= def.min_scatter then
			balance = balance + allwins.scatter.count*def.scatter_value*linebet
			allwins.total = allwins.total + allwins.scatter.count*def.scatter_value*linebet
		end
		if numbonus >= def.min_bonus and allwins.bonus.value < 0 then
			allwins.bonus.value = def.initiate_bonus(spin, def)
			balance = balance + allwins.bonus.value
			allwins.total = allwins.total + bonus_value
		end
		meta:set_string("allwins", minetest.serialize(allwins))
		meta:set_int("balance", balance)
		if numbonus >= def.min_bonus then
			state = "bonus_win"
			timeout = def.line_timeout
		elseif numscatter >= def.min_scatter then
			state = "scatter_win"
			timeout = def.line_timeout
		elseif #allwins > 0 then
			state = "win_1"
			timeout = def.line_timeout
		end
	elseif state == "bonus_win" then
		if numscatter >= def.min_scatter then
			state = "scatter_win"
			timeout = def.line_timeout
		elseif #allwins > 0 then
			state = "win_1"
			timeout = def.line_timeout
		end
	elseif state == "scatter_win" then
		if #allwins > 0 then
			state = "win_1"
			timeout = def.line_timeout
		end
	elseif string.find(state, "win_") then
		local w = tonumber(string.sub(state, 5)) + 1
		if w > #allwins then
			if numbonus >= def.min_bonus then
				state = "bonus_win"
				timeout = def.line_timeout
			elseif numscatter >= def.min_scatter then
				state = "scatter_win"
				timeout = def.line_timeout
			else
				state = "win_1"
				if #allwins > 1 then
					timeout = def.line_timeout
				end
			end
		else
			state = "win_"..w
			timeout = def.line_timeout
		end
	end

	meta:set_string("state", state)
	meta:set_string("formspec", minislots.generate_display(def, state, spin, allwins, balance, linebet, maxlines))

	if timeout > 0 then
		local timer = minetest.get_node_timer(pos)
		timer:start(timeout)
	end
	return false
end


--####################
-- the display engine
--####################

local function calcrp(def, spin, i, statenum)
	local rp = (
				spin[2][i+1][1]*2-2
				+ statenum
				+ def.constants.reel_wraparound_buf
				- def.constants.last_step
				+ (def.constants.numreels-i-1)*def.inter_reel_steps
			) % (def.constants.numsymbols * 2)
	return rp/2
end

function minislots.generate_display(def, state, spin, allwins, balance, linebet, maxlines, showlines, last_cashout)
	local reels			= ""
	local lines			= ""
	local scatters		= ""
	local bonuses		= ""
	local underlights	= {}
	local spinbutton	= ""
	local cashoutbutton	= ""

	for i = 1, def.constants.numreels do underlights[i] = "" end

	if state == "scatter_win" and allwins.scatter.count > 0 then
		for reel = 1, def.constants.numreels do
			local t = {}
			for row = 0, 2 do
				if spin[row+1][reel][2] == "scatter" then
					t[#t+1] = ":0,"..(row*def.constants.reelsymsizey).."="
							..def.constants.reelunderlightpref..(row+1)..".png"
				end
			end
			if #t > 0 then
				underlights[reel] = table.concat(t, ":")
			end
		end
	elseif state == "bonus_win" and allwins.bonus.count > 0 then
		for reel = 1, def.constants.numreels do
			local t = {}
			for row = 0, 2 do
				if spin[row+1][reel][2] == "bonus" then
					t[#t+1] = ":0,"..(row*def.constants.reelsymsizey).."="
							..def.constants.reelunderlightpref..(row+1)..".png"
				end
			end
			if #t > 0 then
				underlights[reel] = table.concat(t, ":")
			end
		end
	end

	local statenum = tonumber(string.sub(state, (string.find(state, "stopping") and 16 or 15)))
	if string.find(state, "spinning_fast_") then
		local t = {}
		for i = 0, def.constants.numreels-1 do
			local rs = calcrp(def, spin, i, statenum) * -def.constants.reelsymsizey
			t[i+1] = "image["..((i*def.constants.reelspc+1)*horizscale-hanchor)..
				def.constants.reelcombinepref..
				":0,"..rs.."="..def.constants.symbolsfast..
				def.constants.reelshadowimg
		end
		reels = table.concat(t)
	elseif string.find(state, "spinning_medm_") then
		local t = {}
		for i = 0, def.constants.numreels-1 do
			local rs = calcrp(def, spin, i, statenum) * -def.constants.reelsymsizey
			t[i+1] = "image["..((i*def.constants.reelspc+1)*horizscale-hanchor)..
				def.constants.reelcombinepref..
				":0,"..rs.."="..def.constants.symbolsmedium..
				def.constants.reelshadowimg
		end
		reels = table.concat(t)
	elseif string.find(state, "spinning_slow_") then
		local t = {}
		for i = 0, def.constants.numreels-1 do
			local rs = calcrp(def, spin, i, statenum) * -def.constants.reelsymsizey
			t[i+1] = "image["..((i*def.constants.reelspc+1)*horizscale-hanchor)..
				def.constants.reelcombinepref..
				":0,"..rs.."="..def.constants.symbolsslow..
				def.constants.reelshadowimg
		end
		reels = table.concat(t)
	elseif string.find(state, "reels_stopping_") then
		local t = {}
		for i = 0, def.constants.numreels-1 do
			if i > ((statenum-def.constants.slow_stop_cutover-1)/def.inter_reel_steps) then
				local rs = calcrp(def, spin, i, statenum) * -def.constants.reelsymsizey
				t[i+1] = "image["..((i*def.constants.reelspc+1)*horizscale-hanchor)..
					def.constants.reelcombinepref..
					":0,"..rs.."="..def.constants.symbolsslow..
					def.constants.reelshadowimg
			else
				local rs = (spin[2][i+1][1]-1) * -def.constants.reelsymsizey
				t[i+1] = "image["..((i*def.constants.reelspc+1)*horizscale-hanchor)..
					def.constants.reelcombinepref..
					underlights[i+1]..":0,"..rs.."="..def.constants.symbolsstopped..
					def.constants.reelshadowimg
			end
		end
		reels = table.concat(t)
	elseif state == "stopped" or state == "start" or string.find(state, "win") then
		local t = {}
		for i = 0, def.constants.numreels-1 do
			local rs = (spin[2][i+1][1]-1) * -def.constants.reelsymsizey
			t[i+1] = "image["..((i*def.constants.reelspc+1)*horizscale-hanchor)..
				def.constants.reelcombinepref..
				underlights[i+1]..":0,"..rs.."="..def.constants.symbolsstopped..
				def.constants.reelshadowimg
		end
		reels = table.concat(t)
	end

	if not showlines then
		if string.find(state, "win_") then
			local w = string.sub(state, 5)
			local linewin = allwins[tonumber(w)].payline
			lines = def.constants.mainpref..def.constants.overlaylinepref..linewin..".png]"
		end
	else
		local t = {}
		for i = 1, maxlines do
			t[i] = def.constants.mainpref..def.constants.overlaylinepref..i..".png]"
		end
		lines = table.concat(t)
	end

	local t = {}
	if state == "scatter_win" and allwins.scatter.count > 0 then
		for i,pos in ipairs(allwins.scatter.pos) do
 			t[i] = "image["..(((pos[1]-1)*def.constants.reelspc+def.constants.highlightboxoffsx)*horizscale-hanchor)..","..
				(((pos[2]-1)*(def.geometry.reel_sizey/3)+def.constants.highlightboxoffsy)*vertscale-vanchor)..";"..
				def.constants.scatterhlimg
		end
		scatters = table.concat(t)
	end

	local t = {}
	if state == "bonus_win" and allwins.bonus.count > 0 then
		for i,pos in ipairs(allwins.bonus.pos) do
 			t[i] = "image["..(((pos[1]-1)*def.constants.reelspc+def.constants.highlightboxoffsx)*horizscale-hanchor)..","..
				(((pos[2]-1)*(def.geometry.reel_sizey/3)+def.constants.highlightboxoffsy)*vertscale-vanchor)..";"..
				def.constants.bonushlimg
		end
		bonuses = table.concat(t)
	end

-- all the stuff that is shown in the lower section's "screen"

	local posx = def.constants.screenposx + def.geometry.label_medium_sizex * horizscale
	local posy2 = def.constants.screenposy + def.geometry.screen_line_height * vertscale
	local tb = maxlines*linebet
	local dgszx = def.geometry.digit_glyph_sizex*0.75

	local bal = def.constants.lscrnpref..def.constants.lscrnypos1..def.constants.medlblsz1..def.constants.ballabelimg..
		minislots.print_number(def,
			balance,
			posx,
			def.constants.screenposy,
			dgszx,
			def.geometry.screen_line_height,
			true)

	local betwin = def.constants.lscrnpref..def.constants.lscrnypos2..def.constants.medlblsz1..def.constants.betlabelimg..
		minislots.print_number(def,
			tb,
			posx,
			posy2,
			dgszx,
			def.geometry.screen_line_height,
			true)

	if string.find(state, "win") and allwins.total > 0 then
		-- switch to 3-line mode

		local tblen = string.len(tostring(tb))

		betwin = def.constants.lscrnpref..def.constants.lscrnypos2..def.constants.medlblsz2..def.constants.betlabelimg..
			minislots.print_number(def,
				tb,
				posx,
				posy2,
				def.constants.digitmed,
				def.constants.screenlnht2,
				true)..

			"image["..(def.constants.screenposx + (def.geometry.label_medium_sizex
				+ def.constants.digitmed * (tblen+2.3333)) * horizscale)..
			def.constants.lscrnypos2..def.constants.medlblsz2..def.constants.winlabelimg..

			minislots.print_number(def,
				allwins.total,
				def.constants.screenposx + (def.geometry.label_medium_sizex*2
					+ def.constants.digitmed * (tblen+2.3333)) * horizscale,
				posy2,
				def.constants.digitmed,
				def.constants.screenlnht2,
				true)

		if state == "scatter_win" then

			betwin = betwin..def.constants.lscrnpref..def.constants.lscrnypos3..def.constants.scatterwinlabelimg..
				minislots.print_number(def,
					allwins.scatter.count * def.scatter_value * linebet,
					def.constants.screenposx + def.geometry.scatter_win_label_sizex * horizscale,
					def.constants.posy3,
					def.constants.digitsm,
					def.constants.screenlnht3,
					true)
		elseif state == "bonus_win" then
			if allwins.bonus.value > -1 then

				betwin = betwin..def.constants.lscrnpref..def.constants.lscrnypos3..def.constants.bonuswinlabelimg..
					minislots.print_number(def,
						allwins.bonus.value,
						def.constants.screenposx + def.geometry.bonus_win_label_sizex * horizscale,
						def.constants.posy3,
						def.constants.digitsm,
						def.constants.screenlnht3,
						true)
			end
		else
			local w = string.sub(state, 5)
			local lwlen = string.len(w)
			local s = tonumber(w)
			local lwn = allwins[s].payline

			betwin = betwin..def.constants.lscrnpref..def.constants.lscrnypos3..def.constants.lnwinlblsz..
				def.constants.linewinlabelimg..
				"image["..(
					def.constants.screenposx
					+ (def.geometry.line_win_label_sizex
					+ def.constants.ln3dig) * horizscale)..
				def.constants.lscrnypos3..def.constants.parenlblsz..def.constants.lparenimg..

				minislots.print_number(def,
					lwn,
					def.constants.screenposx
						+ (def.geometry.line_win_label_sizex
						+ def.constants.ln3dig
						+ def.constants.parensize) * horizscale,
					def.constants.posy3,
					def.constants.digitsm,
					def.constants.screenlnht3,
					false)..

				"image["..(
						def.constants.screenposx
						+ (def.geometry.line_win_label_sizex
						+ def.constants.ln3dig
						+ def.constants.parensize
						+ def.constants.digitsm * lwlen) * horizscale)..
				def.constants.lscrnypos3..def.constants.parenlblsz..def.constants.rparenimg..

				"image["..(
						def.constants.screenposx
						+ (def.geometry.line_win_label_sizex
						+ def.constants.ln3dig
						+ def.constants.parensize*2 -- i.e. two colon/paren spaces' worth
						+ def.constants.digitsm * lwlen) * horizscale)..
				def.constants.lscrnypos3..def.constants.parenlblsz..def.constants.colonimg..

				minislots.print_number(def,
					allwins[s].value*linebet,
					def.constants.screenposx
						+ (def.geometry.line_win_label_sizex
						+ def.constants.digitsm  -- that is, two separate 1/2 spaces' worth
						+ def.constants.parensize*3 -- i.e. three colon/paren spaces' worth
						+ def.constants.digitsm * lwlen) * horizscale,
					def.constants.posy3,
					def.constants.digitsm,
					def.constants.screenlnht3,
					true)
		end
	end

	local onoff
	local linesbetbuttons = {}
	for i,b in ipairs(def.linebuttons) do
		onoff = "off"
		if b*linebet > balance or string.find(state, "spinning") or string.find(state, "reels_stopping_") then onoff = "dis"
		elseif maxlines == tonumber(b) then onoff = "on"
		end
		linesbetbuttons[#linesbetbuttons+1] = def.constants.buttons_n_lines[b][onoff]
	end

	onoff = "off"
	for i,b in ipairs(def.betbuttons) do
		onoff = "off"
		if b*maxlines > balance or string.find(state, "spinning") or string.find(state, "reels_stopping_") then onoff = "dis"
		elseif linebet == tonumber(b) then onoff = "on"
		end
		linesbetbuttons[#linesbetbuttons+1] = def.constants.buttons_bet_n[b][onoff]
	end

	local spincashoutbuttons = ""
	if not (string.find(state, "spinning") or string.find(state, "reels_stopping_")) then
		if balance > 0  then
			spincashoutbuttons = def.constants.buttonspin..def.constants.buttoncashout
		else
			spincashoutbuttons = def.constants.buttonspin_dis..def.constants.buttonquit
		end
	else
		spincashoutbuttons = def.constants.buttonspin_dis..def.constants.buttoncashout_dis
	end

	local upper_screen
	if not last_cashout then
		upper_screen =
			def.constants.behindreels..
			reels..
			def.constants.overlay_upper..
			scatters..
			bonuses..
			def.constants.buttoncashslot
	else

		local posy = 5 - vanchor
		local words = minislots.number_to_words(last_cashout)
		local spwidth = 10

		local x = 0
		local cashoutlen = 0
		local chars = {}
		for i = #words, 1, -1 do
			if words[i][1] ~= "ZERO" then
				chars[#chars+1] = x..",0=minislots_number_"..string.lower(words[i][1])..".png"
				cashoutlen = cashoutlen + words[i][2]
			end
			x = x + words[i][2] + spwidth
		end
		cashoutlen = cashoutlen + (#words-1)*spwidth

		local wordswidth = cashoutlen < 300 and cashoutlen or 300
		local cashoutstr_pref = "image["..(def.constants.cashout_screen_ctrx - wordswidth*def.constants.cashout_screen_hposscale/2*horizscale)..","..(posy)..
							";"..(wordswidth*def.constants.cashout_screen_hposscale)..",0.25;"

		local cashoutstr = cashoutstr_pref..
					minetest.formspec_escape(
							"[combine:"..cashoutlen.."x16:"..table.concat(chars, ":")
					).."]"

		local scale = 0.5
		local posx = def.constants.cashout_screen_ctrx - (string.len(tostring(last_cashout))+1.3333)*scale*horizscale/2

		upper_screen =
			def.constants.cashoutbackground..
			def.constants.upperbezel..
			def.constants.cashoutticketimg..
			cashoutstr..
			minislots.print_number(def, last_cashout, posx, posy+0.35, scale, scale, true, "black")
	end

	return	def.constants.form_header..
			def.constants.overlay_lower..
			upper_screen..
			table.concat(linesbetbuttons)..
			spincashoutbuttons..
			lines..
			bal..
			betwin
end

function minislots.print_number(def, num, posx, posy, sizex, sizey, cur, color)
	local t = {}
	local sn = tostring(num)
	local len = string.len(sn)
	local colorize = "]"

	if color then
		colorize = minetest.formspec_escape("^[colorize:"..color..":255").."]"
	end

	for i = 1, len do
		t[i] = "image["..(posx + (i-1)*sizex * horizscale)..","..posy..";"..
				sizex..","..sizey..";"..def.constants.digits[string.sub(sn, i, i)]..colorize
	end

	if cur then
		t[#t+1] = "image["..(posx + (len*sizex+sizex/4) * horizscale)..","..posy..";"..
				(sizex*1.3333)..","..(sizey)..def.constants.curlabelimg..colorize
	end

	return table.concat(t)
end

function minislots.number_to_words(number)

	local numstr = "000"..tostring(number)
	local numlen = string.len(numstr)
	local words = {}

	local i = 1
	while i <= numlen do
		if (i+2)/3 == math.floor((i+2)/3) then -- it's a one's digit
			local num = words_numbers[tonumber(string.sub(numstr, -i-1, -i))]
			if not num then -- it's > 19
				words[#words+1] = words_numbers[tonumber(string.sub(numstr, -i, -i))]
				words[#words+1] = words_tens[tonumber(string.sub(numstr, -i-1, -i-1))]
			else
				words[#words+1] = num
			end
			i = i + 2 -- skip over the ten's place, since we already handled it.
		elseif i/3 == math.floor(i/3) then -- it's a hundred's digit
			local h = string.sub(numstr, -i, -i)
			if h ~= "0" then -- we should only print "hundred" if the hundreds place is non-zero
				words[#words+1] = words_magnitudes[1]
				words[#words+1] = words_numbers[tonumber(h)]
			end
			i = i + 1
		end

		if tonumber(string.sub(numstr, -i-2, -i)) ~= 0 then -- the magnitude is non-zero
			if i == 4 then
				words[#words+1] = words_magnitudes[2] -- thousand
			elseif i == 7 then
				words[#words+1] = words_magnitudes[3] -- million
			end
		end
	end
	return words
end

function minislots.generate_cashslot_form(def, pos, balance)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,7]"..
		"background[-0.2,-0.25;8.4,7.74;"..def.constants.cashslotscrnbg.."]"..
		"image_button_exit[7.55,-0.1;0.55,0.5;"..def.constants.button_cslot_close..";cslotclose;]"..
		"list[nodemeta:".. spos .. ";main;3.5,1;1,1;]"..
		"label[2.5,-0.25;Insert money into the space below.]"..
		"label[2.2,0;When you're done, close this screen, then]"..
		"label[2.2,0.25;go back to the machine to continue playing.]"..
		"label[2.5,0.5;The machine's balance is: "..balance.." Mg]"..
		"image["..def.geometry.cash_slot_cin_posx..","..def.geometry.cash_slot_cin_posy..";"..
		def.geometry.cash_slot_sizex..","..def.geometry.cash_slot_sizey..";"..
		def.constants.basename.."cash_slot.png]"..
		"list[current_player;main;0,3.28;8,4;]"..
		"listring[]"
	return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.cslotclose and formname == "minislots:cash_intake" then
		minetest.close_formspec(player:get_player_name(), formname)
	end
end)

print("[Minislots] Loaded!")
