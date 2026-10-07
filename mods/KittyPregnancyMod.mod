~~
    // leaving class events
~
	// pregnancy events
	// male pc staged events (female pc interchangeable) 
	/*
    {
        passage: "EventPregnancySurpriseAnnouncement",
        tags: ["residence hall", "MainHall", "ResidentsLounge", ""],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.pregPartnersStage(pregPartner) == 0",
		// Male player learns of pregnancy partners pregnancy, he can choose whether to support her or not. Not could end up having female partner abort and lose all love for him; example: $pc.arousal() gte 500 and $stream.partner.arousal() gte 500
    },
    {
        passage: "EventPregnancyFirstDoctorsAppointment",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player goes to female pregnancy partners first doctors appointment, if they get passed stage 0 where they either accept or reject. 
    },
    {
        passage: "EventPregnancyFirstUltraSound",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 2",
		// Male player goes to female pregnancy partners first ultrasound, if they get passed stage 1 FirstDoctorsAppointment. 
    },
    {
        passage: "EventPregnancyNestingInstincts",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.pregPartnersStage(pregPartner) == 3",
		// Pregnancy partner wants to rearrange the house for the first time
    },
    {
        passage: "EventPregnancyBabyShopping",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.pregPartnersStage(pregPartner) == 4",
		// Pregnancy partner wants to rearrange the house for the first time
    },
    {
        passage: "EventPregnancyBabyShower",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.pregPartnersStage(pregPartner) == 4",
		// Pregnancy partner wants to rearrange the house for the first time
    },
    {
        passage: "EventPregnancyLateDoctorsAppointment",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.pregPartnersStage(pregPartner) == 4",
		// Pregnancy partner wants to rearrange the house for the first time
    },
    {
        passage: "EventPregnancyBirth",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.pregPartnersStage(pregPartner) == 4",
		// Pregnancy partner wants to rearrange the house for the first time
    },
	
	// male pc non staged events (female pc interchangeable) 
	
    {
        passage: "EventPregnancyMoodSwings",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.get_pregnancy(pregpartner) gte 75,
		// Male player encounters mood swings from pregpartner
    },
    {
        passage: "EventPregnancyCravings",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pc.get_pregnancy(pregpartner) gte 75,
		// Male player meets up with pregnant partner and talks pregnancy cravings
    },
    {
        passage: "EventPregnancyReactionCongratulations",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player's friends congratulate them on pregnancy partner. 
    },
    {
        passage: "EventPregnancyReactionYikes",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 1 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player's friends warn them about pregnancy and ask them if they really should've done this. 
    },
    {
        passage: "EventPregnancyReactionTooMany",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 3 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Known NPC will tell you you're getting too many women pregnant
    },
    {
        passage: "EventPregnancyReady",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 3 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player friends will ask them if they're ready 
    },
    {
        passage: "EventPregnancyLove",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 3 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player's friends will tell them they're going to love it! 
    },
    {
        passage: "EventPregnancyBooks",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 3 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player's friends will tell them they should start reading up on pregnancy books! 
    },
    {
        passage: "EventPregnancyMomMore",
        tags: ["campus walk"],
        frequency: 200,
        checkvar: "$pc.get_pregnancypartners() gte 3 and $pregnancypartner.get_pregnancy gte 50 and $pc.pregPartnersStage(pregPartner) == 1",
		// Male player's mom will tell them to make more babies! 
    },
	
	// female pc only
	
    {
        passage: "EventPregnancyMorningSickness",
        tags: ["punished by dom"],
        frequency: 50,
        checkvar: "$pc.get_pregnancy() gte 30",
    },
	*/
    // leaving class events
~~

&lt;&lt;link &quot;Continue&quot; MainHall&gt;&gt;&lt;&lt;unset $attemptednavigation&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata>
~
&lt;&lt;link &quot;Continue&quot; MainHall&gt;&gt;&lt;&lt;unset $attemptednavigation&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata>
<tw-passagedata pid="15000" name="EventPregnancySurpriseAnnouncement" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;
You&#39;re sitting on the couch, scrolling through your phone. &quot;Hey, you look a little different. Are you alright?&quot; you say.&lt;br&gt;&lt;br&gt;

