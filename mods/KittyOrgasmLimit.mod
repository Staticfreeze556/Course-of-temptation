    time_to_end()
    {
        // return true if the encounter has reached a natural end, will forward story to this.endpassage

        let partners = this.partners();
        let pc = V.pc;

        if (pc.cum_covering.mouth) // what do we do with this? I must know!!!
            return false;

        if (pc.arousal() >= 1000) // definitely resolve PC orgasm
            return false;

        // sometimes npcs will only care to get the pc off
        let allselfless = true;
        // sometimes npcs will kind of find it hot if they're the only ones to get off, or they just don't care
        let allselfish = true;
        // let's also check if everybody got off, because that is usually what's important
        let anyunsatisfied = false;

        for (let i = 0; i < partners.length; i++)
        {
            if (partners[i].orgasms == 0 && partners[i].position_with(pc) != "Waiting")
                anyunsatisfied = true;
            if (!partners[i].has_any_inclination(["Submissive", "Attentive Lover", "Pleaser"]) || (partners[i].goal != "blowjob" && partners[i].goal != "eat out"))
                allselfless = false;
            if (!partners[i].has_any_inclination(["Sadist", "Breaker", "Whore Connoisseur"]) || (partners[i].goal != "blowjob" && partners[i].goal != "eat out"))
                allselfish = false;
        }

        let cant_access_pc =   ((pc.is_part_covered("vagina") && pc.has_part("vagina") && this.clothing_act_blocked(partners[0], pc, pc.outermost_covering("vagina").name))
                        ||      (pc.is_part_covered("penis") && pc.has_part("penis") && this.clothing_act_blocked(partners[0], pc, pc.outermost_covering("penis").name)))

        if (this.abort)
        {
            if (anyunsatisfied)
                this.aborted = true;
            return true;
        }

        if (this.possibly_stuck && (pc.orgasms > 0 || !anyunsatisfied))
        {
            return true;
        }

        // evaluate the less general, more straightforward goals
        const servicepartnergoals = ["service partner", "oral service partner", "hand service partner"];
        const servicepcgoals = ["service pc", "oral service pc", "hand service pc"];
        if (servicepartnergoals.includes(this.endgoal) || !this.consensual || cant_access_pc)
        {
            return !anyunsatisfied;
        }
        else if (servicepcgoals.includes(this.endgoal))
        {
            return pc.orgasms > 0;
        }

        if (allselfless)
        {
            return pc.orgasms > 0;
        }
        else
        {
            if (pc.orgasms == 0 && pc.arousal() > 800)
            {
                // pc is pretty close to orgasm, let's get 'em there before we stop the scene
                return false;
            }
            else if (!allselfish)
            {
                // encounter is over only when everybody gets off
                return !anyunsatisfied && pc.orgasms > 0;
            }
            else
            {
                return !anyunsatisfied;
            }
        }~    time_to_end()
    {
        // return true if the encounter has reached a natural end, will forward story to this.endpassage

        let partners = this.partners();
        let pc = V.pc;
		let playerorgasms = 0; 
		
		playerorgasms = Math.round(V.pc.skill_level("Physical") / 5); 

        if (pc.cum_covering.mouth) // what do we do with this? I must know!!!
            return false;

        if (pc.arousal() >= 1000) // definitely resolve PC orgasm
            return false;

        // sometimes npcs will only care to get the pc off
        let allselfless = true;
        // sometimes npcs will kind of find it hot if they're the only ones to get off, or they just don't care
        let allselfish = true;
        // let's also check if everybody got off, because that is usually what's important
        let anyunsatisfied = false;

        for (let i = 0; i < partners.length; i++)
        {
            if (partners[i].orgasms == 0 && partners[i].position_with(pc) != "Waiting")
                anyunsatisfied = true;
            if (!partners[i].has_any_inclination(["Submissive", "Attentive Lover", "Pleaser"]) || (partners[i].goal != "blowjob" && partners[i].goal != "eat out"))
                allselfless = false;
            if (!partners[i].has_any_inclination(["Sadist", "Breaker", "Whore Connoisseur"]) || (partners[i].goal != "blowjob" && partners[i].goal != "eat out"))
                allselfish = false;
        }

        let cant_access_pc =   ((pc.is_part_covered("vagina") && pc.has_part("vagina") && this.clothing_act_blocked(partners[0], pc, pc.outermost_covering("vagina").name))
                        ||      (pc.is_part_covered("penis") && pc.has_part("penis") && this.clothing_act_blocked(partners[0], pc, pc.outermost_covering("penis").name)))

        if (this.abort)
        {
            if (anyunsatisfied)
                this.aborted = true;
            return true;
        }

        if (this.possibly_stuck && (pc.orgasms > playerorgasms || !anyunsatisfied))
        {
            return true;
        }

        // evaluate the less general, more straightforward goals
        const servicepartnergoals = ["service partner", "oral service partner", "hand service partner"];
        const servicepcgoals = ["service pc", "oral service pc", "hand service pc"];
        if (servicepartnergoals.includes(this.endgoal) || !this.consensual || cant_access_pc)
        {
            return !anyunsatisfied;
        }
        else if (servicepcgoals.includes(this.endgoal))
        {
            return pc.orgasms > playerorgasms;
        }

        if (allselfless)
        {
            return pc.orgasms > playerorgasms;
        }
        else
        {
            if (pc.orgasms == playerorgasms && pc.arousal() > 800)
            {
                // pc is pretty close to orgasm, let's get 'em there before we stop the scene
                return false;
            }
            else if (!allselfish)
            {
                // encounter is over only when everybody gets off
                return !anyunsatisfied && pc.orgasms > playerorgasms;
            }
            else
            {
                return !anyunsatisfied;
            }
        }