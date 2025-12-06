-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'haya'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
	key = display_name .. '_presents',
	path = 'haya_presents.png',
	px = 71,
	py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
	name = display_name, -- DO NOT CHANGE

	-- Replace '000000' with your own hex code
	-- Used to colour your name and some particles when opening your present
	colour = lighten(HEX('515aa8'), 0.3)
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
	developer = display_name, -- DO NOT CHANGE

	pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
	-- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

	-- Your present will be given an automatically generated name and description. If you want to customise it you can, though we recommend keeping the {V:1} in the name
	-- You are encouraged to use the localization file for your name and description, this is here as an example
	-- loc_txt = {
	--     name = '{V:1}Present',
	--     text = {
	--         '  {C:inactive}What could be inside?  ',
	--         '{C:inactive}Open me to find out!'
	--     }
	-- },
})

-- Irisu's Bat
StockingStuffer.Present({
	developer = display_name,
	key = "irisu_bat",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 56, h = 74 },
	config = { extra = { disabled = false } },
	disable_use_animation = true, -- We manually move the various things ourselves so disable thissss
	can_use = function(self, card)
		return G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 and G.STATE ~= G.STATES.SELECTING_HAND and
			not booster_obj and
			not G.CONTROLLER.locked and
			not card.ability.extra.disabled
	end,
	calculate = function(self, card, context)
		if context.ante_end and card.ability.extra.disabled then
			card.ability.extra.disabled = false
			return {
				message = localize('k_reset')
			}
		end
	end,
	use = function(self, card, area, copier)
		-- Delightfully assume we are using this in the context of using so move jokers into view
		G.FUNCS.toggle_jokers_presents()

		delay(0.7 * 2)

		local c = G.jokers.highlighted[1]
		draw_card(G.jokers, G.play, nil, nil, nil, G.jokers.highlighted[1])
		card.ability.extra.disabled = true

		local prev_state = G.TAROT_INTERRUPT

		-- Offset these manually
		if G.shop and not G.shop.alignment.offset.py then
			G.shop.alignment.offset.py = G.shop.alignment.offset.y
			G.shop.alignment.offset.y = G.ROOM.T.y + 29
		end
		if G.blind_select and not G.blind_select.alignment.offset.py then
			G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
			G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
		end
		if G.round_eval and not G.round_eval.alignment.offset.py then
			G.round_eval.alignment.offset.py = G.round_eval.alignment.offset.y
			G.round_eval.alignment.offset.y = G.ROOM.T.y + 29
		end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.7,
			func = function()
				G.FUNCS.toggle_jokers_presents()
				return true
			end
		})

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.7,
			func = function()
				card:juice_up(0.8, 0.8)
				c:start_dissolve({ G.C.RED })
				play_sound('slice1', 0.96 + math.random() * 0.08)
				_ = SMODS.calculate_effect(
					{
						message = localize('haya_irisu_destroy_' .. math.random(1, 3)),
						instant = true,
						no_juice = true,
						colour =
							G.C.RED
					}, card)
				return true
			end
		})

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			blocking = false,
			--blockable = false,
			delay = 2,
			func = function()
				--if not G.STATE_COMPLETE and not G.OVERLAY_MENU then
				local card = SMODS.add_card({ area = G.play, key = 'p_stocking_present_select', skip_materialize = true })
				G.FUNCS.use_card({ config = { ref_table = card } })
				G.TAROT_INTERRUPT = prev_state
				G.GAME.PACK_INTERRUPT = prev_state
				-- Circumvent cost lmao
				ease_dollars(card.config.center.cost, true)
				ease_value(G.HUD.alignment.offset, 'x', -7, nil, nil, nil, 1, 'elastic')
				ease_value(G.christmas_tree.alignment.offset, 'x', 12, nil, nil, nil, 1, 'elastic')
				return true
				--end
			end
		}))

		delay(1.5)
	end,
	keep_on_use = function(self, card)
		return true
	end
})

StockingStuffer.Present({
	developer = display_name,
	key = "ssr_revival_skill",
	pos = { x = 2, y = 0 },
	pixel_size = { w = 38, h = 48 },
	display_size = { w = 38 * 1.25, h = 48 * 1.25 },
	config = { extra = { ante = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.ante }
		}
	end,
	draw = function(self, card, layer)
		---@type balatro.Sprite
		local spr = card.children.center
		spr:draw_shader("booster", nil, card.ARGS.send_to_shader)
	end,
	update = function(self, card, dt)
		local ofs = math.sin(G.TIMERS.REAL / 1.5)
		---@type balatro.Card|table
		local c = card
		---@type balatro.Sprite|table
		local spr = card.children.center
		spr.og_W = spr.og_W or spr.T.w
		spr.T.w = math.abs(spr.og_W * ofs)
	end
})

