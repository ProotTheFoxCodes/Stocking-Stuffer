local display_name = 'Mysthaps'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'mysthaps_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('f6bee1')
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 }, 
})

--[[ FAUST PLUSHIE ]]--
local function get_before_effect(card, other_card)
    local effects = {}
    if other_card:is_suit("Hearts") then effects[#effects+1] = {xmult = card.ability.extra.x_mult} end
    if other_card:is_suit("Diamonds") then effects[#effects+1] = {dollars = card.ability.extra.money_dia} end
    if other_card:is_suit("Spades") then effects[#effects+1] = {chips = card.ability.extra.chips} end
    if other_card:is_suit("Clubs") then effects[#effects+1] = {mult = card.ability.extra.mult} end
    return SMODS.merge_effects(effects)
end

StockingStuffer.Present({
    developer = display_name,
    key = 'faust_plushie',
    pos = { x = 1, y = 0 },
    pixel_size = { w = 50, h = 66 },
    config = {extra = {
        x_mult = 1.2, mult = 5, money_dia = 2, chips = 25,
        money_face = 3, 
    }},
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and G.hand.cards[1] and context.other_card == G.hand.cards[1] then
            if StockingStuffer.first_calculation then
                return get_before_effect(card, context.other_card)
            end

            if StockingStuffer.second_calculation then
                if context.other_card.base.id == 14 then return get_before_effect(card, context.other_card)
                elseif context.other_card.base.id >= 11 and context.other_card.base.id <= 13 then return {dollars = card.ability.extra.money_face}
                elseif context.other_card.base.id >= 2 and context.other_card.base.id <= 5 then SMODS.destroy_cards(context.other_card) end
            end
        end

        if context.mod_probability and StockingStuffer.second_calculation then
            if G.hand.cards[1] and G.hand.cards[1].base.id >= 6 and G.hand.cards[1].base.id <= 10 then
                return {numerator = context.numerator * 2}
            end
        end

        if context.after and StockingStuffer.second_calculation then
            if G.hand.cards[1] then
                local _card = G.hand.cards[1]
                G.E_MANAGER:add_event(Event({ func = function()
                    if _card and not _card.getting_sliced then 
                        G.hand:add_to_highlighted(_card, true)
                        G.FUNCS.discard_cards_from_highlighted(nil, true)
                        play_sound('card1', 1)
                    end
                return true end })) 
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        local colors = {G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.WHITE}
        if G.hand and G.hand.cards and G.hand.cards[1] then
            if G.hand.cards[1]:is_suit("Hearts") then colors[1] = G.C.UI.TEXT_DARK; colors[14] = G.C.MULT end
            if G.hand.cards[1]:is_suit("Diamonds") then colors[2] = G.C.MONEY end
            if G.hand.cards[1]:is_suit("Spades") then colors[3] = G.C.CHIPS; colors[4] = G.C.UI.TEXT_DARK end
            if G.hand.cards[1]:is_suit("Clubs") then colors[5] = G.C.MULT; colors[6] = G.C.UI.TEXT_DARK end
            if G.hand.cards[1].base.id == 14 then colors[7] = G.C.UI.TEXT_DARK end
            if G.hand.cards[1].base.id >= 11 and G.hand.cards[1].base.id <= 13 then colors[8] = G.C.MONEY end
            if G.hand.cards[1].base.id >= 6 and G.hand.cards[1].base.id <= 10 then colors[9] = G.C.FILTER; colors[10] = G.C.UI.TEXT_DARK; colors[11] = G.C.GREEN end
            if G.hand.cards[1].base.id >= 2 and G.hand.cards[1].base.id <= 5 then colors[12] = G.C.UI.TEXT_DARK; colors[13] = G.C.RED end
        end
        return {
            vars = {card.ability.extra.x_mult, card.ability.extra.money_dia, card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.money_face, colours = colors},
        }
    end
})

--[[ KITTY SOCKS ]]--
StockingStuffer.Present({
    developer = display_name, 
    key = 'kitty_socks',
    pos = { x = 2, y = 0 },
    pixel_size = { w = 71, h = 62 },
    config = {extra = {
        div = 1, used = false
    }},
    can_use = function(self, card)
        return (G.STATE == G.STATES.SHOP and not card.ability.extra.used)
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.used = true
        G.GAME.stocking_last_pack = -1e308
        if not SMODS.is_eternal(card, card) then card.ability.eternal = true end
        card.ability.extra.div = card.ability.extra.div * 2
        SMODS.calculate_effect({message = localize{type = 'variable', key = 'a_divmult', vars = {number_format(card.ability.extra.div)}}, colour = G.C.MULT}, card)
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.second_calculation and card.ability.extra.div > 1 then
            return {
                mult = -mult * ((card.ability.extra.div - 1) / card.ability.extra.div),
                remove_default_message = true,
                message = localize{type = 'variable', key = 'a_divmult', vars = {number_format(card.ability.extra.div)}},
                colour = G.C.MULT,
            }
        end

        if context.end_of_round and context.main_eval then
            card.ability.extra.used = false
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {number_format(card.ability.extra.div)}}
    end
})
