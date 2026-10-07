~~
        this.tattoos = {};
~
        this.tattoos = {};
		this.ownedresidences = [];
		this.residencesbadcredit = 0;
		this.rentpaid = true;
~~
                this.age = State.variables.pcage;
~
                this.age = State.variables.pcage;
				this.ownedresidences = State.variables.pcownedresidences;
				this.residencesbadcredit = State.variables.pcresidencesbadcredit;
				this.rentpaid = State.variables.pcrentpaid;
~~
setup.Maps.CampusClinic = {
    name: "Campus Clinic",
    defaultmaptab: "Campus",
    nodes: {
        "CampusClinic": {name: "Reception", img: "loc_clinic"},
        "RecoveryRoom": {name: "Recovery Room", img: "loc_clinic_recovery"},
    },
}
~
setup.Maps.CampusClinic = {
    name: "Campus Clinic",
    defaultmaptab: "Campus",
    nodes: {
        "CampusClinic": {name: "Reception", img: "loc_clinic"},
        "RecoveryRoom": {name: "Recovery Room", img: "loc_clinic_recovery"},
    },
}

setup.Maps.PrescottRd = {
    name: "Prescott Road",
    defaultmaptab: "Campus",
    nodes: {
        "PrescottRdInt": {name: "Your House", img: "loc_reshall"},
    },
}

setup.Maps.PrescottRdInt = {
    name: "Your House",
    defaultmaptab: "Campus",
    nodes: {
        "PrescottRdYourLivingRoom": {name: "Your Living Room", img: "loc_reslounge"},
        "PrescottRdYourRoom": {name: "Your Room", img: "loc_dorm"},
        "PrescottRdYourSecondBedroom": {name: "Your Second Bedroom", img: "loc_dorm"},
        "PrescottRdYourBathroom": {name: "Your Bathroom", img: "loc_reshall"},
        "PrescottRdYourKitchen": {name: "Your Kitchen", img: "loc_reshall"},
    },
}

setup.Maps.BancroftLn = {
    name: "Bancroft Lane",
    defaultmaptab: "Campus",
    nodes: {
        "BancroftLnInt": {name: "Your Suite", img: "loc_reshall"},
    },
}

setup.Maps.BancroftLnInt = {
    name: "Your Suite",
    defaultmaptab: "Campus",
    nodes: {
        "BancroftLnYourLivingRoom": {name: "Your Living Room", img: "loc_quadparty_inside"},
        "BancroftLnYourRoom": {name: "Your Room", img: "loc_dorm"},
        "BancroftLnYourSecondBedroom": {name: "Your Second Bedroom", img: "loc_dorm"},
        "BancroftLnYourBathroom": {name: "Your Bathroom", img: "loc_reshall"},
        "BancroftLnYourKitchen": {name: "Your Kitchen", img: "loc_reshall"},
    },
}

setup.Maps.DatePalmSt = {
    name: "Date Palm Street",
    defaultmaptab: "Town",
    nodes: {
        "DatePalmStInt": {name: "Your Apartment", img: "loc_reshall"},
    },
}

setup.Maps.DatePalmStInt = {
    name: "Your Apartment",
    defaultmaptab: "Town",
    nodes: {
        "DatePalmStYourLivingRoom": {name: "Your Living Room", img: "loc_reslounge"},
        "DatePalmStYourRoom": {name: "Your Room", img: "loc_dorm"},
        "DatePalmStYourSecondBedroom": {name: "Your Second Bedroom", img: "loc_dorm"},
        "DatePalmStYourBathroom": {name: "Your Bathroom", img: "loc_reshall"},
        "DatePalmStYourKitchen": {name: "Your Kitchen", img: "loc_reshall"},
    },
}
~~
&lt;&lt;set $pcage to 18&gt;&gt;
~
&lt;&lt;set $pcage to 18&gt;&gt;

&lt;&lt;set $pcownedresidences to []&gt;&gt;
&lt;&lt;set $pcresidencesbadcredit to 0&gt;&gt;
&lt;&lt;set $pcrentpaid to true&gt;&gt;
&lt;&lt;set $pceventresidenceaction to ""&gt;&gt;
&lt;&lt;set $pcresidenceloc to ""&gt;&gt;
&lt;&lt;set $pchouseparty to false&gt;&gt;
&lt;&lt;set $pclastresidence&gt;&gt;
~~
//#endregion Clothing Management
~
//#endregion Clothing Management

//#region Residences
	owns_residence(inresidence) 
	{
		let ownedresidences = this.ownedresidences;
		
		for (let residence of ownedresidences)
			{
                if (inresidence === residence)
                {
                    return true;
                }
            }
		return false; // return false if no match is found
    }

	add_residence(inresidence)
	{
		let ownedresidences = this.ownedresidences;
		
		// Check if inresidence is already in ownedresidences
		if (!this.owns_residence(inresidence))
		{
			ownedresidences.push(inresidence); // Add residence
			V.pcownedresidences = this.ownedresidences;
		}
    }
	
	remove_residence(inresidence)
	{
		let ownedresidences = this.ownedresidences;
		
		// Check if the residence is owned
		if (this.owns_residence(inresidence))
		{
			// Find the index of the residence to remove
			let index = ownedresidences.indexOf(inresidence);
			
			// Remove the residence if it exists
			if (index > -1)
			{
				ownedresidences.splice(index, 1); // Remove one element at the index
				V.pcownedresidences = this.ownedresidences;
			}
		}
	}

	calc_residences_rentamt()
	{
		let ownedresidences = this.ownedresidences;
		let amttopay = 0;
		
		for (let residence of ownedresidences)
			{
                if (residence === "DatePalmSt")
                {
                    amttopay += 1200;
                }
                if (residence === "BancroftLn")
                {
                    amttopay += 800;
                }
                if (residence === "PrescottRd")
                {
                    amttopay += 0;
                }
            }
		return amttopay;
    }

	get_residence_rentamt(inresidence)
	{
		let rentamt = 0;
		
		if (inresidence === "DatePalmSt")
        {
            rentamt += 1200;
        }
        if (inresidence === "BancroftLn")
		{
			rentamt += 800;
		}
        if (inresidence === "PrescottRd")
		{
			rentamt += 0;
		}
		return rentamt;
    }
	
	calc_residences_cost(inresidence)
	{
		let amttopay = 0;
		
		if (inresidence === "DatePalmSt")
        {
            amttopay += 1200;
        }
        if (inresidence === "BancroftLn")
		{
			amttopay += 800;
		}
        if (inresidence === "PrescottRd")
		{
			amttopay += 120000;
		}
		return amttopay;
    }
	
	//#endregion Residences
	
~~
			day -= this.month_length;
            month++;
~
			day -= this.month_length;
            month++;
			setup.payrent();
~~
    return [...new Set(inclins)];
}

~
    return [...new Set(inclins)];
}

setup.payrent = function()
{	
	this.rentpaid = false;
	V.pcrentpaid = this.rentpaid;
},

~~
    // park events
~
	// residences events
	
    {
        passage: "EventPayRent",
        tags: ["campus walk", "town walk"],
        chance: 1,
        checkvar: "$pcrentpaid == false",
        //frequency: 100,
    },
	
    // park events
~~
    else
    {
        calendar.push({
            title: "Tuition?",
            text: "Mom wants me to help with tuition. Will call with details. Need to find job and save $$$, ugh.",
            emoji: "💸"
        });
    }
~
    else
    {
        calendar.push({
            title: "Tuition?",
            text: "Mom wants me to help with tuition. Will call with details. Need to find job and save $$$, ugh.",
            emoji: "💸"
        });
    }

    if (V.rentpaid = false)
    {
        calendar.push({
            title: "Rent",
            text: "Gotta remember to pay rent",
            emoji: "💸"
        });
    }
    else
    {
        calendar.push({
            title: "Tuition?",
            text: "Mom wants me to help with tuition. Will call with details. Need to find job and save $$$, ugh.",
            emoji: "💸"
        });
    }

~~
&lt;&lt;widget &quot;readbook&quot;&gt;&gt;
    &lt;&lt;run setup.Books.read(_args[0])&gt;&gt;
&lt;&lt;/widget&gt;&gt;</tw-passagedata>
~
&lt;&lt;widget &quot;readbook&quot;&gt;&gt;
    &lt;&lt;run setup.Books.read(_args[0])&gt;&gt;
&lt;&lt;/widget&gt;&gt;</tw-passagedata>
<tw-passagedata pid="12000" name="EventPayRent" tags="event" position="1225,13225" size="100,100">
&lt;&lt;if $pcownedresidences&gt;&gt;
It's time to pay rent isn't it... Best to pay or get kicked out.&lt;&lt;dalterneed Relaxation -50&gt;&gt;
    &lt;&lt;set _rentamt to $pc.calc_residences_rentamt()&gt;&gt;
		&lt;&lt;link &quot;Pay rent&quot; EventResidenceAction&gt;&gt; 
			&lt;&lt;if $pcmoney gte _rentamt&gt;&gt;
				&lt;&lt;run $pcmoney -= _rentamt&gt;&gt;
				&lt;&lt;set $pcrentpaid to true&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
				&lt;&lt;set $pceventresidenceaction = "rent paid"&gt;&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
		&lt;&lt;link &quot;Forego rentals&quot; EventResidenceAction&gt;&gt; 
			&lt;&lt;run $pc.remove_residence(&quot;BancroftLn&quot;)&gt;&gt; 
			&lt;&lt;run $pc.remove_residence(&quot;DatePalmSt&quot;)&gt;&gt; 	
			&lt;&lt;set $pcrentpaid to true&gt;&gt;
			&lt;&lt;set $pceventresidenceaction = "rentals foregone"&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
&lt;&lt;else&gt;&gt;
	Damn, glad I don't have to pay rent on top of tuition..
	&lt;&lt;set $pcrentpaid to true&gt;&gt;.
	&lt;&lt;continuelink&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
<tw-passagedata pid="12010" name="EventResidenceAction" tags="event" position="1225,13225" size="100,100">
&lt;&lt;nobr&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "rent paid"&gt;&gt;
	You&#39;ve paid your rent! &lt;&lt;dalterneed Relaxation 150&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "rentals foregone"&gt;&gt;
	You&#39;ve foregone your rentals! &lt;&lt;dalterneed Relaxation -150&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "rented BancroftLn"&gt;&gt;
	You&#39;ve rented a suite at Bancroft Lane! &lt;&lt;dalterneed Relaxation 150&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "rented DatePalmSt"&gt;&gt;
	You&#39;ve rented a suite at Date Palm Street! &lt;&lt;dalterneed Relaxation 150&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "bought PrescottRd"&gt;&gt;
	You&#39;ve bought a house at Prescott Road! &lt;&lt;dalterneed Relaxation 550&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "removed BancroftLn"&gt;&gt;
	You&#39;ve moved out of your suite at Bancroft Lane. 
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "removed DatePalmSt"&gt;&gt;
	You&#39;ve moved out of your apartment at Date Palm Street. 
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "removed PrescottRd"&gt;&gt;
	You&#39;ve moved out of your house at Prescott Road. 
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "not enough money"&gt;&gt; 
	You dont have enough money for this residence.
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pceventresidenceaction == "rest"&gt;&gt; 
	You wake up from your short rest feeling rejuvinated. 
&lt;&lt;/if&gt;&gt;
&lt;&lt;continuelink&gt;&gt;
&lt;&lt;/nobr&gt;&gt;</tw-passagedata>
~~
<tw-passagedata pid="3018" name="BancroftLn" tags="location locBancroftLn locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏠" position="975,37725" size="100,100">You are on Bancroft Lane. A row of suite-style residences is here, meant for wealthier upperclass or postgrad types. Definitely too rich for your blood.&lt;&lt;if $exhibitionsneak&gt;&gt; You&#39;re trying to stay hidden behind some fancy shrubbery.&lt;&lt;/if&gt;&gt;