&lt;&lt;anonorfirstname _pregpartner&gt;&gt; fidgets with her hands. &quot;Yeah, I guess I have something to tell you.&quot;&lt;br&gt;&lt;br&gt;
	
You put the phone down. &quot;Okay, what is it?&quot;&lt;br&gt;&lt;br&gt;

&lt;&lt;anonorfirstname _pregpartner&gt;&gt; takes a deep breath. &quot;I&#39;m pregnant.&quot;&lt;br&gt;&lt;br&gt;

You look at her, wide-eyed. &quot;Wow, seriously? How do you feel about that?&quot;&lt;br&gt;&lt;br&gt;

She looks at you, tears welling up. &quot;I don&#39;t know... I&#39;m scared.&quot;&lt;br&gt;&lt;br&gt;

&lt;&lt;link &quot;I&#39;m here for you.&quot; EventPregnancySurpriseAnnouncementGood&gt;&gt;
&lt;&lt;/link&gt;&gt;&quot;&lt;br&gt;&lt;br&gt;

&lt;&lt;link &quot;I&#39;m sorry, I&#39;m not ready for this...&quot; EventPregnancySurpriseAnnouncementBad&gt;&gt;
&lt;&lt;/link&gt;&gt;


&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;anonorfirstname _pregpartner&gt;&gt; is sitting on the couch, scrolling through his phone. &quot;Hey, you look a little different. Are you alright?&quot; he says.&lt;br&gt;&lt;br&gt;

You fidget with your hands. &quot;Yeah, I guess I have something to tell you.&quot;&lt;br&gt;&lt;br&gt;

&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15000" name="EventPregnancySurpriseAnnouncementGood" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;
You reach for her hand. &quot;Hey, we can figure this out together. I&#39;m here for you.&quot;&lt;br&gt;&lt;br&gt;

&lt;&lt;anonorfirstname _pregpartner&gt;&gt; looks at you, nodding. &quot;Really? You mean that?&quot;&lt;br&gt;&lt;br&gt;

You speak with sincerity, &quot;Of course. I want to support you, no matter what you decide.&quot;&lt;br&gt;&lt;br&gt;

&quot;This means so much to me, thank you.&quot; she says in a grateful tone. 

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;

&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15000" name="EventPregnancySurpriseAnnouncementBad" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;
You take a deep breath, feeling the weight of the moment. I&#39;m sorry, I&#39;m just not ready for this...&quot;&lt;br&gt;&lt;br&gt;

She looks down, her hands trembling. &quot;I understand. It&#39;s a lot to take in.&quot;&lt;br&gt;&lt;br&gt;

You run a hand through your hair, trying to process everything. &quot;What do we do now?&quot;&lt;br&gt;&lt;br&gt;

She wipes away a tear. &quot;I don&#39;t know. I need time to think...&quot;&lt;br&gt;&lt;br&gt;

You nod, trying to gather your thoughts. &quot;Okay...&quot;&lt;br&gt;&lt;br&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;

&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15010" name="EventPregnancyFirstDoctorsAppointment " tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15020" name="EventPregnancyFirstUltraSound" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15030" name="EventPregnancyNestingInstincts" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15040" name="EventPregnancyBabyShopping" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15050" name="EventPregnancyBabyShower" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15060" name="EventPregnancyLateDoctorsAppointment" tags="event nobr" position="975,38100" size="100,100">
&lt;&lt;set _pregpartner to $eventnpc&gt;&gt;
&lt;&lt;if $pcgender is &quot;male&quot;&gt;&gt;

&lt;&lt;if $pcgender is &quot;female&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="15070" name="EventPregnancyBirth" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15080" name="EventPregnancyMoodSwings" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15090" name="EventPregnancyCravings" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyReactionCongratulations" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyReactionYikes" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyReactionTooMany" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyReady" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyLove" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyBooks" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyMomMore" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyMorningSickness" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyBellyBigger" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancyBabyClothes" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
<tw-passagedata pid="15100" name="EventPregnancySelfDoubt" tags="event nobr" position="975,38100" size="100,100">


