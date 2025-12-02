return {
    descriptions = {
        stocking_present = {
            BakersDozenBagels_stocking_GiftReceipt = {
                name = 'Gift Receipt',
                text = {
                    '{C:attention}Jokers{} and {C:attention}Consumables',
                    'sell for {C:money}$#1#{} more',
                    "if they {C:red}weren't bought"
                }
            },
            BakersDozenBagels_stocking_Origami = {
                name = 'Origami',
                text = {
                    {
                        '{C:white,X:mult}÷#1#{} Mult',
                        '{stocking}before'
                    },
                    {
                        '{C:white,X:mult}X#2#{} Mult',
                        '{stocking}after'
                    }
                }
            }
        },
        stocking_wrapped_present = {
            BakersDozenBagels_stocking_present = {
                name = '{V:1}Garish Envelope',
                text = {
                    '  {C:inactive}What could be inside?  ',
                    '{C:inactive}Open me to find out!'
                }
            },
        }
    }
}
