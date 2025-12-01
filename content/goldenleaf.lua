
loc_colour()
G.ARGS.LOC_COLOURS.gl_pink = HEX("e462d3")
G.ARGS.LOC_COLOURS.gl_black = HEX("57638c")

SMODS.Font {
  key = "emoji",
  path = "NotoEmoji-Bold.ttf"
}

local display_name = '[REDACTED]Autumn'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'present_gl.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX("e462d3")
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 },
})

local function random_grinch()
    local g = math.floor(pseudorandom("pingas") + 0.5)
    local options = {
        [0] = "Saint",
        [1] = "Grinch",
    }
    return options[g]
end

StockingStuffer.Present({
    developer = display_name,
    key = 'ultimatum',
    pos = { x = 1, y = 0 },
    soul_pos = { x = 2, y = 0 },
    config = {
        extra = {
            currentchoice = "Grinch",
            rerollprice = 1,
            mult = 15
        }
    },
    can_use = function(self, card)
        return G.GAME.dollars > card.ability.extra.rerollprice
    end,
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		local vars = {
            hpt.mult,
            hpt.rerollprice
		}            
        local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = hpt.currentchoice == "Grinch" and G.C.GREEN or HEX("e462d3"), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('ultimatum_'..string.lower(hpt.currentchoice)) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
		return { vars = vars, main_end = main_end}
	end,
    use = function(self, card, area, copier) 
        local hpt = card.ability.extra
        hpt.currentchoice = random_grinch()
        ease_dollars(-hpt.rerollprice)
        hpt.rerollprice = hpt.rerollprice + 1
        card_eval_status_text(card, 'extra', nil, nil, nil,
		{ message = localize('ultimatum_'..string.lower(hpt.currentchoice)).."!", colour = hpt.currentchoice == "Grinch" and G.C.GREEN or HEX("e462d3")})
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        local hpt = card.ability.extra
		if context.setting_blind and StockingStuffer.first_calculation then
            hpt.stupid_fuck_ass_variable_because_end_of_round_is_stupid = nil
        end
        if context.end_of_round and StockingStuffer.first_calculation then
            if not hpt.stupid_fuck_ass_variable_because_end_of_round_is_stupid then
                hpt.currentchoice = random_grinch()
                hpt.rerollprice = math.max(hpt.rerollprice - 1, 1)
            card_eval_status_text(card, 'extra', nil, nil, nil,
		    { message = localize('ultimatum_'..string.lower(hpt.currentchoice)).."!", colour = hpt.currentchoice == "Grinch" and G.C.GREEN or HEX("e462d3")})
                hpt.stupid_fuck_ass_variable_because_end_of_round_is_stupid = true
            end
        end
        if context.joker_main and StockingStuffer.first_calculation then
            return { mult = hpt.mult * (hpt.currentchoice == "Grinch" and -1 or 1)}
        end
    end
})

local game_upd8_hook = Game.update
function Game:update(dt, ...)
    game_upd8_hook(self, dt, ...)
    if G and G.stocking_present and G.stocking_present.cards then
        local c_area = G.stocking_present.cards
        for k, v in ipairs(c_area) do
            if c_area[k + 1] and c_area[k + 1].config.center.key == "[REDACTED]Autumn_stocking_discard_bin" then
                SMODS.debuff_card(v, true, "discard_bin")
            else
                SMODS.debuff_card(v, false, "discard_bin")
            end
        end
    end
end
StockingStuffer.Present({
    developer = display_name,
    key = 'discard_bin',
    pos = { x = 3, y = 0 },
})
