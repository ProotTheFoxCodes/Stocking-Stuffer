return {
    descriptions = {
        stocking_present = {
            ["LFMoth_stocking_rent"] = {
                name = 'How I keep the holiday spirits up in my neighborhood',
                text = {
                    'Earn {C:money}$#1#{} at',
                    'the end of round',
                    'for each {C:attention}Coal{}',
                    'you have'
                }
            },
            ["LFMoth_stocking_giftapult"] = {
                name = 'Giftapult',
                text = {
                    'Creates a free {C:attention}present',
                    'every ante'
                }
            },
            ["LFMoth_stocking_underwear"] = {
                name = 'Underwear',
                text = {
                    '{C:white,X:red}X#1#{} Mult when',
                        'scoring is complete',
                        'if a {C:attention}Pair{} is played',
                        '{stocking}after'
                }
            }
        },
        -- stocking_wrapped_present = {
        --     template_stocking_present = {
        --         name = '{V:1}Present',
        --         text = {
        --             '  {C:inactive}What could be inside?  ',
        --             '{C:inactive}Open me to find out!'
        --         }
        --     },
        -- }
    }
}