</tw-passagedata>
~~
        &quot;creampie given&quot;, &quot;left somebody a creampie&quot;,
~
        &quot;creampie given&quot;, &quot;left somebody a creampie&quot;,
        &quot;pregnancy given&quot;, &quot;left somebody pregnant&quot;,
        &quot;pregnancy received&quot;, &quot;somebody left you pregnant&quot;,
~~
        this.tattoos = {};
~
        this.tattoos = {};
		this.pregnancy = 0;
		this.fertility = 500;
		this.virility = 500;
		this.pregnancyPartners = [];
		this.pregPartnersStage = [];
~~
                this.age = State.variables.pcage;
~
                this.age = State.variables.pcage;
				this.pregnancy = State.variables.pcpregnancy;
				this.fertility = State.variables.pcfertility;
				this.virility = State.variables.pcvirility;
				this.pregnancyPartners = State.variables.pcpregnancyPartners;
				this.pregPartnersStage = State.variables.pcpregPartnersStage;
~~
                        this.gender = pdata.species[1];	
~
                        this.gender = pdata.species[1];						
						this.pregnancy = "pregnancy" in pdata ? pdata.pregnancy : 0;
						this.fertility = "fertility" in pdata ? pdata.fertility : 500;
						this.virility = "virility" in pdata ? pdata.virility : 500;
						this.pregnancyPartners = "pregnancyPartners" in pdata ? pdata.pregnancyPartners : [];
						this.pregPartnersStage = "pregPartnersStage" in pdata ? pdata.pregPartnersStage : [];
~~
//#endregion Clothing Management

		
~
//#endregion Clothing Management

//#region Pregnancy
	get_pregnancy() 
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);
		
		// gets the pregnancy value 
		if (typeof this.pregnancy === 'undefined') 
		{
			this.pregnancy = 0; // Initialize if not defined
			pdata.pregnancy = this.pregnancy
			if (this.is_pc) {
				V.pcpregnancy = this.pregnancy || V.pcpregnancy;
			}
		} 
		return this.pregnancy; // Return the value of this.pregnancy
	}
	
	get_pregnancypartners() 
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);
		let pregnancyPartners = [];	
		
		for (let partnerName of pdata.pregnancyPartners)
		{
			const partnerData = setup.people.get_person(partnerName);
			pregnancyPartners.push(partnerData); // Push partner data if found
		}
		return pregnancyPartners
	}
	
	get_pregnancypartners_byname() 
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);

		return pdata.pregnancyPartners
	}
		//const pdata = setup.people.get_person(name);

	makepregnant(partner) 
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);
		
		if (this.gender === "female") 
		{
			if (this.pregnancy <= 0)
			{
				this.pregnancy = 5;
				pdata.pregnancy = this.pregnancy;
			if (this.is_pc) {
				V.pcpregnancy = this.pregnancy || V.pcpregnancy;
			}
			} else {
				//console.log("Can't get pregnant again.");
				return;
			}
				
		} else {
			//console.log("This instance cannot become pregnant.");
			return;
		}
		
		// Ensure partner is not already in the pregnancyPartners array
		if (!this.pregnancyPartners.includes(partner.name)) 
		{
			this.pregnancyPartners.push(partner.name);
			pdata.pregnancyPartners = this.pregnancyPartners;
			if (this.is_pc) {
				V.pcpregnancyPartners = this.pregnancyPartners || V.pcpregnancyPartners;
			}
			        // Delay the recording of pregnancy
			setTimeout(() => 
			{
				this.record_pregnancy(partner);
			}, 1000); // Delay of 1000 milliseconds (1 second)
		}
		
	}
	
	record_pregnancy(partner) 
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);
		let odata = partner.is_pc? partner : setup.people.get_person(partner);
		
		
		if (!partner.pregnancyPartners.includes(this.name)) 
		{
			partner.pregnancyPartners.push(this.name);
			odata.pregnancyPartners = this.pregnancyPartners;
			if (this.is_pc) {
				V.pcpregnancyPartners = partner.pregnancyPartners || V.pcpregnancyPartners;
			}
		}
	}
	/*
	        const outfit = [];
        for (let i = 0; i < clothes.length; i++)
        {
            let outclothes = Object.assign({}, clothes[i]);
            outfit.push(outclothes);
        }

	*/
	increase_pregnancy(value)
	{
		this.increase_pregstat("pregnancy", value);
	}
	
	
	end_pregnancy()
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);
		
		// ends the pregnancy
		this.pregnancy = 0;
		pdata.pregnancy = this.pregnancy;
		if (this.is_pc) {
			V.pcpregnancy = this.pregnancy || V.pcpregnancy;
		}	
	}
	
	determine_pregnancy(partner)
	{
		// determines pregnancy
		let pdata = this.is_pc? this : setup.people.get_person(this);
		const basechance = 0.2;
        const average = ((this.fertility + partner.virility) / 2);		// calculate average fertility and virility
        
        // normalize to a probability between 0 and 1
        const normalizedChance = Math.min(1, average / 1000); // Assuming max value of 1000
        const chance = Math.random(); // Generates a random number between 0 and 1
		const finalChance = Math.max(0, normalizedChance - basechance); // Scale the normalized chance by the base chance
        
		if (chance < finalChance) 
		{
            partner.makepregnant(this); // Call makepregnant if the chance is met
            //console.log("Pregnancy successful!");
        } else {
            //console.log("Pregnancy attempt failed.");
        }
		
	}
	
	increase_pregstat(stat, value)
	{
		let pdata = this.is_pc? this : setup.people.get_person(this);
		
		if (stat === "pregnancy")
		{
			// increases pregnancy
			this.pregnancy += value;
			pdata.pregnancy = this.pregnancy;
			if (this.is_pc) {
				V.pcpregnancy = this.pregnancy || V.pcpregnancy;
			}
		}
		if (stat === "fertility")
		{
			// increase fertility
			this.fertility += value;
			pdata.fertility = this.fertility;
			if (this.is_pc) {
				V.pcfertility = this.fertility || V.pcfertility;
			}
		}
		if (stat === "virility")
		{
			// increase virility
			this.virility += value;
			pdata.virility = this.virility;
			if (this.is_pc) {
				V.pcvirility = this.virility || V.pcvirility;
			}
		}
	}