&lt;&lt;exits&gt;&gt;
&lt;&lt;map&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="3018" name="BancroftLn" tags="location locBancroftLn locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏠" position="975,37725" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Bancroft Lane. A row of suite-style residences is here, meant for wealthier upperclass or postgrad types. Definitely too rich for your blood.&lt;&lt;if $exhibitionsneak&gt;&gt; You&#39;re trying to stay hidden behind some fancy shrubbery.&lt;&lt;/if&gt;&gt;

    &lt;&lt;if $pc.owns_residence(&quot;BancroftLn&quot;)&gt;&gt;
		&lt;&lt;link &quot;Your Suite&quot; BancroftLnInt &gt;&gt;
			&lt;&lt;advtime 1&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;&lt;br&gt;
		&lt;&lt;link &quot;Remove Residence&quot; EventResidenceAction &gt;&gt;
			&lt;&lt;run $pc.remove_residence(&quot;BancroftLn&quot;)&gt;&gt; 
				&lt;&lt;set $pceventresidenceaction = "removed BancroftLn"&gt;&gt;
			&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;advtime 1&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;set _buyresidencelink to {text: &quot;Buy Residence&quot;, emoji: &quot;🏢&quot;}&gt;&gt;
        &lt;&lt;link _buyresidencelink EventResidenceAction&gt;&gt; 
			&lt;&lt;set _rescost to $pc.calc_residences_cost(&quot;BancroftLn&quot;)&gt;&gt;
			&lt;&lt;if $pcmoney gte _rescost&gt;&gt;
				&lt;&lt;run $pc.add_residence(&quot;BancroftLn&quot;)&gt;&gt; 
				&lt;&lt;run $pcmoney -= _rescost&gt;&gt;
				&lt;&lt;set $pceventresidenceaction = "rented BancroftLn"&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;else&gt;&gt;
				&lt;&lt;set $pceventresidenceaction = "not enough money"&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;/if&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; 
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/nobr&gt;&gt;&lt;br&gt;
&lt;&lt;exits&gt;&gt;
&lt;&lt;map&gt;&gt;</tw-passagedata>
<tw-passagedata pid="12020" name="BancroftLnInt" tags="location locBancroftLnInt locblockBancroftLn" position="975,38100" size="100,100">
	&lt;&lt;nobr&gt;&gt;
	You are inside your Bancroft Suite on the university campus. This cozy one-bedroom, one-bathroom unit is designed for practicality and comfort, making the most of the space available. The open-plan living area feels inviting, with large windows that offer plenty of natural light and a view of the campus courtyard. The living room has enough room for a small couch and desk, perfect for studying or relaxing between classes.
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
	&lt;&lt;set $pclastresidence to $location&gt;&gt;
	
	&lt;br&gt;&lt;br&gt;
	You're currently at the entrance of your apartment. 
	&lt;&lt;nobr&gt;&gt;
    &lt;&lt;peoplehere&gt;&gt;
    &lt;&lt;include EventRoommateInDorm&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	
&lt;&lt;godate&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _loc to passage()&gt;&gt;
	Your room is right inside. You can rest for a while if you want.&lt;br&gt;
	&lt;&lt;set $pceventresidenceaction to "rest"&gt;&gt;
    &lt;&lt;link  {text: &quot;Rest for a while&quot;, link: &quot;EventResidenceAction&quot;}&gt;&gt;
        &lt;&lt;set _rest to 125&gt;&gt;
        &lt;&lt;set _mins to (_rest / 125) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Bedroom&quot;, link: &quot;BancroftLnYourRoom&quot;, emoji: &quot;🛏️&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your TV is in the living room. You can watch a few channels to pass time.&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Living room&quot;, link: &quot;BancroftLnYourLivingRoom&quot;, emoji: &quot;🛋️&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	You can grab a bite to eat in the Kitchen.&lt;br&gt; 
    &lt;&lt;link &quot;Get some food&quot; &quot;BancroftLnYourKitchen&quot; &#39;🥫&#39;&gt;&gt;
        &lt;&lt;safeadvtime 10 Food&gt;&gt;
        &lt;&lt;alterneed Food 1000&gt;&gt;
        &lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;	
    &lt;&lt;link {text: &quot;Go to Kitchen&quot;, link: &quot;BancroftLnYourKitchen&quot;, emoji: &quot;🍲&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your bathroom is down the hall. &lt;br&gt;
	&lt;&lt;link &quot;Use the bathroom&quot; &quot;BancroftLnYourBathroom&quot; &#39;🚽&#39;&gt;&gt;
		&lt;&lt;alterneed Bladder 1000&gt;&gt;
		&lt;&lt;set $header to &quot;You step into the small bathroom, do your thing, and come back out.&quot;&gt;&gt;
		&lt;&lt;safeadvtime 5 Bladder Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Bathroom&quot;, link: &quot;BancroftLnYourBathroom&quot;, emoji: &quot;🚽&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;

	&lt;&lt;nobr&gt;&gt;
    A desk is built into the base of the window, offering a study area with a view.

    &lt;&lt;set _comp to setup.computer()&gt;&gt;
    &lt;&lt;if _comp&gt;&gt;
        You have &lt;&lt;aoran _comp&gt;&gt; _comp available to use.
    &lt;&lt;/if&gt;&gt;

    &lt;br&gt;
    &lt;&lt;link &quot;Study&quot; Study&gt;&gt;&lt;&lt;set $studyspan to 30&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Internet&quot; Computer&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _gamelink to {text: &quot;Play game&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _gamelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Video Gaming&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave Your Suite&quot;, link: &quot;BancroftLn&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;unset $pcresidenceloc&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata><tw-passagedata pid="12030" name="BancroftLnYourLivingRoom" tags="location locBancroftLnYourLivingRoom locblockBancroftLnInt" position="975,38100" size="100,100">
	You are inside your living room. The space feels open and inviting, designed for both relaxation and entertaining. Large windows let natural light pour in, giving the room a warm, bright ambiance during the day. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	Your sofa looks pretty comfortable. You can sit back and rest for a while if you want.
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 150&gt;&gt;
        &lt;&lt;set _mins to (_rest / 250) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;

	Your TV is here. You can watch a few channels to pass time. 
	&lt;&lt;nobr&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Watch TV&quot;, emoji: &#39;📺&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;safeadvtime 60 Relaxation&gt;&gt;
			&lt;&lt;run setup.Needs.enjoy(110)&gt;&gt;
			&lt;&lt;set _event to setup.Events.passage([&quot;lounge tv&quot;])&gt;&gt;
			&lt;&lt;egoto _event&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 110&gt;&gt;
		&lt;&lt;if $pc.skillleveled(&quot;Exhibitionism&quot;, 6) and $lastloungeporn isnot $gameday&gt;&gt;
			&lt;br&gt;
			&lt;&lt;set _link to {text: &quot;Watch porn&quot;, link: &quot;EventLoungePorn&quot;, emoji: &#39;💦&#39;}&gt;&gt;
			&lt;&lt;link _link&gt;&gt;
				&lt;&lt;raiseskill Exhibitionism 6&gt;&gt;
				&lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 3&gt;&gt;
				&lt;&lt;safeadvtime 60 Relaxation Arousal&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;skill Exhibitionism 6&gt;&gt; &lt;&lt;dalterneed Relaxation 120&gt;&gt; &lt;&lt;dalterneed Arousal 200&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Play video games&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
			&lt;&lt;run setup.Needs.enjoy(50)&gt;&gt;
			&lt;&lt;raiseskill &quot;Video Gaming&quot; 2&gt;&gt;
			&lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
			&lt;&lt;egoto _event&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	&lt;&lt;if $peopleatlocation.length gt 0&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Play game with somebody&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;set _eventpassage to setup.Events.passage(&quot;video game partner&quot;)&gt;&gt;
			&lt;&lt;if State.random() lte (setup.Events.base_event_chance() * 2.5)&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, attractiontopc: true, attractionfrompc: true, notsexpartner: true, inclinations: setup.archetypes.inclination_sets.voyeur, skills: [&quot;Video Gaming&quot;]})&gt;&gt;
			&lt;&lt;else&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, specialok: true, skills: [&quot;Video Gaming&quot;]})&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if $gamepartner is null&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, specialok: true})&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if $gamepartner is null&gt;&gt;
				&lt;&lt;set $loungemsg to &quot;You pick up a game controller, hoping for somebody to join you... but no one ever does.&quot;&gt;&gt;
				&lt;&lt;advtime 5&gt;&gt;
				&lt;&lt;egoto _loc&gt;&gt;
			&lt;&lt;else&gt;&gt;
				&lt;&lt;safeadvtime 30 Relaxation Attention&gt;&gt;
				&lt;&lt;alterneed Relaxation 50&gt;&gt;
				&lt;&lt;socialize 30&gt;&gt;
				&lt;&lt;egoto _eventpassage&gt;&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt; &lt;&lt;dalterneed Attention 30&gt;&gt;
		&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;\
	

&lt;&lt;set _link to {text: &quot;Leave your living room&quot;, link: &quot;BancroftLnInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12040" name="BancroftLnYourRoom" tags="location locBancroftLnYourRoom locblockBancroftLnInt" position="975,38100" size="100,100">
	You are inside your Bancroft Suite bedroom. The room is small but cozy, with just enough space to feel comfortable without being cramped. A full-sized bed is nestled against one wall, dressed in soft, simple linens that make the room feel inviting. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
   
&lt;&lt;set _loc to passage()&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	Your bed is right inside in the middle of the room. You can rest for a while if you want.&lt;br&gt;
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 125) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your queen sized bed sits in the middle of the room. You can go to sleep if you're tired.&lt;br&gt;
	&lt;&lt;set _sleeplink to {text: &quot;Sleep&quot;, link: &quot;Sleep&quot;, emoji: &quot;🛏️&quot;}&gt;&gt;
    &lt;&lt;link _sleeplink&gt;&gt;&lt;&lt;unset $attemptednavigation&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;if $peopleatlocation.length is 0 and $pc.skillleveled(&quot;Disinhibition&quot;, 1)&gt;&gt;
        &lt;&lt;set _mastlink to {text: &quot;Masturbate in bed&quot;, link: &quot;EncounterRound&quot;, emoji: &quot;💦&quot;}&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link _mastlink&gt;&gt;
            &lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;], endpassage: $pcresidenceloc, intro_text: &quot;You&#39;re alone. You get into bed and stretch out comfortably, ready to touch yourself.&quot;})&gt;&gt;
            &lt;&lt;raiseskill Disinhibition 1&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;skill Disinhibition 1&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;set _pets to setup.dorm_category_items(&quot;pet&quot;)&gt;&gt;
	&lt;&lt;for _pet range _pets&gt;&gt;
		&lt;&lt;if _pet&gt;&gt;
			&lt;br&gt;&lt;br&gt;
			&lt;&lt;set _action to setup.randel(setup.dormstuff[_pet.item].actions)&gt;&gt;
			&lt;&lt;set _name to _pet.name || _pet.item&gt;&gt;
			&lt;&lt;if _pet.petname&gt;&gt;&lt;&lt;= _pet.petname&gt;&gt; the &lt;&lt;= _name&gt;&gt;
			&lt;&lt;else&gt;&gt;Your &lt;&lt;= _name&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			is _action
			&lt;br&gt;
			&lt;&lt;if !_pet.petname&gt;&gt;
				&lt;&lt;link &quot;Name your pet&quot; DormPetName&gt;&gt;&lt;&lt;/link&gt;&gt;
				&lt;br&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;link &quot;Interact&quot; DormPetInteract&gt;&gt;

			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt; &lt;&lt;dalterneed Attention 15&gt;&gt; &lt;&lt;dalterneed Relaxation 15&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/for&gt;&gt;
	
    &lt;&lt;set _bookshelf to setup.dorm_category_item(&quot;books&quot;)&gt;&gt;
    &lt;&lt;if _bookshelf and _bookshelf.collection&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        You have &lt;&lt;= _bookshelf.name&gt;&gt;.
        &lt;br&gt;
        &lt;&lt;link &quot;Read something&quot; DormRead&gt;&gt;

        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;set _decor to setup.decor_names()&gt;&gt;
    &lt;&lt;if _decor.length gt 0&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        Your side of the room is decorated with &lt;&lt;and _decor&gt;&gt;.
        &lt;br&gt;
        &lt;&lt;link &quot;Look at your stuff&quot; DormInventory&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if $dormstuff and $dormstuff.length gt 0&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        You&#39;ve accumulated some possessions since arriving here.
        &lt;br&gt;
        &lt;&lt;link &quot;Look at your stuff&quot; DormInventory&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;set _exerapps to [&quot;adjustable dumbbells&quot;, &quot;yoga mat&quot;]&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Exercise&quot; DormExercise&gt;&gt;&lt;&lt;/link&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;

	Change your clothes?
	&lt;&lt;link &quot;Clothes&quot; Wardrobe&gt;&gt;&lt;&lt;/link&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bedroom&quot;, link: &quot;BancroftLnInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12050" name="BancroftLnYourBathroom" tags="location locBancroftLnYourSecondBedroom locblockBancroftLnInt" position="975,38100" size="100,100">
	You are inside your Bancroft Suite bathroom. This compact space is designed for efficiency while maintaining a modern aesthetic. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	You can take a shower or use the bathroom. &lt;br&gt;
    &lt;&lt;link &quot;Use the shower&quot; _loc &#39;🚿&#39;&gt;&gt;
        &lt;&lt;alterneed Hygiene 1000&gt;&gt;
        &lt;&lt;set $header to &quot;You step into the small bathroom and strip off for a quick shower, then dry off and get dressed.&quot;&gt;&gt;
        &lt;&lt;safeadvtime 15 Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 15&gt;&gt; &lt;&lt;dalterneed Hygiene 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;link &quot;Use the bathroom&quot; _loc &#39;🚽&#39;&gt;&gt;
		&lt;&lt;alterneed Bladder 1000&gt;&gt;
		&lt;&lt;set $header to &quot;You step into the small bathroom, do your thing, and come back out.&quot;&gt;&gt;
		&lt;&lt;safeadvtime 5 Bladder Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt; 
	&lt;&lt;/nobr&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bathroom&quot;, link: &quot;BancroftLnInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12060" name="BancroftLnYourKitchen" tags="location locBancroftLnYourKitchen locblockBancroftLnInt" position="975,38100" size="100,100">
	You are inside your Bancroft Suite kitchen. This compact area is thoughtfully designed to maximize functionality while maintaining a modern and inviting atmosphere. The kitchen features a large fridge, a toaster, hot plate, microwave, and coffeemaker. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	You can grab some food quickly and go about your day.&lt;br&gt;
    &lt;&lt;link &quot;Get some food&quot; _loc &#39;🥫&#39;&gt;&gt;
        &lt;&lt;safeadvtime 10 Food&gt;&gt;
        &lt;&lt;alterneed Food 1000&gt;&gt;
        &lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;

