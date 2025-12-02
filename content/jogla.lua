-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Jogla'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = 'stocking_'..display_name..'_presents',
    path = display_name..'_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX(string.sub('#aaaaff',2,7))
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 },
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'e_magic', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            is_releasing = false,
            xmult = 4,
            release = 0,
            triggered = false
        }
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.xmult * (1 - card.ability.extra.release),
            1 + card.ability.extra.xmult * card.ability.extra.release,
            card.ability.extra.release * 100
        }}
    end,
    atlas = display_name..'_presents',
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return card.ability.extra.xmult > 0 and card.ability.extra.release < 0.9
    end,
    use = function(self, card, area, copier)
        card.ability.extra.release = card.ability.extra.release + 0.2
        card.ability.extra.is_releasing = true
        card.children.center:set_sprite_pos({x = 2, y = 0})
    end,
    keep_on_use = function(self, card)
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if card.ability.extra.is_releasing then
            if context.joker_main and StockingStuffer.second_calculation then
                return {
                    xmult = 1 + card.ability.extra.xmult * card.ability.extra.release
                }
            end
            if context.after and StockingStuffer.second_calculation then
                G.E_MANAGER:add_event(Event{
                    func = function ()
                    card.ability.extra.is_releasing = false
                    card.ability.extra.xmult = card.ability.extra.xmult * (1 - card.ability.extra.release)
                    card.ability.extra.release = 0
                    card.children.center:set_sprite_pos({x = 1, y = 0})
                    return true end
                })
            end
        else
            if context.before and not card.ability.extra.triggered and StockingStuffer.first_calculation then
                card.ability.extra.xmult = card.ability.extra.xmult + mult * 0.5
                card.ability.extra.triggered = true
            end
            if context.after then
                card.ability.extra.triggered = false
            end
        end
    end
})