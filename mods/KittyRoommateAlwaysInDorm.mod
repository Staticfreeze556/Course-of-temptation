		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			if (pinfo.residence == "Chicory Hall")
				belonghere = true;
			else if (pinfo.schedule && (!classestoday || hour > setup.School.last_bell()) && loc == "ResidentsLounge")
				belonghere = State.random() <= 0.1;

			if (pinfo.type == "student" && belonghere)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (loc == "YourDorm")
				{
					if (pinfo.roommate == "PC")
					{
						if (slotloc == "home")
							retval.push(person);
						else if (slotloc == "free time" && State.random() <= 0.4)
							retval.push(person);
					}
				}~		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			if (pinfo.residence == "Chicory Hall")
				belonghere = true;
			else if (pinfo.schedule && (!classestoday || hour > setup.School.last_bell()) && loc == "ResidentsLounge")
				belonghere = true;

			if (pinfo.type == "student" && belonghere)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (loc == "YourDorm")
				{
					if (pinfo.roommate == "PC")
					{
						if (slotloc == "home")
							retval.push(person);
						else if (slotloc == "free time" )
							retval.push(person);
						else if (slotloc == "food" )
							retval.push(person);
					}
				}