&lt;&lt;nobr&gt;&gt;
	The Kitchen has a large fridge you can put food in.&lt;br&gt;
    &lt;&lt;set _foodapps to [&quot;toaster&quot;, &quot;hot plate&quot;, &quot;microwave&quot;]&gt;&gt;
    &lt;&lt;set _has to [&quot;toaster&quot;, &quot;hot plate&quot;, &quot;microwave&quot;]&gt;&gt;
    &lt;&lt;for _foodapp range _foodapps&gt;&gt;
        &lt;&lt;if setup.dorm_has(_foodapp)&gt;&gt;
            &lt;&lt;run _has.push(setup.a_or_an(_foodapp) + &quot; &quot; + _foodapp)&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/for&gt;&gt;
    &lt;&lt;if _has.length gt 0&gt;&gt;
        You&#39;ve got &lt;&lt;and _has&gt;&gt; to prepare food with.
    &lt;&lt;/if&gt;&gt;
        You &lt;&lt;if _has.length gt 0&gt;&gt;also &lt;&lt;/if&gt;&gt;have a coffeemaker.
&lt;&lt;/nobr&gt;&gt;
&lt;&lt;link &quot;Fridge&quot; DormFoodStash&gt;&gt;&lt;&lt;/link&gt;&gt;


&lt;&lt;set _link to {text: &quot;Leave your Kitchen&quot;, link: &quot;BancroftLnInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;unset $pcresidenceloc&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
~~
<tw-passagedata pid="3086" name="DatePalmSt" tags="location locDatePalmSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏢" position="725,38600" size="100,100">You are on Date Palm Street, a crowded residential street. An apartment building stands here, a few storeys tall, making it one of the largest buildings in this rural college town.

&lt;&lt;godate&gt;&gt;\
&lt;&lt;exits&gt;&gt;
&lt;&lt;map&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="3086" name="DatePalmSt" tags="location locDatePalmSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏢" position="725,38600" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Date Palm Street, a crowded residential street. An apartment building stands here, a few storeys tall, making it one of the largest buildings in this rural college town.

    &lt;&lt;if $pc.owns_residence(&quot;DatePalmSt&quot;)&gt;&gt;
		&lt;&lt;link &quot;Your Apartment&quot; DatePalmStInt &gt;&gt;
			&lt;&lt;advtime 1&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;&lt;br&gt;
		&lt;&lt;link &quot;Remove Residence&quot; EventResidenceAction &gt;&gt;
			&lt;&lt;run $pc.remove_residence(&quot;DatePalmSt&quot;)&gt;&gt; 
				&lt;&lt;set $pceventresidenceaction = "removed DatePalmSt"&gt;&gt;
			&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;advtime 1&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;set _buyresidencelink to {text: &quot;Buy Residence&quot;, emoji: &quot;🏢&quot;}&gt;&gt;
        &lt;&lt;link _buyresidencelink EventResidenceAction&gt;&gt; 
			&lt;&lt;set _rescost to $pc.calc_residences_cost(&quot;DatePalmSt&quot;)&gt;&gt;
			&lt;&lt;if $pcmoney gte _rescost&gt;&gt;
				&lt;&lt;run $pc.add_residence(&quot;DatePalmSt&quot;)&gt;&gt; 
				&lt;&lt;run $pcmoney -= _rescost&gt;&gt;
				&lt;&lt;set $pceventresidenceaction = "rented DatePalmSt"&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;else&gt;&gt;
				&lt;&lt;set $pceventresidenceaction = "not enough money"&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;/if&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; 
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/nobr&gt;&gt;&lt;br&gt;
&lt;&lt;godate&gt;&gt;\
&lt;&lt;exits&gt;&gt;
&lt;&lt;map&gt;&gt;</tw-passagedata>
<tw-passagedata pid="12070" name="DatePalmStInt" tags="location locDatePalmStInt locblockDatePalmSt" position="975,38100" size="100,100">
&lt;&lt;nobr&gt;&gt;
	&lt;&lt;if $pchouseparty&gt;&gt;
		You’re hosting a party at your Date Palm Street apartment. Despite the more intimate space compared to Prescott, the layout feels just right for a lively gathering. The living room and kitchen are seamlessly connected, creating a cozy yet vibrant atmosphere where guests naturally move between the two spaces. A sectional sofa in the living room offers plenty of seating, while some guests stand and chat near the kitchen island, sipping drinks and grabbing snacks.
		&lt;&lt;if !(V.hour gte 19 and V.hour lt 24 || V.hour gte 0 and V.hour lt 4)&gt;&gt;
			&lt;&lt;set $pchouseparty to false&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;else&gt;&gt;
		You are inside your Date Palm Street apartment. With two bedrooms and two bathrooms, the space is designed to be both modern and efficient. The open-concept layout for the living room and kitchen creates a seamless flow, ideal for entertaining or relaxing. 
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
	&lt;&lt;set $pclastresidence to $location&gt;&gt;
	
	&lt;br&gt;&lt;br&gt;
	&lt;&lt;if $pchouseparty&gt;&gt;
		Looks like $peopleatlocation.length people are here for your house party!
	&lt;&lt;else&gt;&gt;
		You're currently at the entrance of your apartment. 
		&lt;&lt;nobr&gt;&gt;
		&lt;&lt;peoplehere&gt;&gt;
		&lt;&lt;include EventRoommateInDorm&gt;&gt;
		&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;br&gt;&lt;br&gt;

&lt;&lt;godate&gt;&gt;
&lt;&lt;set _loc to passage()&gt;&gt;
	Your room is right inside. You can rest for a while if you want.&lt;br&gt;
	&lt;&lt;set $pceventresidenceaction to "rest"&gt;&gt;
    &lt;&lt;link  {text: &quot;Rest for a while&quot;, link: &quot;EventResidenceAction&quot;}&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 250) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Bedroom&quot;, link: &quot;DatePalmStYourRoom&quot;, emoji: &quot;🛏️&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your TV is in the living room. You can watch a few channels to pass time.&lt;br&gt;
	&lt;&lt;link {text: &quot;Watch TV&quot;, link: &quot;DatePalmStYourLivingRoom&quot;, emoji: &#39;📺&#39;}&gt;&gt;
		&lt;&lt;set $header to &quot;You sit back on the couch and flip on the TV for an hour or so.&quot;&gt;&gt;
		&lt;&lt;alterneed Relaxation 150&gt;&gt;
		&lt;&lt;safeadvtime 60 Relaxation&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 150&gt;&gt;&lt;br&gt;	
    &lt;&lt;link {text: &quot;Go to Living room&quot;, link: &quot;DatePalmStYourLivingRoom&quot;, emoji: &quot;🛋️&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	You can grab a bite to eat in the Kitchen.&lt;br&gt; 
    &lt;&lt;link &quot;Get some food&quot; &quot;DatePalmStYourKitchen&quot; &#39;🥫&#39;&gt;&gt;
        &lt;&lt;safeadvtime 10 Food&gt;&gt;
        &lt;&lt;alterneed Food 1000&gt;&gt;
        &lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;	
    &lt;&lt;link {text: &quot;Go to Kitchen&quot;, link: &quot;DatePalmStYourKitchen&quot;, emoji: &quot;🍲&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your bathroom is down the hall. &lt;br&gt;
	&lt;&lt;link &quot;Use the bathroom&quot; &quot;DatePalmStYourBathroom&quot; &#39;🚽&#39;&gt;&gt;
		&lt;&lt;alterneed Bladder 1000&gt;&gt;
		&lt;&lt;set $header to &quot;You step into the small bathroom, do your thing, and come back out.&quot;&gt;&gt;
		&lt;&lt;safeadvtime 5 Bladder Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Bathroom&quot;, link: &quot;DatePalmStYourBathroom&quot;, emoji: &quot;🚽&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;

	Go into your bedroom and change your clothes?
	&lt;&lt;link &quot;Clothes&quot; Wardrobe&gt;&gt;&lt;&lt;/link&gt;&gt;

	&lt;&lt;nobr&gt;&gt;
    A desk is built into the base of the window, offering a study area with a view.

    &lt;&lt;set _comp to setup.computer()&gt;&gt;
    &lt;&lt;if _comp&gt;&gt;
        You have &lt;&lt;aoran _comp&gt;&gt; _comp available to use.
    &lt;&lt;/if&gt;&gt;

    &lt;br&gt;
    &lt;&lt;link &quot;Study&quot; Study&gt;&gt;&lt;&lt;set $studyspan to 30&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Internet&quot; Computer&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _gamelink to {text: &quot;Play game&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _gamelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Video Gaming&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;

	&lt;&lt;if !$pchouseparty and V.hour gte 19&gt;&gt;
		Invite some friends over and host a party? Not a bad idea.
		&lt;&lt;link &quot;Host a party&quot; _loc &#39;🎉&#39;&gt;&gt;
			&lt;&lt;set $header to &quot;You invite your friends over and host a big party!&quot;&gt;&gt;
			&lt;&lt;alterneed attention 150&gt;&gt;
			&lt;&lt;set $pchouseparty to true&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 150&gt;&gt;&lt;br&gt;
    &lt;&lt;/if&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave Your Apartment&quot;, link: &quot;DatePalmSt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;unset $pcresidenceloc&gt;&gt;&lt;&lt;set $peopleatlocation = []&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12080" name="DatePalmStYourLivingRoom" tags="location locDatePalmStYourLivingRoom locblockDatePalmStInt" position="975,38100" size="100,100">
	&lt;&lt;if $pchouseparty&gt;&gt;
		You’re in the living room of your Date Palm Street apartment during the party. The space feels cozy yet vibrant, with guests scattered across the sectional sofa and a few standing near the walls, drink in hand, chatting and laughing. 
	&lt;&lt;else&gt;&gt;
		You are inside your living room. The space feels open and inviting, designed for both relaxation and entertaining. Large windows let natural light pour in, giving the room a warm, bright ambiance during the day. 
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	Your sofa looks pretty comfortable. You can sit back and rest for a while if you want.
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 125) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _restneeded&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;

	Your TV is here. You can watch a few channels to pass time. 
	&lt;&lt;nobr&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Watch TV&quot;, emoji: &#39;📺&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;safeadvtime 60 Relaxation&gt;&gt;
			&lt;&lt;run setup.Needs.enjoy(110)&gt;&gt;
			&lt;&lt;set _event to setup.Events.passage([&quot;lounge tv&quot;])&gt;&gt;
			&lt;&lt;egoto _event&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 110&gt;&gt;
		&lt;&lt;if $pc.skillleveled(&quot;Exhibitionism&quot;, 6) and $lastloungeporn isnot $gameday&gt;&gt;
			&lt;br&gt;
			&lt;&lt;set _link to {text: &quot;Watch porn&quot;, link: &quot;EventLoungePorn&quot;, emoji: &#39;💦&#39;}&gt;&gt;
			&lt;&lt;link _link&gt;&gt;
				&lt;&lt;raiseskill Exhibitionism 6&gt;&gt;
				&lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 3&gt;&gt;
				&lt;&lt;safeadvtime 60 Relaxation Arousal&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;skill Exhibitionism 6&gt;&gt; &lt;&lt;dalterneed Relaxation 120&gt;&gt; &lt;&lt;dalterneed Arousal 200&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Play video games&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
			&lt;&lt;run setup.Needs.enjoy(50)&gt;&gt;
			&lt;&lt;raiseskill &quot;Video Gaming&quot; 2&gt;&gt;
			&lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
			&lt;&lt;egoto _event&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	&lt;&lt;if $peopleatlocation.length gt 0&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Play game with somebody&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;set _eventpassage to setup.Events.passage(&quot;video game partner&quot;)&gt;&gt;
			&lt;&lt;if State.random() lte (setup.Events.base_event_chance() * 2.5)&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, attractiontopc: true, attractionfrompc: true, notsexpartner: true, inclinations: setup.archetypes.inclination_sets.voyeur, skills: [&quot;Video Gaming&quot;]})&gt;&gt;
			&lt;&lt;else&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, specialok: true, skills: [&quot;Video Gaming&quot;]})&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if $gamepartner is null&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, specialok: true})&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if $gamepartner is null&gt;&gt;
				&lt;&lt;set $loungemsg to &quot;You pick up a game controller, hoping for somebody to join you... but no one ever does.&quot;&gt;&gt;
				&lt;&lt;safeadvtime 5&gt;&gt;
				&lt;&lt;egoto _loc&gt;&gt;
			&lt;&lt;else&gt;&gt;
				&lt;&lt;safeadvtime 30 Relaxation Attention&gt;&gt;
				&lt;&lt;alterneed Relaxation 50&gt;&gt;
				&lt;&lt;socialize 30&gt;&gt;
				&lt;&lt;egoto _eventpassage&gt;&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt; &lt;&lt;dalterneed Attention 30&gt;&gt;
		&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;\
	

