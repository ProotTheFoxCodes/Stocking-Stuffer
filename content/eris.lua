-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Eris'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
-- should be the default for all presents created
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('C09ED9')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    pos = { x = 0, y = 0 },
    --localization optional
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'evil_bomb', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 0, y = 0 },
    config = { extra = { max = 6, count = 0 }},
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.max, card.ability.extra.count }}
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        if context.after then
            if card.ability.extra.count >= card.ability.extra.max then
                card.ability.extra.count = 0
            else
                card.ability.extra.count = card.ability.extra.count
            end
        end
        if context.destroy_card and card.ability.extra.count >= card.ability.extra.max then
            return { remove = true }
        end
    end
})
