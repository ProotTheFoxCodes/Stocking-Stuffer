return {
    descriptions = {
        stocking_present = {
            ["Spectral Pack_stocking_rapier"] = {
                name = "Soldier's Rapier",
                text = {}
            },
            ["Spectral Pack_stocking_skull"] = {
                name = "Jester's Skull",
                text = { {
                    "{C:green}#1# in #2#{} chance to {C:red}discard",
                    "each card held in hand",
                    "{stocking}before"
                }, {
                    "{X:mult,C:white}X#3#{} Mult per card",
                    "{C:red}discarded{} by this effect",
                    "{stocking}after"
                } }
            },
            ["Spectral Pack_stocking_chalice"] = {
                name = "Cupbearer's Chalice",
                text = { {
                    "{C:green}#1# in #2#{} chance to apply",
                    "{C:dark_edition}Negative{} to a random consumable",
                    "{stocking}before"
                }, {
                    "Fills your consumable slots",
                    "with random consumables",
                    "{C:inactive}(Can create duplicates)",
                    "{stocking}after"
                } }
            },
            ["Spectral Pack_stocking_knife"] = {
                name = "Actor's Knife",
                text = {}
            }
        }
    }
}