//#endregion Pregnancy

~~
    physique_descriptor()
    {
        // let's get a natural language physique description now
        let physique = "";
        if (this.plumpness <= 250)
        {
            if (this.muscle <= 250)
            {
                physique = "skinny";
            }
            else if (this.muscle <= 500)
            {
                physique = "lean";
            }
            else if (this.muscle <= 750)
            {
                physique = "wiry";
            }
            else
            {
                physique = "ripped";
            }
        }
        else if (this.plumpness <= 500)
        {
            if (this.muscle <= 250)
            {
                physique = "thin";
            }
            else if (this.muscle <= 500)
            {
                physique = "toned";
            }
            else if (this.muscle <= 750)
            {
                physique = "lithe";
            }
            else
            {
                physique = "muscular";
            }
        }
        else if (this.plumpness <= 750)
        {
            if (this.muscle <= 250)
            {
                physique = "plump";
            }
            else if (this.muscle <= 500)
            {
                physique = "thick-bodied";
            }
            else if (this.muscle <= 750)
            {
                physique = "brawny";
            }
            else
            {
                physique = "ample";
            }
        }
        else
        {
            if (this.muscle <= 250)
            {
                physique = "round";
            }
            else if (this.muscle <= 500)
            {
                physique = "full-figured";
            }
            else if (this.muscle <= 750)
            {
                physique = "well-padded";
            }
            else
            {
                physique = "stocky";
            }
        }

        return physique;
    }