&lt;&lt;set _link to {text: &quot;Leave your living room&quot;, link: &quot;DatePalmStInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12090" name="DatePalmStYourRoom" tags="location locDatePalmStYourRoom locblockDatePalmStInt" position="975,38100" size="100,100">
	You are inside your Date Palm Street apartment bedroom. The space is cozy yet functional, with soft lighting and neutral tones that create a calming atmosphere.
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
   
&lt;&lt;set _loc to passage()&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	Your bed is right inside in the middle of the room. You can rest for a while if you want.&lt;br&gt;
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 250) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your queen sized bed sits in the middle of the room. You can go to sleep if you're tired.&lt;br&gt;
	&lt;&lt;set _sleeplink to {text: &quot;Sleep&quot;, link: &quot;Sleep&quot;, emoji: &quot;🛏️&quot;}&gt;&gt;
    &lt;&lt;link _sleeplink&gt;&gt;&lt;&lt;unset $attemptednavigation&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;if $peopleatlocation.length is 0 and $pc.skillleveled(&quot;Disinhibition&quot;, 1)&gt;&gt;
        &lt;&lt;set _mastlink to {text: &quot;Masturbate in bed&quot;, link: &quot;EncounterRound&quot;, emoji: &quot;💦&quot;}&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link _mastlink&gt;&gt;
            &lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;], endpassage: $pcresidenceloc, intro_text: &quot;You&#39;re alone. You get into bed and stretch out comfortably, ready to touch yourself.&quot;})&gt;&gt;
            &lt;&lt;raiseskill Disinhibition 1&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;skill Disinhibition 1&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;set _pets to setup.dorm_category_items(&quot;pet&quot;)&gt;&gt;
	&lt;&lt;for _pet range _pets&gt;&gt;
		&lt;&lt;if _pet&gt;&gt;
			&lt;br&gt;&lt;br&gt;
			&lt;&lt;set _action to setup.randel(setup.dormstuff[_pet.item].actions)&gt;&gt;
			&lt;&lt;set _name to _pet.name || _pet.item&gt;&gt;
			&lt;&lt;if _pet.petname&gt;&gt;&lt;&lt;= _pet.petname&gt;&gt; the &lt;&lt;= _name&gt;&gt;
			&lt;&lt;else&gt;&gt;Your &lt;&lt;= _name&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			is _action
			&lt;br&gt;
			&lt;&lt;if !_pet.petname&gt;&gt;
				&lt;&lt;link &quot;Name your pet&quot; DormPetName&gt;&gt;&lt;&lt;/link&gt;&gt;
				&lt;br&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;link &quot;Interact&quot; DormPetInteract&gt;&gt;

			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt; &lt;&lt;dalterneed Attention 15&gt;&gt; &lt;&lt;dalterneed Relaxation 15&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/for&gt;&gt;
	
    &lt;&lt;set _bookshelf to setup.dorm_category_item(&quot;books&quot;)&gt;&gt;
    &lt;&lt;if _bookshelf and _bookshelf.collection&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        You have &lt;&lt;= _bookshelf.name&gt;&gt;.
        &lt;br&gt;
        &lt;&lt;link &quot;Read something&quot; DormRead&gt;&gt;

        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;set _decor to setup.decor_names()&gt;&gt;
    &lt;&lt;if _decor.length gt 0&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        Your side of the room is decorated with &lt;&lt;and _decor&gt;&gt;.
        &lt;br&gt;
        &lt;&lt;link &quot;Look at your stuff&quot; DormInventory&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if $dormstuff and $dormstuff.length gt 0&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        You&#39;ve accumulated some possessions since arriving here.
        &lt;br&gt;
        &lt;&lt;link &quot;Look at your stuff&quot; DormInventory&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;set _exerapps to [&quot;adjustable dumbbells&quot;, &quot;yoga mat&quot;]&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Exercise&quot; DormExercise&gt;&gt;&lt;&lt;/link&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;

	Change your clothes?
	&lt;&lt;link &quot;Clothes&quot; Wardrobe&gt;&gt;&lt;&lt;/link&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bedroom&quot;, link: &quot;DatePalmStInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12100" name="DatePalmStYourSecondBedroom" tags="location locDatePalmStYourSecondBedroom locblockDatePalmStInt" position="975,38100" size="100,100">
	You are inside your second smaller bedroom. This cozy space is designed to maximize comfort while keeping it functional. A twin or full-sized bed is positioned against one wall, adorned with soft bedding and a couple of decorative pillows, creating a welcoming spot for rest.
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	Your second bedroom's bed is right inside on the right side of the room. You can rest for a while if you want.
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 250) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bedroom&quot;, link: &quot;DatePalmStInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12110" name="DatePalmStYourBathroom" tags="location locDatePalmStYourSecondBedroom locblockDatePalmStInt" position="975,38100" size="100,100">
	You are inside your small apartment bathroom. Despite its compact size, the space is well-designed for efficiency and comfort.
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	You can take a shower or use the bathroom. &lt;br&gt;
    &lt;&lt;link &quot;Use the shower&quot; _loc &#39;🚿&#39;&gt;&gt;
        &lt;&lt;alterneed Hygiene 1000&gt;&gt;
        &lt;&lt;set $header to &quot;You step into the small bathroom and strip off for a quick shower, then dry off and get dressed.&quot;&gt;&gt;
        &lt;&lt;safeadvtime 15 Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 15&gt;&gt; &lt;&lt;dalterneed Hygiene 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;link &quot;Use the bathroom&quot; _loc &#39;🚽&#39;&gt;&gt;
		&lt;&lt;alterneed Bladder 1000&gt;&gt;
		&lt;&lt;set $header to &quot;You step into the small bathroom, do your thing, and come back out.&quot;&gt;&gt;
		&lt;&lt;safeadvtime 5 Bladder Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt; 
	&lt;&lt;/nobr&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bathroom&quot;, link: &quot;DatePalmStInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12120" name="DatePalmStYourKitchen" tags="location locDatePalmStYourKitchen locblockDatePalmStInt" position="975,38100" size="100,100">
	You are inside your small kitchen. This efficient space is designed for both functionality and style, making the most of its compact layout. The kitchen features a large fridge, a toaster, hot plate, microwave, and coffeemaker. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	You can grab some food quickly and go about your day.&lt;br&gt;
    &lt;&lt;link &quot;Get some food&quot; _loc &#39;🥫&#39;&gt;&gt;
        &lt;&lt;safeadvtime 10 Food&gt;&gt;
        &lt;&lt;alterneed Food 1000&gt;&gt;
        &lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;

&lt;&lt;nobr&gt;&gt;
	The Kitchen has a large fridge you can put food in.&lt;br&gt;
    &lt;&lt;set _foodapps to [&quot;toaster&quot;, &quot;hot plate&quot;, &quot;microwave&quot;]&gt;&gt;
    &lt;&lt;set _has to [&quot;toaster&quot;, &quot;hot plate&quot;, &quot;microwave&quot;]&gt;&gt;
    &lt;&lt;for _foodapp range _foodapps&gt;&gt;
        &lt;&lt;if setup.dorm_has(_foodapp)&gt;&gt;
            &lt;&lt;run _has.push(setup.a_or_an(_foodapp) + &quot; &quot; + _foodapp)&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/for&gt;&gt;
    &lt;&lt;if _has.length gt 0&gt;&gt;
        You&#39;ve got &lt;&lt;and _has&gt;&gt; to prepare food with.
    &lt;&lt;/if&gt;&gt;
        You &lt;&lt;if _has.length gt 0&gt;&gt;also &lt;&lt;/if&gt;&gt;have a coffeemaker.
&lt;&lt;/nobr&gt;&gt;
&lt;&lt;link &quot;Fridge&quot; DormFoodStash&gt;&gt;&lt;&lt;/link&gt;&gt;


