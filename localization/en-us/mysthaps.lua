return {
    descriptions = {
        stocking_present = {
            Mysthaps_stocking_faust_plushie = {
                name = "Faust Plushie",
                text = {
                    {
                        "When hand is played, leftmost card",
                        "held in hand gives effects",
                        "based on its suit and rank:",
                    },
                    {
                        "{C:hearts}Hearts{}: {B:14,C:white}X#1#{V:1} Mult",
                        "{C:diamonds}Diamonds{}: {V:2}$#2#",
                        "{C:spades}Spades{}: {V:3}+#3# {V:4}chips",
                        "{C:clubs}Clubs{}: {V:5}+#4# {V:6}Mult",
                        "{stocking}before{}"
                    },
                    {
                        "{C:attention}Aces{}: {V:7}Triggers {stocking}before{V:7} effect again",
                        "{C:attention}Faces{}: {V:8}$#5#",
                        "{C:attention}6s to 10s{}: {V:9}Doubles {V:10}all {V:11}odds",
                        "{C:attention}2s to 5s{}: {V:12}Becomes {V:13}destroyed",
                        "{stocking}after{}"
                    },
                    {
                        "That card is {C:attention}discarded",
                        "after hand is played",
                        "{stocking}after{}"
                    },
                    {
                        "{C:inactive,E:1}\"Plaust knows all outcomes.\"",
                    },
                }
            },
            Mysthaps_stocking_kitty_socks = {
                name = "Kitty Socks",
                text = {
                    {
                        "Usable once per {C:attention}shop",
                        "Open the {C:attention}presents sack{}, then",
                        "add {C:dark_edition}Eternal{} to this",
                        "and {C:attention}doubles{} its values",
                        "{stocking}usable"
                    },
                    {
                        "Divides {C:mult}Mult{} by {X:attention,C:white} #1# ",
                        "{stocking}after"
                    },
                }
            }
        },
        stocking_wrapped_present = {
            Mysthaps_stocking_present = {
                name = "Present",
                text = {
                    "  {C:inactive}What could be inside?  ",
                    "{C:inactive}Open me to find out!"
                }
            }
        }
    },
    misc = {
        v_dictionary = {
            a_divmult = "/#1# Mult",
        }
    }
}