~
    physique_descriptor()
    {
        // let's get a natural language physique description now
        let physique = "";
		let pregnancy = this.get_pregnancy(); // Get Pregnancy Value
        if (this.plumpness <= 250)
        {
            if (this.muscle <= 250)
            {
                physique = "skinny";
            }
            else if (this.muscle <= 500)
            {
                physique = "lean";
            }
            else if (this.muscle <= 750)
            {
                physique = "wiry";
            }
            else
            {
                physique = "ripped";
            }
        }
        else if (this.plumpness <= 500)
        {
            if (this.muscle <= 250)
            {
                physique = "thin";
            }
            else if (this.muscle <= 500)
            {
                physique = "toned";
            }
            else if (this.muscle <= 750)
            {
                physique = "lithe";
            }
            else
            {
                physique = "muscular";
            }
        }
        else if (this.plumpness <= 750)
        {
            if (this.muscle <= 250)
            {
                physique = "plump";
            }
            else if (this.muscle <= 500)
            {
                physique = "thick-bodied";
            }
            else if (this.muscle <= 750)
            {
                physique = "brawny";
            }
            else
            {
                physique = "ample";
            }
        }
        else if (this.plumpness < 2000)
        {
            if (this.muscle <= 250)
            {
                physique = "round";
            }
            else if (this.muscle <= 500)
            {
                physique = "full-figured";
            }
            else if (this.muscle <= 750)
            {
                physique = "well-padded";
            }
            else
            {
                physique = "stocky";
            }
		}
		
		
		
		if (pregnancy >= 50) 
		{
			if (pregnancy <= 100) 
			{
				physique = "barely pregnant";
			} 
			else if (pregnancy <= 150) 
			{
				physique = "slightly pregnant";
			} 
			else if (pregnancy <= 200) 
			{
				physique = "clearly pregnant";
			} 
			else 
			{
				physique = "very pregnant";
			}
		}


        return physique;
    }
~~
                if (this.in_encounter())
                {
                    target.creampie_this_encounter = true;
                    this.did_creampie_this_encounter = true;
                }
~
                if (this.in_encounter())
                {
                    target.creampie_this_encounter = true;
                    this.did_creampie_this_encounter = true;
					this.determine_pregnancy(target);
                }
~~
                    &lt;&lt;ppc _personobj&gt;&gt; major is _major.
                &lt;&lt;/if&gt;&gt;
~
                    &lt;&lt;ppc _personobj&gt;&gt; major is _major.
                &lt;&lt;/if&gt;&gt;
				&lt;&lt;set _pregnancyvalue to _personobj.get_pregnancy()&gt;&gt;
                &lt;&lt;if _pregnancyvalue gte 5&gt;&gt;
						&lt;&lt;set _pregpartnername to _personobj.get_pregnancypartners_byname()[0]&gt;&gt; 
						&lt;&lt;if _pregpartnername === $pcname&gt;&gt;
								&lt;&lt;psc _personobj&gt;&gt; is pregnant with your child.
						&lt;&lt;else&gt;&gt;
							&lt;&lt;set _pregpartner to setup.people.get_person(_pregpartnername)&gt;&gt;
								&lt;&lt;psc _personobj&gt;&gt; is pregnant with &lt;&lt;anonorfullname _pregpartner&gt;&gt;&#39;s child.
						&lt;&lt;/if&gt;&gt;
                &lt;&lt;/if&gt;&gt;
~~
            gameday++;
~
            gameday++;
			setup.preg_dayadvance();
~~
    return [...new Set(inclins)];
}

~
    return [...new Set(inclins)];
}

setup.preg_dayadvance = function()
{
    let db = setup.people_db();
	let people = Object.values(db); //Object.values(db);
	
    for (const person of people) { // Iterate over each person in the database
		// increases pregnancy
		person.pregnancy += 10;
		if (person.is_pc) {
			V.pcpregnancy = person.pregnancy || V.pcpregnancy;
		}
    }
}
~~
                    &lt;&lt;default&gt;&gt;&lt;&lt;encounternamec _doer&gt;&gt; &lt;&lt;conjname _doer thrust&gt;&gt; deep into _opp &lt;&lt;pussy _target&gt;&gt; as _spp2 cock spasms, then &lt;&lt;conj _doer pump&gt;&gt; &lt;&lt;cum _doer&gt;&gt; deep inside _opo.
                    &lt;&lt;/switch&gt;&gt;
