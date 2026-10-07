
    "Slut": {
        description: "You love to fuck. You just can't get enough. What else is there to say? (Release need decreases twice as fast and masturbating has reduced effect.)",
        dream: "You dream that you can't get enough. You fuck somebody and you immediately want to fuck somebody else. A friend, a stranger... it doesn't matter. You need sex.",
        requires: {"Disinhibition":6, "inclinations":["Casual Hookup"], "noinclinations":["Chaste", "Asexual", "Demisexual"]}, // storyfunc.js:278 - all_had_sex_with().length >= 20 & "Casual Hookup" & Disinhibition 6
		lockif: {},
    },
~
    "Slut": {
        description: "You love to fuck. You just can't get enough. What else is there to say? (Release need decreases twice as fast and masturbating has reduced effect.)",
        dream: "You dream that you can't get enough. You fuck somebody and you immediately want to fuck somebody else. A friend, a stranger... it doesn't matter. You need sex.",
        requires: {"Disinhibition":6, "inclinations":["Casual Hookup"], "noinclinations":["Chaste", "Asexual", "Demisexual"]}, // storyfunc.js:278 - all_had_sex_with().length >= 20 & "Casual Hookup" & Disinhibition 6
		lockif: {},
    },

    "Nymphomaniac": {
        description: "You're hopelessly addicted to sex. You just can't get enough of it. (Release need decreases twice as fast and masturbating has reduced effect.)",
        dream: "You dream that you can't get enough. You fuck somebody and you immediately want to fuck somebody else. A friend, a stranger... it doesn't matter. You need sex.",
        requires: {"Disinhibition":6, "inclinations":["Casual Hookup"], "noinclinations":["Chaste", "Asexual", "Demisexual"]}, // storyfunc.js:278 - all_had_sex_with().length >= 20 & "Casual Hookup" & Disinhibition 6
		lockif: {},
    },
~~
    if (need == "Release" && setup.pc().has_inclination("Slut")) amt *= 2;
    else if (need == "Release" && setup.pc().has_inclination("Chaste")) amt /= 2;~
    if (need == "Release" && setup.pc().has_inclination("Nymphomaniac")) amt *= 5;
    else if (need == "Release" && setup.pc().has_inclination("Slut")) amt *= 2;
    else if (need == "Release" && setup.pc().has_inclination("Chaste")) amt /= 2;