&lt;&lt;set _link to {text: &quot;Leave your Kitchen&quot;, link: &quot;DatePalmStInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;unset $pcresidenceloc&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
~~
<tw-passagedata pid="3048" name="PrescottRd" tags="location locPrescottRd locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🔱" position="975,38100" size="100,100">You are on Prescott Road. This are is well-landscaped and home to a row of Greek houses. Frat boys and sorority girls abound.&lt;&lt;if $exhibitionsneak&gt;&gt; The decorative foliage is dense here, making it fairly easy to hide.&lt;&lt;/if&gt;&gt;

&lt;&lt;exits&gt;&gt;
&lt;&lt;map&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="3048" name="PrescottRd" tags="location locPrescottRd locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🔱" position="975,38100" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Prescott Road. This are is well-landscaped and home to a row of Greek houses. Frat boys and sorority girls abound.&lt;&lt;if $exhibitionsneak&gt;&gt; The decorative foliage is dense here, making it fairly easy to hide.&lt;&lt;/if&gt;&gt;

    &lt;&lt;if $pc.owns_residence(&quot;PrescottRd&quot;)&gt;&gt;
		&lt;&lt;link &quot;Your House&quot; PrescottRdInt &gt;&gt;
			&lt;&lt;advtime 1&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;&lt;br&gt;
		&lt;&lt;link &quot;Remove Residence&quot; EventResidenceAction &gt;&gt;
			&lt;&lt;run $pc.remove_residence(&quot;PrescottRd&quot;)&gt;&gt; 
				&lt;&lt;set $pceventresidenceaction = "removed PrescottRd"&gt;&gt;
			&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;advtime 1&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;set _buyresidencelink to {text: &quot;Buy Residence&quot;, emoji: &quot;🏢&quot;}&gt;&gt;
        &lt;&lt;link _buyresidencelink EventResidenceAction&gt;&gt; 
			&lt;&lt;set _rescost to $pc.calc_residences_cost(&quot;PrescottRd&quot;)&gt;&gt;
			&lt;&lt;if $pcmoney gte _rescost&gt;&gt;
				&lt;&lt;run $pc.add_residence(&quot;PrescottRd&quot;)&gt;&gt; 
				&lt;&lt;run $pcmoney -= _rescost&gt;&gt;
				&lt;&lt;set $pceventresidenceaction = "bought PrescottRd"&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;else&gt;&gt;
				&lt;&lt;set $pceventresidenceaction = "not enough money"&gt;&gt;
				&lt;&lt;egoto EventResidenceAction&gt;&gt; 
			&lt;&lt;/if&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; 
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/nobr&gt;&gt;&lt;br&gt;
&lt;&lt;exits&gt;&gt;
&lt;&lt;map&gt;&gt;</tw-passagedata>
<tw-passagedata pid="12130" name="PrescottRdInt" tags="location locPrescottRdInt locblockPrescottRd" position="975,38100" size="100,100">
&lt;&lt;nobr&gt;&gt;
	&lt;&lt;if $pchouseparty&gt;&gt;
			You’re hosting a party at your Prescott Road house. The open layout creates the perfect flow for guests, with the spacious living room and kitchen as the center of attention. Friends are mingling on the cozy couches and armchairs, while others have gathered around the kitchen island, where drinks and snacks are laid out. The living room’s large windows bring in a soft evening glow, adding to the warm, inviting vibe of the house.
		&lt;&lt;if !(V.hour gte 19 and V.hour lt 24 || V.hour gte 0 and V.hour lt 4)&gt;&gt;
			&lt;&lt;set $pchouseparty to false&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;else&gt;&gt;
		You are inside your Prescott Road House. With three Bedrooms and three Bathrooms, a wide open area for the living room, and kitchen, your House feels both spacious and cozy. Large windows let in plenty of natural light, casting a warm glow over the open space. 
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
	&lt;&lt;set $pclastresidence to $location&gt;&gt;
	
	&lt;br&gt;&lt;br&gt;
	&lt;&lt;if $pchouseparty&gt;&gt;
		Looks like $peopleatlocation.length people are here for your house party!
	&lt;&lt;else&gt;&gt;
		&lt;&lt;nobr&gt;&gt;
		You're currently at the entrance of your house. 
		&lt;&lt;peoplehere&gt;&gt;
		&lt;&lt;include EventRoommateInDorm&gt;&gt;
		&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;br&gt;&lt;br&gt;

&lt;&lt;godate&gt;&gt;
&lt;&lt;set _loc to passage()&gt;&gt;
	Your room is right inside. You can rest for a while if you want.&lt;br&gt;
	&lt;&lt;set $pceventresidenceaction to "rest"&gt;&gt;
    &lt;&lt;link  {text: &quot;Rest for a while&quot;, link: &quot;EventResidenceAction&quot;}&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 300) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Bedroom&quot;, link: &quot;PrescottRdYourRoom&quot;, emoji: &quot;🛏️&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your TV is in the living room. You can watch a few channels to pass time.&lt;br&gt;
	&lt;&lt;link {text: &quot;Watch TV&quot;, link: &quot;PrescottRdYourLivingRoom&quot;, emoji: &#39;📺&#39;}&gt;&gt;
		&lt;&lt;set $header to &quot;You sit back on the couch and flip on the TV for an hour or so.&quot;&gt;&gt;
		&lt;&lt;alterneed Relaxation 150&gt;&gt;
		&lt;&lt;safeadvtime 60 Relaxation&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 150&gt;&gt;&lt;br&gt;	
    &lt;&lt;link {text: &quot;Go to Living room&quot;, link: &quot;PrescottRdYourLivingRoom&quot;, emoji: &quot;🛋️&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	You can grab a bite to eat in the Kitchen.&lt;br&gt; 
    &lt;&lt;link &quot;Get some food&quot; &quot;PrescottRdYourKitchen&quot; &#39;🥫&#39;&gt;&gt;
        &lt;&lt;safeadvtime 10 Food&gt;&gt;
        &lt;&lt;alterneed Food 1000&gt;&gt;
        &lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;	
    &lt;&lt;link {text: &quot;Go to Kitchen&quot;, link: &quot;PrescottRdYourKitchen&quot;, emoji: &quot;🍲&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your bathroom is down the hall. &lt;br&gt;
	&lt;&lt;link &quot;Use the bathroom&quot; &quot;PrescottRdYourBathroom&quot; &#39;🚽&#39;&gt;&gt;
		&lt;&lt;alterneed Bladder 1000&gt;&gt;
		&lt;&lt;set $header to &quot;You step into the small bathroom, do your thing, and come back out.&quot;&gt;&gt;
		&lt;&lt;safeadvtime 5 Bladder Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt;
    &lt;&lt;link {text: &quot;Go to Bathroom&quot;, link: &quot;PrescottRdYourBathroom&quot;, emoji: &quot;🚽&quot;}&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt; 
	&lt;&lt;/nobr&gt;&gt;

	Go into your bedroom and change your clothes?
	&lt;&lt;link &quot;Clothes&quot; Wardrobe&gt;&gt;&lt;&lt;/link&gt;&gt;

	&lt;&lt;nobr&gt;&gt;
    A desk is built into the base of the window, offering a study area with a view.

    &lt;&lt;set _comp to setup.computer()&gt;&gt;
    &lt;&lt;if _comp&gt;&gt;
        You have &lt;&lt;aoran _comp&gt;&gt; _comp available to use.
    &lt;&lt;/if&gt;&gt;

    &lt;br&gt;
    &lt;&lt;link &quot;Study&quot; Study&gt;&gt;&lt;&lt;set $studyspan to 30&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Internet&quot; Computer&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _gamelink to {text: &quot;Play game&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _gamelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Video Gaming&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if !$pchouseparty and V.hour gte 19&gt;&gt;
		Invite some friends over and host a party? Not a bad idea.
		&lt;&lt;link &quot;Host a party&quot; _loc &#39;🎉&#39;&gt;&gt;
			&lt;&lt;set $header to &quot;You invite your friends over and host a big party!&quot;&gt;&gt;
			&lt;&lt;alterneed attention 150&gt;&gt;
			&lt;&lt;set $pchouseparty to true&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed attention 150&gt;&gt;&lt;br&gt;
    &lt;&lt;/if&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave Your House&quot;, link: &quot;PrescottRd&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;unset $pcresidenceloc&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12140" name="PrescottRdYourLivingRoom" tags="location locPrescottRdYourLivingRoom locblockPrescottRdInt" position="975,38100" size="100,100">
	&lt;&lt;if $pchouseparty&gt;&gt;
			You’re in the living room of your Prescott Road house during the party, and the space feels alive with energy. The room is spacious, with guests lounging on the plush couches and armchairs, while others stand by the large windows, drinks in hand, enjoying the open, airy atmosphere. 
		&lt;&lt;else&gt;&gt;
			You are inside your living room. The space feels open and inviting, designed for both relaxation and entertaining. Large windows let natural light pour in, giving the room a warm, bright ambiance during the day. 
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	Your sofa looks pretty comfortable. You can sit back and rest for a while if you want.
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _restneeded to 1000 - setup.Needs.get_need(&quot;Rest&quot;)&gt;&gt;
        &lt;&lt;set _mins to (_restneeded / 125) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _restneeded&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;

	Your TV is here. You can watch a few channels to pass time. 
	&lt;&lt;nobr&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Watch TV&quot;, emoji: &#39;📺&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;safeadvtime 60 Relaxation&gt;&gt;
			&lt;&lt;run setup.Needs.enjoy(110)&gt;&gt;
			&lt;&lt;set _event to setup.Events.passage([&quot;lounge tv&quot;])&gt;&gt;
			&lt;&lt;egoto _event&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 110&gt;&gt;
		&lt;&lt;if $pc.skillleveled(&quot;Exhibitionism&quot;, 6) and $lastloungeporn isnot $gameday&gt;&gt;
			&lt;br&gt;
			&lt;&lt;set _link to {text: &quot;Watch porn&quot;, link: &quot;EventLoungePorn&quot;, emoji: &#39;💦&#39;}&gt;&gt;
			&lt;&lt;link _link&gt;&gt;
				&lt;&lt;raiseskill Exhibitionism 6&gt;&gt;
				&lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 3&gt;&gt;
				&lt;&lt;safeadvtime 60 Relaxation Arousal&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;skill Exhibitionism 6&gt;&gt; &lt;&lt;dalterneed Relaxation 120&gt;&gt; &lt;&lt;dalterneed Arousal 200&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Play video games&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
			&lt;&lt;run setup.Needs.enjoy(50)&gt;&gt;
			&lt;&lt;raiseskill &quot;Video Gaming&quot; 2&gt;&gt;
			&lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
			&lt;&lt;egoto _event&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	&lt;&lt;if $peopleatlocation.length gt 0&gt;&gt;
		&lt;&lt;set _link to {text: &quot;Play game with somebody&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
		&lt;&lt;link _link&gt;&gt;
			&lt;&lt;set _eventpassage to setup.Events.passage(&quot;video game partner&quot;)&gt;&gt;
			&lt;&lt;if State.random() lte (setup.Events.base_event_chance() * 2.5)&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, attractiontopc: true, attractionfrompc: true, notsexpartner: true, inclinations: setup.archetypes.inclination_sets.voyeur, skills: [&quot;Video Gaming&quot;]})&gt;&gt;
			&lt;&lt;else&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, specialok: true, skills: [&quot;Video Gaming&quot;]})&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if $gamepartner is null&gt;&gt;
				&lt;&lt;set $gamepartner to setup.Events.pick_person({type: &quot;student&quot;, specialok: true})&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if $gamepartner is null&gt;&gt;
				&lt;&lt;set $loungemsg to &quot;You pick up a game controller, hoping for somebody to join you... but no one ever does.&quot;&gt;&gt;
				&lt;&lt;safeadvtime 5&gt;&gt;
				&lt;&lt;egoto _loc&gt;&gt;
			&lt;&lt;else&gt;&gt;
				&lt;&lt;safeadvtime 30 Relaxation Attention&gt;&gt;
				&lt;&lt;alterneed Relaxation 50&gt;&gt;
				&lt;&lt;socialize 30&gt;&gt;
				&lt;&lt;egoto _eventpassage&gt;&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt; &lt;&lt;dalterneed Attention 30&gt;&gt;
		&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;\
	

&lt;&lt;set _link to {text: &quot;Leave your living room&quot;, link: &quot;PrescottRdInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12150" name="PrescottRdYourRoom" tags="location locPrescottRdYourRoom locblockPrescottRdInt" position="975,38100" size="100,100">
	You are inside your Prescott Road house bedroom. The room feels spacious and tranquil, with large windows that let in natural light, making the space feel warm and inviting during the day. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
   
&lt;&lt;set _loc to passage()&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	Your bed is right inside in the middle of the room. You can rest for a while if you want.&lt;br&gt;
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 300) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/nobr&gt;&gt;
	
	&lt;&lt;nobr&gt;&gt;
	Your queen sized bed sits in the middle of the room. You can go to sleep if you're tired.&lt;br&gt;
	&lt;&lt;set _sleeplink to {text: &quot;Sleep&quot;, link: &quot;Sleep&quot;, emoji: &quot;🛏️&quot;}&gt;&gt;
    &lt;&lt;link _sleeplink&gt;&gt;&lt;&lt;unset $attemptednavigation&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;if $peopleatlocation.length is 0 and $pc.skillleveled(&quot;Disinhibition&quot;, 1)&gt;&gt;
        &lt;&lt;set _mastlink to {text: &quot;Masturbate in bed&quot;, link: &quot;EncounterRound&quot;, emoji: &quot;💦&quot;}&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link _mastlink&gt;&gt;
            &lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;], endpassage: $pcresidenceloc, intro_text: &quot;You&#39;re alone. You get into bed and stretch out comfortably, ready to touch yourself.&quot;})&gt;&gt;
            &lt;&lt;raiseskill Disinhibition 1&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;skill Disinhibition 1&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;set _pets to setup.dorm_category_items(&quot;pet&quot;)&gt;&gt;
	&lt;&lt;for _pet range _pets&gt;&gt;
		&lt;&lt;if _pet&gt;&gt;
			&lt;br&gt;&lt;br&gt;
			&lt;&lt;set _action to setup.randel(setup.dormstuff[_pet.item].actions)&gt;&gt;
			&lt;&lt;set _name to _pet.name || _pet.item&gt;&gt;
			&lt;&lt;if _pet.petname&gt;&gt;&lt;&lt;= _pet.petname&gt;&gt; the &lt;&lt;= _name&gt;&gt;
			&lt;&lt;else&gt;&gt;Your &lt;&lt;= _name&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			is _action
			&lt;br&gt;
			&lt;&lt;if !_pet.petname&gt;&gt;
				&lt;&lt;link &quot;Name your pet&quot; DormPetName&gt;&gt;&lt;&lt;/link&gt;&gt;
				&lt;br&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;link &quot;Interact&quot; DormPetInteract&gt;&gt;

			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt; &lt;&lt;dalterneed Attention 15&gt;&gt; &lt;&lt;dalterneed Relaxation 15&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/for&gt;&gt;
	
    &lt;&lt;set _bookshelf to setup.dorm_category_item(&quot;books&quot;)&gt;&gt;
    &lt;&lt;if _bookshelf and _bookshelf.collection&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        You have &lt;&lt;= _bookshelf.name&gt;&gt;.
        &lt;br&gt;
        &lt;&lt;link &quot;Read something&quot; DormRead&gt;&gt;

        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;set _decor to setup.decor_names()&gt;&gt;
    &lt;&lt;if _decor.length gt 0&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        Your side of the room is decorated with &lt;&lt;and _decor&gt;&gt;.
        &lt;br&gt;
        &lt;&lt;link &quot;Look at your stuff&quot; DormInventory&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if $dormstuff and $dormstuff.length gt 0&gt;&gt;
        &lt;br&gt;&lt;br&gt;
        You&#39;ve accumulated some possessions since arriving here.
        &lt;br&gt;
        &lt;&lt;link &quot;Look at your stuff&quot; DormInventory&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;set _exerapps to [&quot;adjustable dumbbells&quot;, &quot;yoga mat&quot;]&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Exercise&quot; DormExercise&gt;&gt;&lt;&lt;/link&gt;&gt;
	&lt;&lt;/nobr&gt;&gt;

	Change your clothes?
	&lt;&lt;link &quot;Clothes&quot; Wardrobe&gt;&gt;&lt;&lt;/link&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bedroom&quot;, link: &quot;PrescottRdInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12160" name="PrescottRdYourSecondBedroom" tags="location locPrescottRdYourSecondBedroom locblockPrescottRdInt" position="975,38100" size="100,100">
	You are inside your Prescott Road house's second bedroom. This room is cozy and versatile, perfect for guests or a home office setup. A full-sized bed, dressed in soft, neutral-toned linens, is tucked against one wall, with a small nightstand beside it holding a lamp and a few essentials. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	Your second bedroom's bed is right inside on the right side of the room. You can rest for a while if you want.
    &lt;&lt;link &quot;Rest for a while&quot; _loc&gt;&gt;
        &lt;&lt;set _rest to 250&gt;&gt;
        &lt;&lt;set _mins to (_rest / 250) * 60&gt;&gt;
        &lt;&lt;safeadvtime _mins Rest&gt;&gt;
        &lt;&lt;alterneed Rest _rest&gt;&gt;
        &lt;&lt;set $header to &quot;You go into your room and let yourself drift off to sleep, giving your body as much time as it needs to rest.&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dalterneed Rest 1000&gt;&gt;&lt;br&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bedroom&quot;, link: &quot;PrescottRdInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12170" name="PrescottRdYourBathroom" tags="location locPrescottRdYourSecondBedroom locblockPrescottRdInt" position="975,38100" size="100,100">
	You are inside your Prescott Road house bathroom. The space is bright and modern, with sleek finishes that create a spa-like atmosphere. The walls are tiled in soft, neutral tones, complementing the dark wood vanity that provides plenty of storage beneath a stylish quartz countertop. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	&lt;&lt;nobr&gt;&gt;
	You can take a shower or use the bathroom. &lt;br&gt;
    &lt;&lt;link &quot;Use the shower&quot; _loc &#39;🚿&#39;&gt;&gt;
        &lt;&lt;alterneed Hygiene 1000&gt;&gt;
        &lt;&lt;set $header to &quot;You step into the small bathroom and strip off for a quick shower, then dry off and get dressed.&quot;&gt;&gt;
        &lt;&lt;safeadvtime 15 Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 15&gt;&gt; &lt;&lt;dalterneed Hygiene 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;link &quot;Use the bathroom&quot; _loc &#39;🚽&#39;&gt;&gt;
		&lt;&lt;alterneed Bladder 1000&gt;&gt;
		&lt;&lt;set $header to &quot;You step into the small bathroom, do your thing, and come back out.&quot;&gt;&gt;
		&lt;&lt;safeadvtime 5 Bladder Hygiene&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt; 
	&lt;&lt;/nobr&gt;&gt;

&lt;&lt;set _link to {text: &quot;Leave your Bathroom&quot;, link: &quot;PrescottRdInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="12180" name="PrescottRdYourKitchen" tags="location locPrescottRdYourKitchen locblockPrescottRdInt" position="975,38100" size="100,100">
	You are inside your Prescott Road house kitchen. The space feels open and welcoming, with a modern yet homey vibe that makes it the heart of the house. The kitchen comes with an extra large fridge, a toaster, hot plate, microwave, and coffeemaker. 
	&lt;&lt;set $pcresidenceloc to $location&gt;&gt;

&lt;&lt;set _loc to passage()&gt;&gt;
	You can grab some food quickly and go about your day.&lt;br&gt;
    &lt;&lt;link &quot;Get some food&quot; _loc &#39;🥫&#39;&gt;&gt;
        &lt;&lt;safeadvtime 10 Food&gt;&gt;
        &lt;&lt;alterneed Food 1000&gt;&gt;
        &lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;

&lt;&lt;nobr&gt;&gt;
	The Kitchen has a large fridge you can put food in.&lt;br&gt;
    &lt;&lt;set _foodapps to [&quot;toaster&quot;, &quot;hot plate&quot;, &quot;microwave&quot;]&gt;&gt;
    &lt;&lt;set _has to [&quot;toaster&quot;, &quot;hot plate&quot;, &quot;microwave&quot;]&gt;&gt;
    &lt;&lt;for _foodapp range _foodapps&gt;&gt;
        &lt;&lt;if setup.dorm_has(_foodapp)&gt;&gt;
            &lt;&lt;run _has.push(setup.a_or_an(_foodapp) + &quot; &quot; + _foodapp)&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/for&gt;&gt;
    &lt;&lt;if _has.length gt 0&gt;&gt;
        You&#39;ve got &lt;&lt;and _has&gt;&gt; to prepare food with.
    &lt;&lt;/if&gt;&gt;
        You &lt;&lt;if _has.length gt 0&gt;&gt;also &lt;&lt;/if&gt;&gt;have a coffeemaker.
&lt;&lt;/nobr&gt;&gt;
&lt;&lt;link &quot;Fridge&quot; DormFoodStash&gt;&gt;&lt;&lt;/link&gt;&gt;


&lt;&lt;set _link to {text: &quot;Leave your Kitchen&quot;, link: &quot;PrescottRdInt&quot;, emoji: &#39;🚪&#39;}&gt;&gt;\
&lt;&lt;link _link&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;unset $pcresidenceloc&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
~~
<tw-passagedata pid="3073" name="YourDorm" tags="location locYourDorm locblockResidenceHall roomtypedorm sleep endsneak emoji🛏️" position="350,38475" size="100,100">&lt;&lt;nobr&gt;&gt;
~
<tw-passagedata pid="3073" name="YourDorm" tags="location locYourDorm locblockResidenceHall roomtypedorm sleep endsneak emoji🛏️" position="350,38475" size="100,100">&lt;&lt;nobr&gt;&gt;&lt;&lt;set $pclastresidence to $location&gt;&gt;&lt;&lt;set $pcresidenceloc to $location&gt;&gt;
~~
&lt;&lt;set _getuppassage to &quot;YourDorm&quot;&gt;&gt;
~
&lt;&lt;set _getuppassage to $pcresidenceloc;&gt;&gt;	
~~
&lt;&lt;if _getuppassage isnot &quot;YourDorm&quot;&gt;&gt;
    &lt;&lt;set _getuppassage to $postencounterpassage&gt;&gt;
&lt;&lt;/if&gt;&gt;
~
&lt;&lt;if _getuppassage isnot &quot;YourDorm&quot;&gt;&gt;
    &lt;&lt;set _getuppassage to $postencounterpassage&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if $pcresidenceloc&gt;&gt;
    &lt;&lt;set _getuppassage to $pcresidenceloc&gt;&gt;
&lt;&lt;else&gt;&gt;
    &lt;&lt;set _exitpassage to &quot;YourDorm&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
~~
&lt;&lt;link &quot;Done&quot; YourDorm&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata>
~
&lt;&lt;if $pcresidenceloc&gt;&gt;
    &lt;&lt;set _exitpassage to $pcresidenceloc&gt;&gt;
&lt;&lt;else&gt;&gt;
    &lt;&lt;set _exitpassage to &quot;YourDorm&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;link &quot;Done&quot; _exitpassage&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata>
~~
[[Done|YourDorm]]</tw-passagedata><tw-passagedata pid="3065" name="MainHall" tags="location locMainHall locblockResidenceHall roomtypeempty emoji🚪 nobr" position="600,38350" size="100,100">
~
&lt;&lt;if $pcresidenceloc&gt;&gt;
    &lt;&lt;set _exitpassage to $pcresidenceloc&gt;&gt;
&lt;&lt;else&gt;&gt;
    &lt;&lt;set _exitpassage to &quot;YourDorm&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
[[Done|_exitpassage]]</tw-passagedata><tw-passagedata pid="3065" name="MainHall" tags="location locMainHall locblockResidenceHall roomtypeempty emoji🚪 nobr" position="600,38350" size="100,100">
~~

setup.computer = function()
{
	let comp = this.dorm_category_item("computer");
	let laptop = this.dorm_category_item("laptop");
	if (V.location == "YourDorm")
	{
		if (laptop && comp)
		{
			if (setup.dormstuff[laptop.item].streamQuality.base > setup.dormstuff[comp.item].streamQuality.base)
			{
				return laptop.item;
			}
			else
			{
				return comp.item;
			}
		}
		else if (comp)
		{
			return comp.item;
		}
		else if (laptop)
		{
			return laptop.item;
		}
	}
	else if (!V.pc.has_laptop())
	{
		return null;
	}
	else if (laptop)
	{
		return laptop.item;
	}
}~

setup.computer = function()
{
	let comp = this.dorm_category_item("computer");
	let laptop = this.dorm_category_item("laptop");
	let validLocations = ["YourDorm", "BancroftLnInt", "BancroftLnYourLivingRoom", "BancroftLnYourRoom", "DatePalmStInt", "DatePalmStYourLivingRoom", "DatePalmStYourRoom", "PrescottRdInt", "PrescottRdYourLivingRoom", "PrescottRdYourRoom"]; // Add more locations as needed
	
	if (validLocations.includes(V.location))
	{
		if (laptop && comp)
		{
			if (setup.dormstuff[laptop.item].streamQuality.base > setup.dormstuff[comp.item].streamQuality.base)
			{
				return laptop.item;
			}
			else
			{
				return comp.item;
			}
		}
		else if (comp)
		{
			return comp.item;
		}
		else if (laptop)
		{
			return laptop.item;
		}
	}
	else if (!V.pc.has_laptop())
	{
		return null;
	}
	else if (laptop)
	{
		return laptop.item;
	}
}
~~
};
/* twine-user-script #14: "database_events.js" */
~
    "dog":
    {
        category: "pet",
        add: "dog",
        description: "The perfect loyal companion for active owners who love daily adventures.",
        name: "%color dog",
        price: 220,
        "sub color": [
            "tan",
            "light brown",
            "brown",
            "dark brown",
            "golden brown",
            "black",
            "white",
            "gray",
            "white and brown dappled",
        ],
        actions: [
            "wagging its tail excitedly, waiting for a treat.",
            "performing the \"Sit!\" trick with enthusiasm.",
            "sniffing around, exploring every corner.",
            "staring at you with those big, soulful eyes.",
        ],
        interactions:
        [
            "You talk to your %name about what's been going on in your life.",
            "You watch your %name relaxing in its bed.",
            "You gently pat your %name so that it knows that you love it.",
            "You sit with your %name and spend time petting it.",
            "You take your %name out of its bed and let it climb all over you.",
        ],
    },

    "cat":
    {
        category: "pet",
        add: "cat",
        description: "The independent yet affectionate pet for those who appreciate a bit of mystery and charm.",
        name: "%color cat",
        price: 240,
        "sub color": [
            "tan",
            "light brown",
            "brown",
            "dark brown",
            "golden brown",
            "black",
            "white",
            "gray",
            "white and brown dappled",
        ],
        actions: [
            "curled up in a sunbeam, napping peacefully.",
            "batting at a toy with graceful precision.",
            "staring out the window like it's contemplating the universe.",
            "giving you a slow blink of approval from across the room.",
        ],
        interactions:
        [
            "You talk to your %name about what's been going on in your life.",
            "You watch your %name relaxing in its bed.",
            "You gently pat your %name so that it knows that you love it.",
            "You sit with your %name and spend time petting it.",
            "You take your %name out of its bed and let it climb all over you.",
        ],
    },

};
/* twine-user-script #14: "database_events.js" */
~~
        ]
    },
    "JT Ult Books":
    {
~
            {"label": "Mammals"},
            {"label": "Dog", "type": "dormstuff", "item": "dog"},
            {"label": "Cat", "type": "dormstuff", "item": "cat"},
        ]
    },
    "JT Ult Books":
    {
~~
        else if (itemobj.category == "pet" && setup.dorm_category_item(itemobj.category))
        {
            retval.result = false;
            retval.reason = "You already own a pet.";
        }
~

~~
    // BOOKSHELF
~

    "car":
    {
        category: "travel",
        description: "This is a reliable enough car. You'll still have to deal with traffic and the occasional tight parking spot, but you figure you could cut your commute time in half. Too bad the city's streets are always packed during rush hour.",
        add: "car",
        price: 4600,
    },

    "sports car":
    {
        category: "travel",
        description: "This is a sleek sports car. You'll still face speed limits and the usual traffic jams, but on open roads, you'd feel the thrill of cutting your travel time down in style. Too bad the city's filled with stoplights and speed bumps.",
        add: "sports car",
        price: 46000,
    },

    "motorbike":
    {
        category: "travel",
        description: "This is a nimble motorbike. You'll still deal with some traffic and unpredictable weather, but you could weave through congested streets and cut your travel time dramatically. Too bad the potholes and uneven roads keep you on edge.",
        add: "motorbike",
        price: 6000,
    },

    // BOOKSHELF
~~
        ]
    },
    "JT Ult Electronics":