~
                    &lt;&lt;default&gt;&gt;&lt;&lt;encounternamec _doer&gt;&gt; &lt;&lt;conjname _doer thrust&gt;&gt; deep into _opp &lt;&lt;pussy _target&gt;&gt; as _spp2 cock spasms, then &lt;&lt;conj _doer pump&gt;&gt; &lt;&lt;cum _doer&gt;&gt; deep inside _opo.
                    &lt;&lt;/switch&gt;&gt;
					&lt;&lt;set _enc to $encounter&gt;&gt;
					&lt;&lt;for _encpartner range _enc.partners()&gt;&gt;
						&lt;&lt;if _encpartner.get_pregnancy() eq 5 &gt;&gt;
							&lt;&lt;anonorfullname _encpartner&gt;&gt; got pregnant!
							&lt;&lt;run _encpartner.increase_pregnancy(1)&gt;&gt;
						&lt;&lt;/if&gt;&gt;
					&lt;&lt;/for&gt;&gt;
~~
        &lt;&lt;set _anon to $partner1 &amp;&amp; setup.people.is_anonymous($partner1)&gt;&gt;
~

        &lt;&lt;set _anon to $partner1 &amp;&amp; setup.people.is_anonymous($partner1)&gt;&gt;
				&lt;&lt;for _encpartner range _enc.partners()&gt;&gt;
					&lt;&lt;if _encpartner.get_pregnancy() eq 5 &gt;&gt;
						&lt;&lt;anonorfullname _encpartner&gt;&gt; got pregnant!
						&lt;&lt;run _encpartner.increase_pregnancy(1)&gt;&gt;
					&lt;&lt;/if&gt;&gt;
				&lt;&lt;/for&gt;&gt;
~~
&lt;&lt;set $pcage to 18&gt;&gt;
~
&lt;&lt;set $pcage to 18&gt;&gt;

&lt;&lt;set $pcpregnancy to 0&gt;&gt;
&lt;&lt;set $pcfertility to 500&gt;&gt;
&lt;&lt;set $pcvirility to 500&gt;&gt;
&lt;&lt;set $pcpregnancyPartners to []&gt;&gt;
&lt;&lt;set $pcpregPartnersStage to []&gt;&gt;
~~
are &lt;&lt;= $pcage&gt;&gt; years old.
	~are &lt;&lt;= $pcage&gt;&gt; years old.
	&lt;&lt;set _pregnancyvalue to $pc.get_pregnancy()&gt;&gt;
    &lt;&lt;if _pregnancyvalue gte 5&gt;&gt;
		&lt;&lt;set _pregpartnername to $pc.get_pregnancypartners_byname()[0]&gt;&gt; 
			You are pregnant with _pregpartnername&#39;s child.
    &lt;&lt;/if&gt;&gt;
~~
fitness.plumpness += foodobj.plumpness;
    }
~
fitness.plumpness += foodobj.plumpness;
    }
	if ("increase fertility" in foodobj)
    {
        let fertamt = foodobj["increase fertility"];
        V.pc.increase_pregstat("fertility", fertamt)
    }
	if ("increase virility" in foodobj)
    {
        let viramt = foodobj["increase virility"];
        V.pc.increase_pregstat("virility", viramt)
    }
~~
    "bottle of water": {
        "restore hunger": 0,
        "reduce bladder": 40,
        "purchase quantity": 1,
        "price": 2,
        "flags": ["drink", "nonperishable"]
    },
~
    "bottle of water": {
        "restore hunger": 0,
        "reduce bladder": 40,
        "purchase quantity": 1,
        "price": 2,
        "flags": ["drink", "nonperishable"]
    },
    "fertility up!": {
        "restore hunger": 0,
        "increase fertility": 50,
        "reduce bladder": 40,
        "purchase quantity": 1,
        "price": 20,
        "flags": ["drink", "nonperishable"]
    },
    "virility up!": {
        "restore hunger": 0,
        "increase virility": 50,
        "reduce bladder": 40,
        "purchase quantity": 1,
        "price": 20,
        "flags": ["drink", "nonperishable"]
    },
~~
            {"label": "Water", "type": "food", "item": "bottle of water"},
~
            {"label": "Water", "type": "food", "item": "bottle of water"},
            {"label": "Fertility Up!", "type": "food", "item": "fertility up!"},
            {"label": "Virility Up!", "type": "food", "item": "virility up!"},
~~