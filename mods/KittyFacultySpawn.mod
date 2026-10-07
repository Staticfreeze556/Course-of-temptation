			if (timeofday == "night" && State.random() > 0.4 && !quadpartyhere)
				anybodyhere = false;~			if (timeofday == "night" && State.random() > 0.4 && !quadpartyhere)
				anybodyhere = false;
			
			for (const [person, pinfo] of Object.entries(db))
					if ((loc === "EmersonBuilding" || loc === "HallowellBuilding" || loc === "ThoreauBuilding") && pinfo.type === "faculty")
						retval.push(person);