~
			{"label": "Motorbike", "type": "dormstuff", "item": "motorbike"},
			{"label": "Car", "type": "dormstuff", "item": "car"},
			{"label": "Sports Car", "type": "dormstuff", "item": "sports car"},
        ]
    },
    "JT Ult Electronics":
~~
        Transport:&lt;br&gt;
        &lt;&lt;link &quot;Take bus into town&quot; BusInterior&gt;&gt;
            &lt;&lt;if setup.dorm_has(&quot;bicycle&quot;)&gt;&gt;
                &lt;&lt;set $header to &quot;The bus doesn&#39;t have a bike rack and the town doesn&#39;t have many bike paths anyway, so you just lock it up here at the parking lot before you board.&quot;&gt;&gt;
            &lt;&lt;/if&gt;&gt;
            &lt;&lt;set $busdestination to &quot;RiversidePlaza&quot;&gt;&gt;
            &lt;&lt;advtime 20&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt;
~
        Transport:&lt;br&gt;
			&lt;&lt;link &quot;Take bus into town&quot; BusInterior&gt;&gt;
				&lt;&lt;if setup.dorm_has(&quot;bicycle&quot;)&gt;&gt;
					&lt;&lt;set $header to &quot;The bus doesn&#39;t have a bike rack and the town doesn&#39;t have many bike paths anyway, so you just lock it up here at the parking lot before you board.&quot;&gt;&gt;
				&lt;&lt;/if&gt;&gt;
				&lt;&lt;set $busdestination to &quot;RiversidePlaza&quot;&gt;&gt;
				&lt;&lt;advtime 20&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt;
			&lt;&lt;if setup.dorm_has(&quot;sports car&quot;, true)&gt;&gt;
				&lt;br&gt;
				&lt;&lt;link &quot;Take sports car into town&quot; RiversidePlaza&gt;&gt;
					&lt;&lt;advtime 10&gt;&gt;
				&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 10&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if setup.dorm_has(&quot;car&quot;, true)&gt;&gt;
				&lt;br&gt;
				&lt;&lt;link &quot;Take car into town&quot; RiversidePlaza&gt;&gt;
					&lt;&lt;advtime 20&gt;&gt;
				&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if setup.dorm_has(&quot;motorbike&quot;, true)&gt;&gt;
				&lt;br&gt;
				&lt;&lt;link &quot;Take motorbike into town&quot; RiversidePlaza&gt;&gt;
					&lt;&lt;advtime 20&gt;&gt;
				&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt;
			&lt;&lt;/if&gt;&gt;
