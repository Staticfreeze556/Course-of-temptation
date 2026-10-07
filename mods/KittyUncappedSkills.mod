    raise_skill(skill, amount = -1, level = -1)
    {
        if (!setup.Skills.is_valid(skill))
        {
            console.error("invalid skill reference: " + skill);
            return;
        }
        let chargen = tags().includes("chargen");
        const sklevel = this.skill_level(skill);
        if (amount == -1 || Number.isNaN(amount)) amount = setup.Skills.default_increase[sklevel];
        const skillgainmultiplier = chargen ? 1 : V.optskillgainmultiplier
        amount *= skillgainmultiplier;

        const cap = V.optdailyskillcap ? (setup.Skills.daily_caps[sklevel] * skillgainmultiplier) : 1000;

        if (amount > cap && !chargen) amount = cap;

        if (level >= 0 && !chargen)
        {
            // less learning if this is too easy or too difficult
            let overleveled = sklevel - level;
            if (overleveled >= 3) amount /= 3;  // todo: change to 0 once higher skill content exists generally
            else if (overleveled <= -3) amount /= 4;
            else if (overleveled == 2) amount /= 2.5;
            else if (overleveled == 1 && sklevel > 1) amount /= 1.5;
            else if (overleveled == -1) amount /= 2;
            else if (overleveled == -2) amount /= 3;
        }

        var skills = this.is_pc ? V.pcskills : this.skills;

        if (this.is_pc && !chargen)
        {
            if (V.skillsraisedtoday == undefined)
            {
                State.setVar("$skillsraisedtoday", {});
            }
            let raisedtoday = V.skillsraisedtoday;
            if (!(skill in raisedtoday))
            {
                raisedtoday[skill] = amount;
            }
            else
            {
                let allowed = cap - raisedtoday[skill];
                allowed = allowed < 0 ? 0 : allowed;
                if (amount > allowed) amount = allowed;
                raisedtoday[skill] += amount;
            }
        }

        if (amount <= 0 || Number.isNaN(amount)) return;

        if (this.is_pc && !(skill in skills))
        {
            skills[skill] = Math.round(amount);
            if (!chargen) setup.add_notification('You have learned the <span class="notice">' + setup.skill_label(skill) + '</span> skill! Keep using it daily to level it up!');
        }
        else
        {
            if (Number.isNaN(skills[skill])) skills[skill] = 0;
            let prevlvl = sklevel;
            skills[skill] = Math.min(Math.round(skills[skill] + amount), 1000);
            if (this.is_pc && this.skill_level(skill) > prevlvl && !chargen)
            {
                setup.add_notification('Your <span class="notice">' + setup.skill_label(skill) + '</span> skill has increased to <span class="notice">level ' + this.skill_level(skill) + '</span>!');
            }
        }
    }
~    raise_skill(skill, amount = -1, level = -1)
    {
        if (!setup.Skills.is_valid(skill))
        {
            console.error("invalid skill reference: " + skill);
            return;
        }
        let chargen = tags().includes("chargen");
        const sklevel = this.skill_level(skill);
        if (amount == -1 || Number.isNaN(amount)) amount = setup.Skills.default_increase[sklevel];
        const skillgainmultiplier = chargen ? 1 : V.optskillgainmultiplier
        amount *= skillgainmultiplier;

        const cap = V.optdailyskillcap ? (setup.Skills.daily_caps[sklevel] * skillgainmultiplier) : 10000000000000;

        if (amount > cap && !chargen) amount = cap;

        if (level >= 0 && !chargen)
        {
            // less learning if this is too easy or too difficult
            let overleveled = sklevel - level;
            if (overleveled >= 3) amount /= 3;  // todo: change to 0 once higher skill content exists generally
            else if (overleveled <= -3) amount /= 4;
            else if (overleveled == 2) amount /= 2.5;
            else if (overleveled == 1 && sklevel > 1) amount /= 1.5;
            else if (overleveled == -1) amount /= 2;
            else if (overleveled == -2) amount /= 3;
        }

        var skills = this.is_pc ? V.pcskills : this.skills;

        if (this.is_pc && !chargen)
        {
            if (V.skillsraisedtoday == undefined)
            {
                State.setVar("$skillsraisedtoday", {});
            }
            let raisedtoday = V.skillsraisedtoday;
            if (!(skill in raisedtoday))
            {
                raisedtoday[skill] = amount;
            }
            else
            {
                let allowed = cap - raisedtoday[skill];
                allowed = allowed < 0 ? 0 : allowed;
                if (amount > allowed) amount = allowed;
                raisedtoday[skill] += amount;
            }
        }

        if (amount <= 0 || Number.isNaN(amount)) return;

        if (this.is_pc && !(skill in skills))
        {
            skills[skill] = Math.round(amount);
            if (!chargen) setup.add_notification('You have learned the <span class="notice">' + setup.skill_label(skill) + '</span> skill! Keep using it daily to level it up!');
        }
        else
        {
            if (Number.isNaN(skills[skill])) skills[skill] = 0;
            let prevlvl = sklevel;
            skills[skill] = Math.min(Math.round(skills[skill] + amount), 1000);
            if (this.is_pc && this.skill_level(skill) > prevlvl && !chargen)
            {
                setup.add_notification('Your <span class="notice">' + setup.skill_label(skill) + '</span> skill has increased to <span class="notice">level ' + this.skill_level(skill) + '</span>!');
            }
        }
    }~~&lt;&lt;set _pcskills[_skill] = Math.min(1000, _pcskills[_skill] + 100)&gt;&gt;~&lt;&lt;set _pcskills[_skill] = Math.min(100000000, _pcskills[_skill] + 100)&gt;&gt;