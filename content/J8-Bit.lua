-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'J8-Bit'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = display_name .. '_presents.png',
    px = 69,
    py = 93
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('FDA757')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 },   -- position of present sprite on your atlas
    pixel_size = { w = 58, h = 66 },
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

local get_booster_bg_color = function(key)
    local bg_color = G.C.FILTER
    if string.find(key, "arcana") then
        bg_color = G.C.SECONDARY_SET.Tarot
    elseif string.find(key, "celestial") then
        bg_color = G.C.SECONDARY_SET.Planet
    elseif string.find(key, "ethereal") then
        bg_color = G.C.SECONDARY_SET.Spectral
    end
    return bg_color
end

-- Booster Box
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'booster_box',      -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    pixel_size = { w = 59, h = 53 },
    disable_use_animation = true,
    config = { extra = { saved_booster = nil } },
    loc_vars = function(self, info_queue, card)
        local main_end = nil
        if card.ability.extra.saved_booster ~= nil then
            --print(G.P_CENTERS[card.ability.extra.saved_booster])

            local loc_name = card.ability.extra.saved_booster
            loc_name = string.sub(loc_name, 1, string.len(loc_name) - string.find(string.reverse(loc_name), '_'))

            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = get_booster_bg_color(loc_name), r = 0.05, padding = 0.06 },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = ' ' .. localize({
                                            type = 'name_text',
                                            key = loc_name,
                                            set =
                                            'Other'
                                        }) .. ' ',
                                        colour = G.C.UI.TEXT_LIGHT,
                                        scale = 0.32 * 0.9
                                    }
                                },
                            }
                        }
                    }
                }
            }
        end
        return { main_end = main_end }
    end,
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return card.ability.extra.saved_booster and
            not (G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER)
    end,
    use = function(self, card, area, copier)
        local new_booster = card.ability.extra.saved_booster
        local box = card
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                local pack = SMODS.add_booster_to_shop(new_booster) --(context.card.config.center.key)
                pack.states.visible = nil
                pack.ability.j8mod_booster_copy = true
                pack.cost = pack.cost * 2
                G.E_MANAGER:add_event(Event({
                    delay = 0.25,
                    trigger = "after",
                    func = function()
                        pack:start_materialize()
                        box:juice_up()
                        return true
                    end
                }))
                return true
            end
        }))
        card.ability.extra.saved_booster = nil
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.open_booster and StockingStuffer.second_calculation and not context.card.ability.j8mod_booster_copy and not context.blueprint then
            --print("-PRINTING CENTER-")
            --print(context.card.config.center)
            card.ability.extra.saved_booster = context.card.config.center.key
            --local temp = G.P_CENTERS[card.ability.extra.saved_booster]
            --print("-PRINTING TEMP CENTER REFERENCE-")
            --print(temp)
            local loc_name = card.ability.extra.saved_booster
            loc_name = string.sub(loc_name, 1, string.len(loc_name) - string.find(string.reverse(loc_name), '_'))
            return {
                message = localize({
                    type = 'name_text',
                    key = loc_name,
                    set =
                    'Other'
                }) .. "!",
                colour = get_booster_bg_color(loc_name)
            }
        end
    end
})

-- Christmas Crack
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'christmas_crack',  -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 2, y = 0 },
    pixel_size = { w = 65, h = 85 },
    config = { extra = { xchips = 1, xchips_inc = 0.01, check_edition = "e_foil" } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.check_edition]
        return { vars = { card.ability.extra.xchips, card.ability.extra.xchips_inc, localize { type = 'name_text', key = card.ability.extra.check_edition, set = 'Edition' } } }
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.before and not context.blueprint and StockingStuffer.first_calculation then
            local foiled = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card.edition and scored_card.edition.key == card.ability.extra.check_edition and not scored_card.debuff and not scored_card.j8_present_cracked then
                    foiled[#foiled + 1] = scored_card
                    scored_card.j8_present_cracked = true
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.25,
                        func = function()
                            scored_card:set_edition(nil, true)
                            scored_card:juice_up()
                            scored_card.j8_present_cracked = nil
                            return true
                        end
                    }))
                end
            end

            if #foiled > 0 then
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_inc * #foiled
                return {
                    message = localize { type = 'variable', key = 'a_xchips', vars = { card.ability.extra.xchips } },
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main and StockingStuffer.second_calculation then
            return {
                xchips = card.ability.extra.xchips
            }
        end
    end
})

-- Label Maker
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'label_maker',      -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    pixel_size = { w = 57, h = 68 },

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier)
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

-- Water Cooler
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'water_cooler',     -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 5, y = 0 },
    pixel_size = { w = 51, h = 92 },

    config = { extra = { state = false } },
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card)
        if card.ability.extra.state == true then
            card.ability.extra.state = false
        else
            card.ability.extra.state = true
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                card.children.center:set_sprite_pos({ x = card.ability.extra.state and 4 or 5, y = 0 })
                return true
            end
        }))
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            key = card.ability.extra.state and 'J8-Bit_stocking_water_cooler_a' or
                'J8-Bit_stocking_water_cooler_b',
            vars = {}
        }
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.children.center:set_sprite_pos({ x = card.ability.extra.state and 4 or 5, y = 0 })
            card.loaded = false
        end
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

-- Tech X
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'tech_x',           -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 6, y = 0 },
    pixel_size = { w = 61, h = 45 },

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier)
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})