~~
Transport:
&lt;&lt;link &quot;Take bus back to campus&quot; BusInterior&gt;&gt;&lt;&lt;unset $plazareturnlink&gt;&gt;&lt;&lt;set $busdestination to &quot;StudentParking&quot;&gt;&gt;&lt;&lt;advtime 20&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt;
~
&lt;&lt;nobr&gt;&gt;
Transport:&lt;br&gt;
&lt;&lt;link &quot;Take bus back to campus&quot; BusInterior&gt;&gt;
	&lt;&lt;unset $plazareturnlink&gt;&gt;
	&lt;&lt;set $busdestination to &quot;StudentParking&quot;&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt;
&lt;&lt;if setup.dorm_has(&quot;sports car&quot;, true)&gt;&gt;
	&lt;br&gt;
	&lt;&lt;link &quot;Take sports car back to campus&quot; StudentParking&gt;&gt;
		&lt;&lt;unset $plazareturnlink&gt;&gt;
		&lt;&lt;advtime 10&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 10&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if setup.dorm_has(&quot;car&quot;, true)&gt;&gt;
	&lt;br&gt;
	&lt;&lt;link &quot;Take Car back to campus&quot; StudentParking&gt;&gt;
		&lt;&lt;unset $plazareturnlink&gt;&gt;
		&lt;&lt;advtime 20&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 10&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if setup.dorm_has(&quot;motorbike&quot;, true)&gt;&gt;
	&lt;br&gt;
	&lt;&lt;link &quot;Take motorbike back to campus&quot; StudentParking&gt;&gt;
		&lt;&lt;unset $plazareturnlink&gt;&gt;
		&lt;&lt;advtime 20&gt;&gt;
	&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 10&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;/nobr&gt;&gt;
~~
setup.is_pcroommate = function(person1)
{
    let db = setup.people_db();
	let student = db[person1];
	if (student.roommate == "PC")
		return true;
	else
		return false;
}
~
setup.is_pcroommate = function(person1)
{
    let db = setup.people_db();
	let student = db[person1];
	if (student.roommate == "PC")
		return true;
	else
		return false;
}

setup.set_roommateresidence = function(person1, residence)
{
    let db = setup.people_db();
    db[person1].residence = residence;
}
~~
            &lt;&lt;if setup.is_pcroommate($eventnpc)&gt;&gt;
            &lt;&lt;set _linkname to &quot;Remove Roommate&quot;&gt;&gt;
				&lt;&lt;link _linkname RemoveRoommateDialogue&gt;&gt;
				&lt;&lt;run setup.remove_roommates($eventnpc)&gt;&gt;
				&lt;&lt;/link&gt;&gt;
                &lt;br&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/if&gt;&gt;
~
            &lt;&lt;if setup.is_pcroommate($eventnpc)&gt;&gt;
            &lt;&lt;set _linkname to &quot;Remove Roommate&quot;&gt;&gt;
				&lt;&lt;link _linkname RemoveRoommateDialogue&gt;&gt;
					&lt;&lt;run setup.remove_roommates($eventnpc)&gt;&gt;
					&lt;&lt;run setup.people_db()[$eventnpc].schedule = 2;&gt;&gt;
				&lt;&lt;/link&gt;&gt;
				&lt;&lt;if $eventnpc.residence != &quot;Chicory Hall&quot;&gt;&gt;
					&lt;br&gt;
					&lt;&lt;link &quot;Set Dorm to Chicory Hall&quot; $location&gt;&gt;
						&lt;&lt;run setup.set_roommateresidence($eventnpc, "BancroftLn")&gt;&gt;
					&lt;&lt;/link&gt;&gt;
				&lt;&lt;/if&gt;&gt;
				&lt;&lt;if $pc.owns_residence(&quot;BancroftLn&quot;) and $eventnpc.residence != &quot;BancroftLn&quot;&gt;&gt;
					&lt;br&gt;
					&lt;&lt;link &quot;Set Suite to Bancroft Lane&quot; $location&gt;&gt;
						&lt;&lt;run setup.set_roommateresidence($eventnpc, "BancroftLn")&gt;&gt;
					&lt;&lt;/link&gt;&gt;
				&lt;&lt;/if&gt;&gt;
				&lt;&lt;if $pc.owns_residence(&quot;DatePalmSt&quot;) and $eventnpc.residence != &quot;DatePalmSt&quot;&gt;&gt;
					&lt;br&gt;
					&lt;&lt;link &quot;Set Apartment to Date Palm Street&quot; $location&gt;&gt;
						&lt;&lt;run setup.set_roommateresidence($eventnpc, "DatePalmSt")&gt;&gt;
					&lt;&lt;/link&gt;&gt;
				&lt;&lt;/if&gt;&gt;
				&lt;&lt;if $pc.owns_residence(&quot;PrescottRd&quot;) and $eventnpc.residence != &quot;PrescottRd&quot;&gt;&gt;
					&lt;br&gt;
					&lt;&lt;link &quot;Set House to Prescott Road&quot; $location&gt;&gt;
						&lt;&lt;run setup.set_roommateresidence($eventnpc, "PrescottRd")&gt;&gt;
					&lt;&lt;/link&gt;&gt;
				&lt;&lt;/if&gt;&gt;
                &lt;br&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/if&gt;&gt;
~~
	else if (setup.School.is_pc_at_class(true) && (V.inclass || V.prevclass))
~
	else if (locblock == "BancroftLn")
	{ 
		let classestoday = setup.School.classes_today();
		let dayoffconstants = ["showers", "restroom", "food", "home"];

		const scheduleslots = setup.Time.current_schedule_slot_calcall();
		
		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			if (pinfo.residence == "BancroftLn")
				belonghere = true;
				
			if (pinfo.type == "student" && belonghere)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (loc == "BancroftLnInt")
				{
					retval.push(person);
				}
				if (loc = "BancroftLnYourLivingRoom")
				{
					if (slotloc == "free time")
					{
						retval.push(person);
					}
				}
				if (loc == "BancroftLnYourBathroom")
				{
					if (slotloc == "showers")
					{
					retval.push(person);
					}
				}
				if (loc == "BancroftLnYourKitchen")
				{
					if (slotloc == "food")
					{
					retval.push(person);
					}
				}
			}
			else if (belonghere)
			{
				retval.push(person);
			}
		}
	}
	else if (locblock == "DatePalmSt")
	{
		let classestoday = setup.School.classes_today();
		let dayoffconstants = ["showers", "restroom", "food", "home"];

		const scheduleslots = setup.Time.current_schedule_slot_calcall();
		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			if (pinfo.residence == "DatePalmSt" && pinfo.roommate == "PC")
				belonghere = true;
				
			if (pinfo.type == "student" && belonghere)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (loc == "DatePalmStInt")
				{
					retval.push(person);
				}
				if (loc = "DatePalmStYourLivingRoom")
				{
					if (slotloc == "free time")
					{
						retval.push(person);
					}
				}
				if (loc == "DatePalmStYourBathroom")
				{
					if (slotloc == "showers")
					{
					retval.push(person);
					}
				}
				if (loc == "DatePalmStYourKitchen")
				{
					if (slotloc == "food")
					{
					retval.push(person);
					}
				}
			}
			else if (belonghere)
			{
				retval.push(person);
			}
			else if (V.pchouseparty && V.hour < 4 && V.hour > 19)
			{
				let chanceToJoin = Math.random(); 
				if (belonghere)
				{
					retval.push(person);
				}
				if (chanceToJoin <= 0.1)
				{
					if ((setup.people.get_attitude(person, "friendship")) > 10)
					{
						retval.push(person);
					}
				}
				if (chanceToJoin <= 0.5)
				{
					if ((setup.people.get_attitude(person, "friendship")) > 800)
					{
						retval.push(person);
					}
					if ((setup.people.get_attitude(person, "romance")) > 800)
					{
						retval.push(person);
					}
					if ((setup.people.get_attitude(person, "lust")) > 800)
					{
						retval.push(person);
					}
				}
			}
		}
	}
	else if (locblock == "PrescottRd")
	{
		let classestoday = setup.School.classes_today();
		let dayoffconstants = ["showers", "restroom", "food", "home"];

		const scheduleslots = setup.Time.current_schedule_slot_calcall();
		
		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			if (pinfo.residence == "PrescottRd" && pinfo.roommate == "PC")
				belonghere = true;
				
			if (pinfo.type == "student" && belonghere)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (loc == "PrescottRdInt")
				{
					retval.push(person);
				}
				if (loc = "PrescottRdYourLivingRoom")
				{
					if (slotloc == "free time")
					{
						retval.push(person);
					}
				}
				if (loc == "PrescottRdYourBathroom")
				{
					if (slotloc == "showers")
					{
					retval.push(person);
					}
				}
				if (loc == "PrescottRdYourKitchen")
				{
					if (slotloc == "food")
					{
					retval.push(person);
					}
				}
			}
			else if (belonghere)
			{
				retval.push(person);
			}
			else if (V.pchouseparty)
			{
				let chanceToJoin = Math.random(); 
				if (belonghere)
				{
					retval.push(person);
				}
				if (chanceToJoin <= 0.1)
				{
					if ((setup.people.get_attitude(person, "friendship")) > 10)
					{
						retval.push(person);
					}
				}
				if (chanceToJoin <= 0.5)
				{
					if ((setup.people.get_attitude(person, "friendship")) > 800)
					{
						retval.push(person);
					}
					if ((setup.people.get_attitude(person, "romance")) > 800)
					{
						retval.push(person);
					}
					if ((setup.people.get_attitude(person, "lust")) > 800)
					{
						retval.push(person);
					}
				}
			}
		}
	}
	else if (setup.School.is_pc_at_class(true) && (V.inclass || V.prevclass))
