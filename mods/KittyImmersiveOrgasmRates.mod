partners[i].just_orgasmed = false;
            if (!partners[i].is_pc) partners[i].decide_action();
        }		
~
partners[i].just_orgasmed = false;
            if (!partners[i].is_pc) partners[i].decide_action();
        }		
		
		let self = partners[0];
		let target = partners[1];
		
		if (target)
		{
		
		let thisskills = self.is_pc ? V.pcskills : self.skills;
		let targskills = target.is_pc ? V.pcskills : target.skills;
			
        //if (this.is_pc) State.variables.pcneeds.Arousal = this.fleeting_stats["arousal"];
			if (self.has_part("penis"))
			{
				target.fleeting_stats["arousal"] = target.fleeting_stats["arousal"] + (thisskills.Penetrative  / 5);
					
					if (self.are_parts_penetrating("penis", target, "vagina"))
					{
						self.fleeting_stats["arousal"] = self.fleeting_stats["arousal"] + (targskills.Vaginal  / 5);
					}
					if (self.are_parts_penetrating("penis", target, "anus"))
					{
							self.fleeting_stats["arousal"] = self.fleeting_stats["arousal"] + (targskills.Anal  / 5);
					}
					if (self.are_parts_penetrating("penis", target, "mouth"))
					{
						self.fleeting_stats["arousal"] = self.fleeting_stats["arousal"] + (targskills.Oral  / 5);
					}
			}
		
			if (target.has_part("penis")) 
			{
				self.fleeting_stats["arousal"] = self.fleeting_stats["arousal"] + (targskills.Penetrative  / 5);
					
					if (target.are_parts_penetrating("penis", self, "vagina"))
					{
						target.fleeting_stats["arousal"] = target.fleeting_stats["arousal"] + (thisskills.Vaginal  / 5);
					}
					if (target.are_parts_penetrating("penis", self, "anus"))
					{
						target.fleeting_stats["arousal"] = target.fleeting_stats["arousal"] + (thisskills.Anal  / 5);
					}
					if (target.are_parts_penetrating("penis", self, "mouth"))
					{
						target.fleeting_stats["arousal"] = target.fleeting_stats["arousal"] + (thisskills.Oral  / 5);
					}
						// or thisskills.["Penetrative"]
			}/**/
		}
~~
                    else if (false && sainfo["subject parts"][i] == "penis" && this.orgasms > 0)
                    {
                        // we're spent!
                        subjecthaspart = false;
                        break;
~
                    else if (false && sainfo["subject parts"][i] == "penis" && this.orgasms > 0)
                    {
                        // we're spent!
                    //    subjecthaspart = false;
                    //    break;
~~
                    else if (false && sainfo["object parts"][i] == "penis" && target.orgasms > 0)
                    {
                        // they're spent!
                        objecthaspart = false;
                        break;
                    }
~
                    //else if (false && sainfo["object parts"][i] == "penis" && target.orgasms > 0)
                    //{
                        // they're spent!
                    //    objecthaspart = false;
                    //    break;
                    //}
~~
        let anyunsatisfied = false;
~
        let anyunsatisfied = false;
		// sex won't end if pc is selfish 
		let pcselfish = false;
~~
            if (!partners[i].has_any_inclination(["Sadist", "Breaker", "Whore Connoisseur"]) || (partners[i].goal != "blowjob" && partners[i].goal != "eat out"))
                allselfish = false;
~
            if (!partners[i].has_any_inclination(["Sadist", "Breaker", "Whore Connoisseur"]) || (partners[i].goal != "blowjob" && partners[i].goal != "eat out"))
                allselfish = false;
			if (pc.has_any_inclination(["Dominant", "Sadist", "Breaker", "Whore Connoisseur"]))
				pcselfish = true;
~~
        if (allselfless)
~
        if (allselfless && !pcselfish)
~~
            else if (!allselfish)
            {
                // encounter is over only when everybody gets off
                return !anyunsatisfied && pc.orgasms > 0;
            }
            else
            {
                return !anyunsatisfied;
            }
~
            else if (!allselfish && !pcselfish)
            {
                // encounter is over only when everybody gets off
                return !anyunsatisfied && pc.orgasms > 0;
            }
            else if (!pcselfish)
            {
                return !anyunsatisfied;
            }
            else 
            {
                return false;
            }
~~
			&lt;&lt;set _pre to _args[1]&gt;&gt;
		&lt;&lt;elseif _tempperson.orgasms gt 0 and !_tempperson.just_orgasmed and !_tempperson.is_pc&gt;&gt;
			&lt;&lt;set _pre to &quot;spent&quot;&gt;&gt;
~
			&lt;&lt;set _pre to _args[1]&gt;&gt;
~~
        if (this.multiple_partners() && this.has_part("penis") && this.orgasms > 0 && this.unspent_partners().length > 0)
~
        if (this.multiple_partners() && this.has_part("penis") && this.orgasms > 2 && this.unspent_partners().length > 0)
~~
        if (this.arousal() >= this.max_arousal() && (this.orgasms == 0 || this.is_pc || this.has_part("vagina")))
~
        if (this.arousal() >= this.max_arousal() && (this.orgasms >= 0 || this.is_pc || this.has_part("vagina")))
