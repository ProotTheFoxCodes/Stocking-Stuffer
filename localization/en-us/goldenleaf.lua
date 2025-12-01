return {
    misc = {
        dictionary = {
            ultimatum_grinch = 'Grinch',
            ultimatum_saint = 'Saint'
        }
    },
    descriptions = {
        stocking_present = {
            ["[REDACTED]Autumn_stocking_discard_bin"] = {
                name = 'Discard Bin',
                text = {
                    "{C:attention}Debuff",
                    "the present",
                    "to the left",
                }
            },
            ["[REDACTED]Autumn_stocking_ultimatum"] = {
                name = 'Ultimatum',
                text = {
                    {"Current {C:green}Grinchness:"},
                    {'{C:mult}+/-#1#{} Mult',
                    "based on if you",
                    "are a {C:attention}grinch{} or a {C:attention}saint",
                    '{stocking}before{}',},
                    {'Reroll {C:green}Grinchness',
                    'with a cost of {C:gold}$#2#',
                    '{C:inactive,s:0.7}(Price increases',
                    '{C:inactive,s:0.7}by 1 per roll)',
                    '{stocking}usable{}',},
                    {'{C:attention}At the end of round,',
                    'randomize {C:green}grinchness',
                    'and reduce {C:attention}reroll price{}',
                    'by {C:gold}$1'}
                }
            }
        },
        stocking_wrapped_present = {
            ["[REDACTED]Autumn_stocking_present"] = {
                name = '{V:1}Present',
                text = {
                    '{C:gl_pink,f:stocking_emoji}🍁{C:gl_pink}Some{C:gl_black}one {C:inactive}messed up',
                    '  {C:inactive}the paint on this present...  ',
                    '{C:inactive}Regardless,',
                    '{C:inactive}wont you open it?'
                }
            },
        }
    }
}
