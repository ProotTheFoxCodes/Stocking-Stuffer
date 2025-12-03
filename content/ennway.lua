local display_name = 'ENNWAY'

SMODS.Atlas({
    key = display_name..'_presents',
    path = display_name..'_presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    atlas_table = 'ANIMATION_ATLAS',
    key = 'ennway_rotoscoped_dancing_robot',
    path = 'ennway_rotoscoped_dancing_robot.png',
    px = 49,
    py = 51,
    frames = 22,
})

SMODS.Sound({
    key = 'ennway_robot_sfx',
    path = 'ennway_robot_sfx.ogg',
})

-- Developer ENNWAY!
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = HEX('009FAE')
})

-- Wrapped Present
StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 }
})

-- Localized Black Hole
StockingStuffer.Present({
    developer = display_name,

    config = {lastPlayedHand = "None", upgrades = 3},

    key = 'localizedBlackHole',
    pos = { x = 1, y = 0 },

    can_use = function(self, card)
        return card.ability.lastPlayedHand ~= "None"
    end,
    use = function(self, card, area, copier) 
        SMODS.smart_level_up_hand(card, card.ability.lastPlayedHand, false, 3)
    end,
    keep_on_use = function(self, card)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.lastPlayedHand, card.ability.upgrades },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.lastPlayedHand = context.scoring_name
        end
    end
})

-- 12-Month Grok Subscription
StockingStuffer.Present({
    developer = display_name,

    key = 'twelveMonthGrok',
    pos = { x = 2, y = 0 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier) 
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            create_rotoscoped_dancing_robot()
            return true
        end
        }))
    end,
    keep_on_use = function(self, card)
        return false
    end
})

-- ENNWAY's Rotoscoped Dancing Robot
function create_rotoscoped_dancing_robot()
    local tree_sprite = AnimatedSprite(0, 0, 2, 2, G.ANIMATION_ATLAS['stocking_ennway_rotoscoped_dancing_robot'])

    G.GAME.ennways_rotoscoped_dancing_robot = UIBox{
        definition = {
            n=G.UIT.ROOT, config = {align = "bl", padding = 0.0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config = {align = "bl", padding= 0.0, colour = G.C.CLEAR, r=0.1}, nodes={
                {n=G.UIT.O, config = {object = tree_sprite, hover = true, juice = true, shadow = true}}
            }}
        }},
        config = {align=('cm'), offset = {x=-9,y=6},major = G.ROOM_ATTACH}
    };

    play_sound('stocking_ennway_robot_sfx')

    return G.GAME.ennways_rotoscoped_dancing_robot
end

-- Cool Emoji
local ennway_ChargeColor = HEX("8F71A3");
StockingStuffer.Present({
    developer = display_name,

    key = 'coolEmoji',
    pos = { x = 3, y = 0 },
    config = { chargegain = 2, charge = 0, currentchips = 0 },
    can_use = function(self, card)
        return card.ability.charge > 0 and G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.GAME.chips = G.GAME.chips + card.ability.currentchips
        card.ability.charge = 0
        card.ability.currentchips = 0
        G.E_MANAGER:add_event(Event({
            delay = 0.2,
            func = function()
                if G.GAME.blind.chips < G.GAME.chips then
                    end_round()
                end
                return true
            end
        }))
    end,
    keep_on_use = function(self, card)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.charge,
                card.ability.currentchips,
                card.ability.chargegain,
                colours = { 
                    ennway_ChargeColor
                }
            }
        }
    end,
    calculate = function(self, card, context)
        card.ability.currentchips = math.floor(G.GAME.blind.chips * (card.ability.charge / 100))
        if context.individual and context.cardarea == G.play and not context.end_of_round and StockingStuffer.first_calculation then
            if context.other_card:is_face() then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.charge = card.ability.charge + card.ability.chargegain
                        return true
                    end
                }))
                return {
                    message = "+"..card.ability.chargegain.."% Charge",
                    colour = ennway_ChargeColor
                }
            end
        end
    end
})

-- Lapis Lazuli
StockingStuffer.Present({
    developer = display_name,

    config = { extra = { minusChips = 20, Xchips = 2 } },
    key = 'lapisLazuli',
    pos = { x = 4, y = 0 },
    can_use = function(self, card)
        return false
    end,
    use = function(self, card, area, copier) 
    end,
    keep_on_use = function(self, card)
        
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation then
                return {
                    chips = -card.ability.extra.minusChips
                }
            end
            if StockingStuffer.second_calculation then
                return {
                    x_chips = card.ability.extra.Xchips
                }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.minusChips, card.ability.extra.Xchips },
        }
    end,
})