-- Some of the bullet types from Snap the Sentinel
local EFFECT_RAPID = 1
local EFFECT_SPREAD = 2
local EFFECT_FLAME = 3
local EFFECT_HOMING = 4
local EFFECT_MAX = EFFECT_HOMING

local effects = { "rapid", "spread", "flame", "homing" }


local function mergeTables(dest, source)
	if dest == nil then return source end
	for k, v in pairs(source) do
		if dest[k] == nil then
			dest[k] = v
		else
			if type(v) ~= "table" or type(dest[k]) ~= "table" then
				dest[k] = v
			else
				dest[k] = mergeTables(dest[k], v)
			end
		end
	end
	return dest
end

for _, type in ipairs(effects) do
	SMODS.Sound {
		key = "haya_snap_" .. type,
		path = "haya/power_" .. type .. ".ogg",
	}
	SMODS.Sound {
		key = "haya_snap_revolver_" .. type,
		path = "haya/revolver" .. (type:gsub("^%l", string.upper)) .. ".ogg",
	}
end
SMODS.Sound {
	key = "haya_snap_revolver",
	path = "haya/revolver.ogg",
}

-- Chameleon Blaster
StockingStuffer.Present({
	developer = display_name,
	key = "chameleon_blaster",
	pos = { x = 3, y = 0 },
	pixel_size = { w = 71, h = 84 },
	config = { extra = { count = 7, remaining = 0, remove = false } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.count, card.ability.extra.remaining }
		}
	end,
	---@param self table
	---@param card Card|table
	---@param context CalcContext|table
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round and StockingStuffer.second_calculation then
			card.ability.extra.remaining = card.ability.extra.remaining + 1
			if card.ability.extra.remaining >= 7 then
				card.ability.extra.remaining = 0
				local effect = pseudorandom(G.GAME.round_resets.ante .. "_chameleonblaster_effect", EFFECT_RAPID,
					EFFECT_FLAME)
				local ret = {
					message = localize('haya_snap_' .. effects[effect]),
					sound = 'stocking_haya_snap_' .. effects[effect],
					delay = 0.6 * G.SETTINGS.GAMESPEED, -- Allocate enough time for the soundbyte to play
					pitch = 1,
					extra = {},
					message_card = card,
				}
				if effect == EFFECT_RAPID then -- Rapid Fire
					local r = ret.extra
					local ogr = r
					for _, area in ipairs({ "play", "hand", "jokers", "consumeables", "stocking_present" }) do
						for k, v in ipairs(G[area].cards) do
							r.mult = 3
							r.card = card
							r.message_card = v
							r.extra = {}
							r.mult_message = {
								message = "Shoot!",
								colour = G.C.RED,
								sound = "stocking_haya_snap_revolver_rapid",
								delay = 0.075 / G.SETTINGS.GAMESPEED
							}
							r = r.extra
						end
					end
					ret.extra = ogr
				elseif effect == EFFECT_SPREAD then -- Spread Shot
					local r = ret.extra
					local ogr = r
					local count = 1
					for _, area in ipairs({ "hand" }) do
						for k, v in ipairs(G[area].cards) do
							count = count + 0.25
							r.message = "x" .. number_format(count)
							r.card = card
							r.message_card = v
							r.extra = {}
							r.sound = "stocking_haya_snap_revolver"
							r = r.extra
						end
					end
					r.xmult = count
					r.xmult_message = {
						message = localize({ type = "variable", key = 'a_xmult', vars = { count } }),
						colour = G.C.RED,
						sound = "stocking_haya_snap_revolver_spread",
						pitch = 1
					}
					r.message_card = card
					r.card = card
					ret.extra = ogr
				elseif effect == EFFECT_FLAME then -- Flamethrower
					local r = ret.extra
					local ogr = r
					for k, v in ipairs(G.play.cards) do
						r.card = card
						r.message_card = v
						r.extra = {}
						r.xmult = 1.5
						r.xmult_message = {
							message = localize({ type = "variable", key = 'a_xmult', vars = { 1.5 } }),
							colour = G.C.RED,
							sound = "stocking_haya_snap_revolver_flame",
							pitch = 1
						}
						r = r.extra
					end
					card.ability.extra.remove = true
					ret.extra = ogr
				elseif effect == EFFECT_HOMING then -- Homing Gun

				end
				return ret
			else
				return {
					message = "" .. card.ability.extra.remaining .. "/" .. card.ability.extra.count,
					message_card = card,
				}
			end
		end
		if context.after and card.ability.extra.remove then
			G.E_MANAGER:add_event(Event {
				func = function()
					SMODS.destroy_cards(G.play.cards)
					return true
				end
			})
			SMODS.calculate_context({ remove_playing_cards = true, removed = G.play.cards })
			card.ability.extra.remove = false
		end
	end
})
