return {
    descriptions = {
        stocking_present = {
            Jogla_stocking_e_magic = {
                name = {
                    'M.A.G.I.C Cell',
                    '{s:0.7}Manufacturable Artificially Generated Induced Crystal'
                },
                text = {
                    {
                        'Stores {C:attention}half{} the base amount of {C:mult}Mult{}',
                        'as {X:mult,C:white}XMult{} of each played hand',
                    },
                    {
                        '{C:attention}Use{} it before playing a hand to load and',
                        'release {C:attention}one fifth{} of the stored amount',
                        '{C:inactive}(Can be used multiple times in a row){}',
                        '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult stored){}',
                        '{C:inactive}(Currently {C:attention}#3#%{} {X:mult,C:white}X#2#{C:inactive} Mult loaded){}',
                    },
                }
            },
            Jogla_stocking_two = {
                name = 'Card suffler',
                text = {
                    'Holds 10 cards',
                    'Use to draw 1 random card',
                    'Replenishes after boss blind defeated'
                }
            },
            Jogla_stocking_three = {
                name = 'Magnet',
                text = {
                    'Swaps Chips and Mult.',
                    'Use to change trigger',
                    'before scoring, before hand, before jokers, after jokers'
                }
            },
            Jogla_stocking_four = {
                name = 'Tags',
                text = {
                    'Gives 2 random tags after',
                    'boss blind defeated'
                }
            },
            Jogla_stocking_five = {
                name = '?',
                text = {
                }
            },
        },
        stocking_wrapped_present = {
            Jogla_stocking_present = {
                name = '{V:1}\'Encased\' Present',
                text = {
                    '_/  V  /\\ \\',
                    '\\   /\\  \\ \\/'
                }
            },
        }
    }
}
