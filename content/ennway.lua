local display_name = 'ENNWAY!'

-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'ennway_presents.png',
    px = 71,
    py = 95
})

-- Developer ENNWAY!
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    colour = HEX('3A3397')
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