~~
<tw-passagedata pid="2079" name="EventHangoutGoHomePostDate" tags="event hangout nobr" position="1100,25975" size="100,100">&lt;&lt;set _desrel to setup.people.desired_relationship($eventnpc)&gt;&gt;
&lt;&lt;set _gooddate to (_desrel is &quot;fuckbuddy&quot; and $hangout.heat gte 5) or (setup.people.willing_date($eventnpc) and ($hangout.romance gte 5 or $hangout.heat gte 10))&gt;&gt;
&lt;&lt;set _ndates to setup.Relationships.dates($eventnpc) + 1&gt;&gt;
&lt;&lt;if $eventnpc == $niches[&quot;The Classroom Admirer&quot;] and setup.has_dated_admirer() and !setup.people.has_had_sex($eventnpc) and _ndates gte 3&gt;&gt;
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj glance&gt;&gt; at you, &lt;&lt;conj hesitate&gt;&gt; for a moment, then finally &lt;&lt;conj say&gt;&gt;, &quot;Do you... I mean, would you... want to, like... come over... to my place?&quot;
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;pssc&gt;&gt; about as nervous as you&#39;ve ever seen &lt;&lt;po&gt;&gt;.
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;set _linkname to &quot;Go over to &quot; + setup.people.pronouns($eventnpc).pp + &quot; place&quot;&gt;&gt;
    &lt;&lt;link _linkname EventHangoutDateEncounter&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Take me home&quot; EventHangoutDateGoHomeRide&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Let&#39;s call it a night&quot; EventHangoutDateGoodbye&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;elseif _gooddate and setup.people.willing_sex($eventnpc) and (setup.people.allow_free_interaction($eventnpc) or ($eventnpc == $niches[&quot;The Classroom Admirer&quot;] and setup.has_dated_admirer() and setup.people.has_had_sex($eventnpc)))&gt;&gt;
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj smile&gt;&gt; at you. &quot;Time to call it a night? Or do you... want to come over?&quot;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;ppc&gt;&gt; intentions are pretty clear. If you agree, this night certainly isn&#39;t over yet.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;set _linkname to &quot;Go over to &quot; + setup.people.pronouns($eventnpc).pp + &quot; place&quot;&gt;&gt;
    &lt;&lt;link _linkname EventHangoutDateEncounter&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Take me home&quot; EventHangoutDateGoHomeRide&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Let&#39;s call it a night&quot; EventHangoutDateGoodbye&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    &quot;You want a ride home?&quot;
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;link &quot;Sure&quot; EventHangoutDateGoHomeRide&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;No thanks&quot; EventHangoutDateGoodbye&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="2079" name="EventHangoutGoHomePostDate" tags="event hangout nobr" position="1100,25975" size="100,100">&lt;&lt;set _desrel to setup.people.desired_relationship($eventnpc)&gt;&gt;
&lt;&lt;set _gooddate to (_desrel is &quot;fuckbuddy&quot; and $hangout.heat gte 5) or (setup.people.willing_date($eventnpc) and ($hangout.romance gte 5 or $hangout.heat gte 10))&gt;&gt;
&lt;&lt;set _ndates to setup.Relationships.dates($eventnpc) + 1&gt;&gt;
&lt;&lt;if $eventnpc == $niches[&quot;The Classroom Admirer&quot;] and setup.has_dated_admirer() and !setup.people.has_had_sex($eventnpc) and _ndates gte 3&gt;&gt;
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj glance&gt;&gt; at you, &lt;&lt;conj hesitate&gt;&gt; for a moment, then finally &lt;&lt;conj say&gt;&gt;, &quot;Do you... I mean, would you... want to, like... come over... to my place?&quot;
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;pssc&gt;&gt; about as nervous as you&#39;ve ever seen &lt;&lt;po&gt;&gt;.
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;set _linkname to &quot;Go over to &quot; + setup.people.pronouns($eventnpc).pp + &quot; place&quot;&gt;&gt;
    &lt;&lt;link _linkname EventHangoutDateEncounter&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;link &quot;Take me home&quot; EventHangoutDateGoHomeRide&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;if setup.dorm_has(&quot;sports car&quot;, true) or setup.dorm_has(&quot;car&quot;, true) or setup.dorm_has(&quot;motorbike&quot;, true)&gt;&gt;
    &lt;&lt;link &quot;I&#39;ll ride home&quot; EventHangoutDateGoHomeSelfRide&gt;&gt;&lt;&lt;advtime 20&gt;&gt;&lt;&lt;/link&gt;&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;br&gt;
    &lt;&lt;link &quot;Let&#39;s call it a night&quot; EventHangoutDateGoodbye&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;elseif _gooddate and setup.people.willing_sex($eventnpc) and (setup.people.allow_free_interaction($eventnpc) or ($eventnpc == $niches[&quot;The Classroom Admirer&quot;] and setup.has_dated_admirer() and setup.people.has_had_sex($eventnpc)))&gt;&gt;
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj smile&gt;&gt; at you. &quot;Time to call it a night? Or do you... want to come over?&quot;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;ppc&gt;&gt; intentions are pretty clear. If you agree, this night certainly isn&#39;t over yet.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;set _linkname to &quot;Go over to &quot; + setup.people.pronouns($eventnpc).pp + &quot; place&quot;&gt;&gt;
    &lt;&lt;link _linkname EventHangoutDateEncounter&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Take me home&quot; EventHangoutDateGoHomeRide&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;if setup.dorm_has(&quot;sports car&quot;, true) or setup.dorm_has(&quot;car&quot;, true) or setup.dorm_has(&quot;motorbike&quot;, true)&gt;&gt;
    &lt;&lt;link &quot;I&#39;ll ride home&quot; EventHangoutDateGoHomeSelfRide&gt;&gt;&lt;&lt;advtime 20&gt;&gt;&lt;&lt;/link&gt;&gt;
	&lt;&lt;/if&gt;&gt;&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Let&#39;s call it a night&quot; EventHangoutDateGoodbye&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    &quot;You want a ride home?&quot;
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;link &quot;Sure&quot; EventHangoutDateGoHomeRide&gt;&gt;&lt;&lt;advtime 40&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;No thanks&quot; EventHangoutDateGoodbye&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;if setup.dorm_has(&quot;sports car&quot;, true) or setup.dorm_has(&quot;car&quot;, true) or setup.dorm_has(&quot;motorbike&quot;, true)&gt;&gt;
    &lt;&lt;link &quot;I&#39;ll ride home&quot; EventHangoutDateGoHomeSelfRide&gt;&gt;&lt;&lt;advtime 20&gt;&gt;&lt;&lt;/link&gt;&gt;
	&lt;&lt;/if&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
~~
<tw-passagedata pid="2086" name="EventHangoutDateGoHomeRide" tags="event nobr hangout" position="725,26100" size="100,100">&lt;&lt;firstname $eventnpc&gt;&gt; calls a ride for you, then makes sure you get back to your residence hall safe.&lt;&lt;set $hangout.startlocation to &quot;MainHall&quot;&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;include EventHangoutDateKissMenu&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="2086" name="EventHangoutDateGoHomeRide" tags="event nobr hangout" position="725,26100" size="100,100">&lt;&lt;firstname $eventnpc&gt;&gt; calls a ride for the both of you, then makes sure you get back to your residence hall safe.&lt;&lt;set $hangout.startlocation to &quot;MainHall&quot;&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;include EventHangoutDateKissMenu&gt;&gt;</tw-passagedata>
<tw-passagedata pid="12190" name="EventHangoutDateGoHomeSelfRide" tags="event nobr hangout" position="725,26100" size="100,100">&lt;&lt;firstname $eventnpc&gt;&gt; rides home with you, and you both make sure to get back to your residence hall safely.&lt;&lt;set $hangout.startlocation to &quot;MainHall&quot;&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;include EventHangoutDateKissMenu&gt;&gt;</tw-passagedata>
~~
        &quot;just chill&quot;:
        {
            location: _yourplacelocation,
            msgs: [&quot;Ah, just a chill night? I&#39;m down&quot;, &quot;Sure, we can stream a movie or two&quot;, &quot;Just a night in? Works for me&quot;],
            locmsg: _yourplacemsg,
            askmsg: &quot;Maybe we can just chill and watch some videos or stream a movie&quot;,
        },
        &quot;hang out as a group&quot;:
        {
            location: _yourplacelocation,
            msgs: [&quot;Us and some friends? I&#39;m down&quot;, &quot;Sure, sounds fun&quot;, &quot;Yeah, a bunch of friends and stuff sounds cool&quot;],
            locmsg: _yourplacemsg,
            askmsg: &quot;Maybe we can get some friends together and hang out as a group&quot;,
            relationships: [&quot;friend&quot;, &quot;best friend&quot;, &quot;fuckbuddy&quot;, &quot;partner&quot;, &quot;open partner&quot;, &quot;poly partner&quot;, &quot;soulmate&quot;],
            types: [&quot;hangout&quot;],
            group: true,
        },
~
        &quot;just chill&quot;:
        {
            location: $pclastresidence,
            msgs: [&quot;Ah, just a chill night? I&#39;m down&quot;, &quot;Sure, we can stream a movie or two&quot;, &quot;Just a night in? Works for me&quot;],
            locmsg: &quot;Text me when you&#39;re in your room and I&#39;ll come over&quot;,
            askmsg: &quot;Maybe we can just chill and watch some videos or stream a movie&quot;,
        },
        &quot;hang out as a group&quot;:
        {
            location: $pclastresidence,
            msgs: [&quot;Us and some friends? I&#39;m down&quot;, &quot;Sure, sounds fun&quot;, &quot;Yeah, a bunch of friends and stuff sounds cool&quot;],
            locmsg: &quot;Text me when you&#39;re in your room and I&#39;ll come over&quot;,
            askmsg: &quot;Maybe we can get some friends together and hang out as a group&quot;,
            relationships: [&quot;friend&quot;, &quot;best friend&quot;, &quot;fuckbuddy&quot;, &quot;partner&quot;, &quot;open partner&quot;, &quot;poly partner&quot;, &quot;soulmate&quot;],
            types: [&quot;hangout&quot;],
            group: true,
        },
~~
You text &lt;&lt;anonorfullname $eventnpc&gt;&gt; to let &lt;&lt;po&gt;&gt; know you&#39;ve arrived. A moment later, &lt;&lt;ps&gt;&gt; &lt;&lt;conj come&gt;&gt; out to show you into &lt;&lt;pp&gt;&gt; _place.&lt;br&gt;
&lt;br&gt;
&quot;I got snacks, drinks, Discpix on the &lt;&lt;if _place is &quot;dorm&quot;&gt;&gt;laptop&lt;&lt;else&gt;&gt;TV&lt;&lt;/if&gt;&gt;,&quot; &lt;&lt;ps&gt;&gt; &lt;&lt;conj say&gt;&gt;. &quot;We can just chill tonight.&quot;&lt;br&gt;
&lt;br&gt;
~
&lt;&lt;anonorfullname $eventnpc&gt;&gt; texts you to let you know &lt;&lt;ps&gt;&gt; had arrived. A moment later, &lt;&lt;ps&gt;&gt; &lt;&lt;conj come&gt;&gt; to you.
&lt;br&gt;&lt;br&gt;
&quot;I see you've got snacks, drinks, Discpix on the &lt;&lt;if _place is &quot;dorm&quot;&gt;&gt;laptop&lt;&lt;else&gt;&gt;TV&lt;&lt;/if&gt;&gt;,&quot; &lt;&lt;ps&gt;&gt; &lt;&lt;conj say&gt;&gt;. &quot;We can just chill tonight.&quot;&lt;br&gt;
&lt;br&gt;
~~
    {
        passage: "EventHangoutChillRoommate",
        tags: ["hangout", "date", "just chill", "2", "3"],
        frequency: 100,
        checkvar: '!["house", "apartment"].includes(setup.people.lives($hangout.partner)) and $people[$eventnpc].roommate and $people[$eventnpc].roommate isnot $eventnpc and $people[$eventnpc].roommate isnot "PC"',
    },
~
    {
        passage: "EventHangoutChillRoommate",
        tags: ["hangout", "date", "just chill", "2", "3"],
        frequency: 0,
        checkvar: '!["house", "apartment"].includes(setup.people.lives($hangout.partner)) and $people[$eventnpc].roommate and $people[$eventnpc].roommate isnot $eventnpc and $people[$eventnpc].roommate isnot "PC"',
    },
~~
        &quot;hang out as a polycule&quot;:
        {
            location: _yourplacelocation,
            msgs: [&quot;Just us and our partners, that sounds nice&quot;],
            locmsg: _yourplacemsg,
            askmsg: &quot;Maybe we can get the polycule together and see what happens&quot;,
            relationships: [&quot;poly partner&quot;],
            group: true,
        },
        &quot;hang out with the subs&quot;:
        {
            location: _yourplacelocation,
            msgs: [&quot;Just us and the subs, that sounds nice&quot;],
            locmsg: _yourplacemsg,
            askmsg: &quot;Maybe we can get the subs all together and see what happens&quot;,
            relationships: [&quot;submissive&quot;],
            group: true,
        },
~
        &quot;hang out as a polycule&quot;:
        {
            location: $pclastresidence,
            msgs: [&quot;Just us and our partners, that sounds nice&quot;],
            locmsg: &quot;Text me when you&#39;re in your room and I&#39;ll get us together&quot;,
            askmsg: &quot;Maybe we can get the polycule together and see what happens&quot;,
            relationships: [&quot;poly partner&quot;],
            group: true,
        },
        &quot;hang out with the subs&quot;:
        {
            location: $pclastresidence,
            msgs: [&quot;Just us and the subs, that sounds nice&quot;],
            locmsg: &quot;Text me when you&#39;re in your room and I&#39;ll get us together&quot;,
            askmsg: &quot;Maybe we can get the subs all together and see what happens&quot;,
            relationships: [&quot;submissive&quot;],
            group: true,
        },
~~
		if (Story.has('PassageReady')) {
			try {
				passageReadyOutput = Wikifier.wikifyEval(Story.get('PassageReady').text);
			}
			catch (ex) {
				console.error(ex);
				Alert.error('PassageReady', ex.message);
			}
		}
~
		if (Story.has('PassageReady')) {
			try {
				passageReadyOutput = Wikifier.wikifyEval(Story.get('PassageReady').text);
			}
			catch (ex) {
				console.error(`PassageReady error: ${ex.message}`);
				// Set a default value or skip to a safe fallback to keep the game running.
				passageReadyOutput = "An issue occurred loading this section."; // Placeholder text
			}
		}
~~