local display_name = 'ENNWAY'

-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
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

-- 12-Month Grok Subscription
StockingStuffer.Present({
    developer = display_name,

    config = {extra = {chips = 1}},

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