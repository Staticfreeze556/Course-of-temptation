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

setup.Maps.Residence = {
    name: "Residence",
    defaultmaptab: "Campus",
    nodes: {
        "Residence": {name: "Residence", img: "loc_reshall"},
    },
}
~~
&lt;&lt;set $pcage to 18&gt;&gt;
~
&lt;&lt;set $pcage to 18&gt;&gt;

&lt;&lt;set $pcresidenceowner to ""&gt;&gt;
&lt;&lt;set $pcresidenceowners to []&gt;&gt;
&lt;&lt;set $pcresidenceeventst to false&gt;&gt;
&lt;&lt;set $pcresidenceprevevent to ""&gt;&gt;
&lt;&lt;set $pcnpclivingwith to ""&gt;&gt;
~~
                &lt;&lt;run setup.people.set_attitude(&quot;The Best Friend&quot;, &quot;romance&quot;, 400)&gt;&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
    &lt;&lt;/if&gt;&gt;&lt;br&gt;
&lt;&lt;/if&gt;&gt;
~
                &lt;&lt;run setup.people.set_attitude(&quot;The Best Friend&quot;, &quot;romance&quot;, 400)&gt;&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
    &lt;&lt;/if&gt;&gt;&lt;br&gt;
&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;set _residience to &quot;Chicory Hall&quot;&gt;&gt;
	&lt;&lt;displayresidents&gt;&gt;

~~

                            &lt;&lt;if _date.partner is _p and _date.activity is &quot;just chill&quot; and _date.day is $gameday&gt;&gt;
                                &lt;&lt;set $hangout to {partner: _date.partner, type: _date.type, activity: _date.activity, stage: 1, events: [], heat: 0, romance: 0, fun: 2, startlocation: $location}&gt;&gt;
                                &lt;&lt;set $hangout.starting_attitude to Object.assign({}, $people[$hangout.partner].attitude || {})&gt;&gt;
                                &lt;&lt;clearplanneddate _date&gt;&gt;
                            &lt;&lt;/if&gt;&gt;
                        &lt;&lt;/for&gt;&gt;
                    &lt;&lt;/if&gt;&gt;
                &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/if&gt;&gt;
        &lt;br&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;link &quot;Back to main hall&quot; MainHall&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
~

                            &lt;&lt;if _date.partner is _p and _date.activity is &quot;just chill&quot; and _date.day is $gameday&gt;&gt;
                                &lt;&lt;set $hangout to {partner: _date.partner, type: _date.type, activity: _date.activity, stage: 1, events: [], heat: 0, romance: 0, fun: 2, startlocation: $location}&gt;&gt;
                                &lt;&lt;set $hangout.starting_attitude to Object.assign({}, $people[$hangout.partner].attitude || {})&gt;&gt;
                                &lt;&lt;clearplanneddate _date&gt;&gt;
                            &lt;&lt;/if&gt;&gt;
                        &lt;&lt;/for&gt;&gt;
                    &lt;&lt;/if&gt;&gt;
                &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/if&gt;&gt;
        &lt;br&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;link &quot;Back to main hall&quot; MainHall&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
<tw-passagedata pid="30620" name="Residence" tags="location noevents locResidence locblockResidence roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $eventnpc to $pcresidenceowner&gt;&gt;
&lt;&lt;set _pobj to setup.people.get_person($pcresidenceowner)&gt;&gt;

&lt;&lt;set _res to _pobj.residence&gt;&gt;
&lt;&lt;if _res eq &quot;Helleborine Hall&quot; or _res eq &quot;Chicory Hall&quot;&gt;&gt;
	&lt;&lt;set _resn to &quot;dorm&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _res eq &quot;Date Palm Street&quot; or _res eq &quot;DatePalmSt&quot;&gt;&gt;
	&lt;&lt;set _resn to &quot;apartment&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _res eq &quot;Saffron Street&quot; or _res eq &quot;SaffronSt&quot;&gt;&gt;
	&lt;&lt;set _resn to &quot;house&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _res eq &quot;off-campus&quot;&gt;&gt;
	&lt;&lt;set _resn to &quot;apartment&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
			
&lt;&lt;set _s to setup.people.firstname($pcresidenceowner) + &quot;&#39;s&quot; + " " + _resn&gt;&gt;

You are at _s!&lt;br&gt;&lt;br&gt;

You knock to see if $pcresidenceowner is in &lt;&lt;pp&gt;&gt; room. After a moment, &lt;&lt;ps&gt;&gt; &lt;&lt;conj pop&gt;&gt; the door open and smiles as &lt;&lt;ps&gt;&gt; &lt;&lt;conj see&gt;&gt; you.&lt;br&gt;&lt;br&gt;

"Hey &lt;&lt;nickname $pc&gt;&gt;," &lt;&lt;ps&gt;&gt; &lt;&lt;conj say&gt;&gt;, standing back to let you in.&lt;br&gt;&lt;br&gt;

&lt;&lt;if _resn eq &quot;dorm&quot;&gt;&gt;
_s room is a compact space filled with personal touches. A bed takes up one corner, covered with a comfortable looking comforter, while a desk cluttered with books and a laptop occupies another. Posters and photos hang on the walls, showcasing favorite memories with friends and family. 
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _resn eq &quot;apartment&quot;&gt;&gt;
_s features an open layout that maximizes space and light. The living area is furnished with a comfy couch and a coffee table, perfect for hanging out with friends. A small dining table sits adjacent to the kitchen, which has modern appliances and plenty of counter space. One bedroom offers a cozy retreat with a neatly made bed and personal decorations. 
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _resn eq &quot;house&quot;&gt;&gt;
_s has a warm and inviting feel. The front yard features a small garden, while the entry leads into a spacious living room filled with natural light. An open kitchen connects to a dining area, making it great for family meals or entertaining. There are two bedrooms, each decorated to reflect personal style, and a cozy den for relaxing or studying. 
&lt;&lt;/if&gt;&gt; &lt;br&gt;&lt;br&gt;

&lt;&lt;if $pcnpclivingwith neq $pcresidenceowner&gt;&gt;
	Main Actions:&lt;br&gt;
		&lt;&lt;set _chatevents to setup.Events.assemble_set([&quot;resident&quot;, &quot;chat&quot;])&gt;&gt;
		&lt;&lt;run setup.shuffle(_chatevents)&gt;&gt;
		&lt;&lt;set _chatevent to _chatevents[0].passage&gt;&gt;
			
		&lt;&lt;if $peopleatlocation.includes($pcresidenceowner)&gt;&gt;
			&lt;&lt;set _hangevent to _chatevent&gt;&gt;
			&lt;&lt;link &quot;Hang out&quot; _hangevent&gt;&gt;
				&lt;&lt;advtime 60 Attention Relaxation&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
			
			&lt;&lt;set _movieevent to &quot;EventResidentWatchMovieStart&quot;&gt;&gt;
			&lt;&lt;link &quot;Watch a movie&quot; _movieevent&gt;&gt;
				&lt;&lt;advtime 120 Attention Relaxation&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 120&gt;&gt;&lt;br&gt;
			
		<!---&lt;&lt;if !_rmhere&gt;&gt;
				&lt;&lt;set _sexevent to &quot;EventResidentWatchSexStart&quot;&gt;&gt;
				&lt;&lt;if _sexevent&gt;&gt;
					&lt;&lt;link &quot;Talk about sex&quot; _sexevent&gt;&gt;
						&lt;&lt;advtime 60 Attention Relaxation&gt;&gt;
					&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
				&lt;&lt;/if&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;br&gt;--->
		&lt;&lt;/if&gt;&gt;


	&lt;&lt;set _allowed to []&gt;&gt;
	&lt;&lt;set _desrel to setup.people.desired_relationship($eventnpc)&gt;&gt;
	&lt;&lt;if setup.people.willing_date($eventnpc)&gt;&gt;
		&lt;&lt;set _allowed to [&quot;pee&quot;, &quot;shower&quot;]&gt;&gt;
		&lt;&lt;if $hour gte 21 or $hour lt 6&gt;&gt;
			&lt;&lt;run _allowed.push(&quot;sleep&quot;)&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;elseif _desrel is &quot;fuckbuddy&quot; or _desrel is &quot;friend&quot;&gt;&gt;
		&lt;&lt;set _allowed to [&quot;pee&quot;, &quot;shower&quot;]&gt;&gt;
		&lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gte 500 and ($hour gte 22 or $hour lt 6)&gt;&gt;
			&lt;&lt;run _allowed.push(&quot;sleep&quot;)&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;elseif _desrel is &quot;hatefuck&quot; or _desrel is &quot;rival&quot;&gt;&gt;
	&lt;&lt;else&gt;&gt;
		&lt;&lt;set _allowed to [&quot;pee&quot;, &quot;shower&quot;]&gt;&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;run _allowed.push(&quot;wash&quot;)&gt;&gt;
	&lt;&lt;if setup.people.willing_sex($eventnpc) and setup.people.get_attitude($eventnpc, &quot;lust&quot;) gte 800&gt;&gt;
		&lt;&lt;run _allowed.push(&quot;fuck&quot;)&gt;&gt;
	&lt;&lt;/if&gt;&gt;

	&lt;&lt;if _allowed.includes(&quot;fuck&quot;)&gt;&gt;
		&lt;&lt;link &quot;Have sex&quot; EncounterRound&gt;&gt;
			&lt;&lt;unset $round2available&gt;&gt;
			&lt;&lt;set _role to $pc.has_part(&quot;penis&quot;) ? &quot;top&quot; : &quot;bottom&quot;&gt;&gt;
			&lt;&lt;set _npcexp to new Person({person: $eventnpc})&gt;&gt;
			&lt;&lt;run _npcexp.remove_all_clothing()&gt;&gt;
			&lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;, _npcexp], endpassage: &quot;Residence&quot;, starting_position: &quot;Cowgirl&quot;, starting_role: setup.people.is_masc($pc) ? &quot;bottom&quot; : &quot;top&quot;,})&gt;&gt;
		&lt;&lt;/link&gt;&gt;
		&lt;br&gt;
	&lt;&lt;/if&gt;&gt;

	&lt;br&gt;
	Other Actions:&lt;br&gt;
	&lt;&lt;if _allowed.includes(&quot;pee&quot;)&gt;&gt;
		&lt;&lt;link &quot;Use the bathroom&quot;&gt;&gt;&lt;&lt;advtime 5&gt;&gt;&lt;&lt;alterneed Bladder 1000&gt;&gt;&lt;&lt;set $header to &quot;You head into the bathroom and relieve yourself.&quot;&gt;&gt;&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.includes(&quot;shower&quot;)&gt;&gt;
		&lt;&lt;link &quot;Take a shower&quot;&gt;&gt;&lt;&lt;advtime 20&gt;&gt;&lt;&lt;alterneed Hygiene 1000&gt;&gt;&lt;&lt;set $header to &quot;You grab a shower.&quot;&gt;&gt;&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt; &lt;&lt;dalterneed Hygiene 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.includes(&quot;wash&quot;)&gt;&gt;
		&lt;&lt;link &quot;Wash up&quot;&gt;&gt;&lt;&lt;advtime 5&gt;&gt;&lt;&lt;alterneed Hygiene 50&gt;&gt;&lt;&lt;set $header to &quot;You quickly wash up.&quot;&gt;&gt;&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Hygiene 50&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.includes(&quot;sleep&quot;)&gt;&gt;
		&lt;&lt;link &quot;Sleep&quot; Sleep2&gt;&gt;&lt;&lt;unset $round2available&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.length gt 0&gt;&gt;
		&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gte 900 or setup.people.get_attitude($eventnpc, &quot;romance&quot;) gte 900 or setup.people.get_attitude($eventnpc, &quot;lust&quot;) gte 900&gt;&gt;
		&lt;&lt;link &quot;Live with them?&quot; &quot;Residence&quot;&gt;&gt;
			&lt;&lt;set $pcnpclivingwith to $pcresidenceowner&gt;&gt;
		&lt;&lt;/link&gt;&gt;
	&lt;&lt;/if&gt;&gt;&lt;br&gt;


	&lt;&lt;set _rmhere to false&gt;&gt;
	&lt;&lt;set _rm to _pobj.roommate&gt;&gt;
	&lt;&lt;if $peopleatlocation.includes(_rm) and _rm isnot _pobj&gt;&gt;
		That&#39;d be &lt;&lt;anonorfullname _rm&gt;&gt;, who&#39;s at &lt;&lt;pp&gt;&gt; desk doing something, pretending &lt;&lt;ps&gt;&gt; can&#39;t hear every word you and your friend say. Dorm life is kinda awkward sometimes.
		&lt;&lt;set _rmhere to true&gt;&gt;
	&lt;&lt;else&gt;&gt;
		Luckily the roommate doesn&#39;t seem to be here right now, giving you some privacy with your friend.
	&lt;&lt;/if&gt;&gt;&lt;br&gt;&lt;br&gt;
&lt;&lt;/if&gt;&gt;

&lt;&lt;if $pcnpclivingwith eq $pcresidenceowner&gt;&gt;
	&lt;&lt;godate&gt;&gt;
	&lt;&lt;set _loc to passage()&gt;&gt;
		Main Actions:&lt;br&gt;
		&lt;&lt;set _chatevents to setup.Events.assemble_set([&quot;resident&quot;, &quot;chat&quot;])&gt;&gt;
		&lt;&lt;run setup.shuffle(_chatevents)&gt;&gt;
		&lt;&lt;set _chatevent to _chatevents[0].passage&gt;&gt;
			
		&lt;&lt;if $peopleatlocation.includes($pcresidenceowner)&gt;&gt;
			&lt;&lt;set _hangevent to _chatevent&gt;&gt;
			&lt;&lt;link &quot;Hang out&quot; _hangevent&gt;&gt;
				&lt;&lt;advtime 60 Attention Relaxation&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
			
			&lt;&lt;set _movieevent to &quot;EventResidentWatchMovieStart&quot;&gt;&gt;
			&lt;&lt;link &quot;Watch a movie&quot; _movieevent&gt;&gt;
				&lt;&lt;advtime 120 Attention Relaxation&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 120&gt;&gt;&lt;br&gt;
			
		<!---&lt;&lt;if !_rmhere&gt;&gt;
				&lt;&lt;set _sexevent to &quot;EventResidentWatchSexStart&quot;&gt;&gt;
				&lt;&lt;if _sexevent&gt;&gt;
					&lt;&lt;link &quot;Talk about sex&quot; _sexevent&gt;&gt;
						&lt;&lt;advtime 60 Attention Relaxation&gt;&gt;
					&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
				&lt;&lt;/if&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;br&gt;--->
		&lt;&lt;/if&gt;&gt;


	&lt;&lt;set _allowed to []&gt;&gt;
	&lt;&lt;set _desrel to setup.people.desired_relationship($eventnpc)&gt;&gt;
	&lt;&lt;if setup.people.willing_date($eventnpc)&gt;&gt;
		&lt;&lt;set _allowed to [&quot;pee&quot;, &quot;shower&quot;]&gt;&gt;
		&lt;&lt;if $hour gte 21 or $hour lt 6&gt;&gt;
			&lt;&lt;run _allowed.push(&quot;sleep&quot;)&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;elseif _desrel is &quot;fuckbuddy&quot; or _desrel is &quot;friend&quot;&gt;&gt;
		&lt;&lt;set _allowed to [&quot;pee&quot;, &quot;shower&quot;]&gt;&gt;
		&lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gte 500 and ($hour gte 22 or $hour lt 6)&gt;&gt;
			&lt;&lt;run _allowed.push(&quot;sleep&quot;)&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;elseif _desrel is &quot;hatefuck&quot; or _desrel is &quot;rival&quot;&gt;&gt;
	&lt;&lt;else&gt;&gt;
		&lt;&lt;set _allowed to [&quot;pee&quot;, &quot;shower&quot;]&gt;&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;run _allowed.push(&quot;wash&quot;)&gt;&gt;
	&lt;&lt;if setup.people.willing_sex($eventnpc) and setup.people.get_attitude($eventnpc, &quot;lust&quot;) gte 800&gt;&gt;
		&lt;&lt;run _allowed.push(&quot;fuck&quot;)&gt;&gt;
	&lt;&lt;/if&gt;&gt;

	&lt;&lt;if _allowed.includes(&quot;fuck&quot;)&gt;&gt;
		&lt;&lt;link &quot;Have sex&quot; EncounterRound&gt;&gt;
			&lt;&lt;unset $round2available&gt;&gt;
			&lt;&lt;set _role to $pc.has_part(&quot;penis&quot;) ? &quot;top&quot; : &quot;bottom&quot;&gt;&gt;
			&lt;&lt;set _npcexp to new Person({person: $eventnpc})&gt;&gt;
			&lt;&lt;run _npcexp.remove_all_clothing()&gt;&gt;
			&lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;, _npcexp], endpassage: &quot;Residence&quot;, starting_position: &quot;Cowgirl&quot;, starting_role: setup.people.is_masc($pc) ? &quot;bottom&quot; : &quot;top&quot;,})&gt;&gt;
		&lt;&lt;/link&gt;&gt;
		&lt;br&gt;
	&lt;&lt;/if&gt;&gt;

	&lt;br&gt;
	Other Actions:&lt;br&gt;		
		&lt;&lt;link &quot;Get some food&quot;&gt;&gt;
			&lt;&lt;advtime 10 Food&gt;&gt;
			&lt;&lt;alterneed Food 1000&gt;&gt;
			&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;
			&lt;&lt;set $header to &#39;You get ready to make some quick food. A few minutes later, Your meal is ready. A meal which you promptly devour. &lt;&lt;dalterneed Food 1000&gt;&gt;&#39;&gt;&gt;
		&lt;&lt;/link&gt;&gt;
		&lt;br&gt;

		
	&lt;&lt;if _allowed.includes(&quot;pee&quot;)&gt;&gt;
		&lt;&lt;link &quot;Use the bathroom&quot;&gt;&gt;&lt;&lt;advtime 5&gt;&gt;&lt;&lt;alterneed Bladder 1000&gt;&gt;&lt;&lt;set $header to &quot;You head into the bathroom and relieve yourself.&quot;&gt;&gt;&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Bladder 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.includes(&quot;shower&quot;)&gt;&gt;
		&lt;&lt;link &quot;Take a shower&quot;&gt;&gt;&lt;&lt;advtime 20&gt;&gt;&lt;&lt;alterneed Hygiene 1000&gt;&gt;&lt;&lt;set $header to &quot;You grab a shower.&quot;&gt;&gt;&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 20&gt;&gt; &lt;&lt;dalterneed Hygiene 1000&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.includes(&quot;wash&quot;)&gt;&gt;
		&lt;&lt;link &quot;Wash up&quot;&gt;&gt;&lt;&lt;advtime 5&gt;&gt;&lt;&lt;alterneed Hygiene 50&gt;&gt;&lt;&lt;set $header to &quot;You quickly wash up.&quot;&gt;&gt;&lt;&lt;egoto &quot;Residence&quot;&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 5&gt;&gt; &lt;&lt;dalterneed Hygiene 50&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if _allowed.includes(&quot;sleep&quot;)&gt;&gt;
		&lt;&lt;link &quot;Sleep&quot; Sleep2&gt;&gt;&lt;&lt;unset $round2available&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
		&lt;&lt;set _comp to setup.computer()&gt;&gt;
		&lt;&lt;if _comp&gt;&gt;
			You have &lt;&lt;aoran _comp&gt;&gt; _comp available to use.
		&lt;&lt;/if&gt;&gt;

		&lt;&lt;link &quot;Study&quot;&gt;&gt;
			&lt;&lt;set $studyspan to 30&gt;&gt;
			&lt;&lt;egoto &quot;Study&quot;&gt;&gt;
		&lt;&lt;/link&gt;&gt;
		&lt;&lt;if _comp&gt;&gt;
			&lt;br&gt;
			&lt;&lt;link &quot;Internet&quot; Computer&gt;&gt;&lt;&lt;/link&gt;&gt;
		&lt;&lt;/if&gt;&gt;

		&lt;&lt;if _comp&gt;&gt;
			&lt;br&gt;
			&lt;&lt;link &quot;Play game&quot;&gt;&gt;
				&lt;&lt;advtime 30 Relaxation&gt;&gt;
				&lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
				&lt;&lt;raiseskill &quot;Video Gaming&quot; 1&gt;&gt;
				&lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
				&lt;&lt;egoto _event&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
		&lt;&lt;/if&gt;&gt;		
		&lt;br&gt;

		&lt;&lt;link &quot;Clothes&quot;&gt;&gt;
			&lt;&lt;egoto &quot;Wardrobe&quot;&gt;&gt;
		&lt;&lt;/link&gt;&gt;
		&lt;br&gt;&lt;br&gt;
		
		&lt;&lt;link &quot;Leave them?&quot; &quot;Residence&quot;&gt;&gt;
			&lt;&lt;set $pcnpclivingwith to ""&gt;&gt;
		&lt;&lt;/link&gt;&gt;&lt;br&gt;&lt;br&gt;

&lt;&lt;/if&gt;&gt;

&lt;&lt;set _endp to _pobj.residence&gt;&gt;
&lt;&lt;if _endp eq &quot;Chicory Hall&quot;&gt;&gt;
	&lt;&lt;set _endpsg to &quot;MainHall&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _endp eq &quot;Helleborine Hall&quot;&gt;&gt;
	&lt;&lt;set _endpsg to &quot;HelleborineHall&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _endp eq &quot;Date Palm Street&quot; or _res eq &quot;DatePalmSt&quot;&gt;&gt;
	&lt;&lt;set _endpsg to &quot;DatePalmSt&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _endp eq &quot;Saffron Street&quot; or _res eq &quot;SaffronSt&quot;&gt;&gt;
	&lt;&lt;set _endpsg to &quot;SaffronSt&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if _endp eq &quot;off-campus&quot;&gt;&gt;
	&lt;&lt;set _endpsg to &quot;DatePalmSt&quot;&gt;&gt;
&lt;&lt;/if&gt;&gt;

&lt;&lt;link &quot;Go back&quot; _endpsg&gt;&gt;&lt;&lt;advtime 1&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="30621" name="FirstGenEntry" tags="location noevents locFirstGenEntry roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[0].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="30622" name="SecondGenEntry" tags="location noevents locSecondGenEntry  roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[1].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="30623" name="ThirdGenEntry" tags="location noevents locThirdGenEntry roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[2].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="30624" name="FourthGenEntry" tags="location noevents locFourthGenEntry roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[3].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="30625" name="FifthGenEntry" tags="location noevents locFifthGenEntry roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[4].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="30626" name="SixthGenEntry" tags="location noevents locSixthGenEntry roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[5].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="30627" name="SeventhGenEntry" tags="location noevents locSeventhGenEntry roomtypedorm emoji🛏️ nobr" position="225,38350" size="100,100">
&lt;&lt;set $pcresidenceowner to $pcresidenceowners[6].name&gt;&gt;
&lt;&lt;goto Residence&gt;&gt;

</tw-passagedata>
<tw-passagedata pid="21560" name="EventResidentWatchMovieStart" tags="event hangout nobr" position="725,26975" size="100,100">
You and &lt;&lt;anonorfirstname $eventnpc&gt;&gt; decide to have a movie night at &lt;&lt;pp&gt;&gt; place. As you both settle onto the couch, popcorn ready, you scroll through streaming options, debating which film to pick.&lt;br&gt;&lt;br&gt;

You share laughs over favorite scenes and quirky characters, the room buzzing with excitement. With cozy blankets and snacks at the ready, it’s the perfect setup for a fun night.&lt;br&gt;&lt;br&gt;

After a while, you dim the lights and the movie starts.&lt;br&gt;&lt;br&gt;

&lt;&lt;set $pcresidenceeventst to true&gt;&gt;
&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21561" name="EventResidentWatchMovie" tags="event hangout nobr" position="725,26975" size="100,100">
You sit on the couch, the dim light of the TV casting a soft glow in the room. &lt;&lt;anonorfirstname $eventnpc&gt;&gt; is beside you, holding a bowl of popcorn between you two. &lt;br&gt;&lt;br&gt;
The movie plays, but you find yourself stealing glances at &lt;&lt;anonorfirstname $eventnpc&gt;&gt; every now and then. 
&lt;&lt;ps&gt;&gt; laughs at the funny parts, and you can’t help but smile, feeling the warmth of the moment.
&lt;br&gt;&lt;br&gt;

&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21562" name="EventResidentWatchMovieLaugh" tags="event hangout nobr" position="725,26975" size="100,100">
In a quiet moment, you both burst into laughter at a funny part, and it feels like you’re in your own little world, enjoying the food and the film. The cozy atmosphere wraps around you, making you and your companion feel at home, even if it’s just another night of movie watching.
&lt;br&gt;&lt;br&gt;

&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21563" name="EventResidentWatchMovieEatPizza" tags="event hangout nobr" position="725,26975" size="100,100">
You sit on the couch, the TV screen flickering with scenes from the movie. &lt;br&gt;&lt;br&gt;
&lt;&lt;anonorfirstname $eventnpc&gt;&gt; is next to you, casually munching on a slice of pizza. The smell of melted cheese and pepperoni fills the air, making your stomach rumble. 
&lt;br&gt;&lt;br&gt;

&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21564" name="EventResidentWatchMovieEatSnacks" tags="event hangout nobr" position="725,26975" size="100,100">
As the movie progresses, you both take turns sharing snacks. &lt;&lt;anonorfirstname $eventnpc&gt;&gt; offers you a few chips, and you gratefully accept, crunching on them while trying to focus on the plot. Sometimes, &lt;&lt;ps&gt;&gt; glances your way, and you catch &lt;&lt;pp&gt;&gt; smiling at your reactions to the scenes.
&lt;br&gt;&lt;br&gt;

&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21565" name="EventResidentWatchMovieEatJumpscare" tags="event hangout nobr" position="725,26975" size="100,100">
As the plot thickens, you lean forward, engrossed in the story. You can hear the sound of popcorn crunching as &lt;&lt;anonorfirstname $eventnpc&gt;&gt; digs in for another handful. Suddenly, a jump scare makes you both jump, and you laugh together, the tension of the movie momentarily forgotten.
&lt;br&gt;&lt;br&gt;

&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21566" name="EventResidentWatchMovieEnd" tags="event hangout nobr" position="725,26975" size="100,100">
A quiet comfort settles over you, and you can’t help but feel grateful for this time spent together. You exchange a quick glance, and there’s an unspoken connection that makes you feel like this moment is something special, even if it’s just watching a movie. 

&lt;br&gt;&lt;br&gt;
Time to part ways for now. &lt;br&gt;&lt;br&gt;

&lt;&lt;set $pcresidenceprevevent to ""&gt;&gt;
&lt;&lt;set _movieevent to $location&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata><tw-passagedata pid="311" name="EventResidentChatFriend" tags="event" position="100,3975" size="100,100">&lt;&lt;set _p to $eventnpc&gt;&gt;\
You and &lt;&lt;firstname _p&gt;&gt; spend a while chatting about friends, people who annoy you, classes, and whatever else comes to mind. &lt;&lt;dalterneed Relaxation 100 true&gt;&gt; &lt;&lt;dalterneed Attention 150&gt;&gt;&lt;&lt;socialize 150&gt;&gt;

&lt;&lt;nobr&gt;&gt;
    &lt;&lt;set _students to setup.people.people_of_type(&quot;student&quot;)&gt;&gt;
    &lt;&lt;set _p2 to setup.Events.pick_person({desiredrelationships: [&quot;friend&quot;, &quot;date&quot;, &quot;fuckbuddy&quot;], norelationship: true}, _students)&gt;&gt;
    &lt;&lt;if _p2 is null&gt;&gt;&lt;&lt;set _p2 to setup.randomchoice(_students)&gt;&gt;&lt;&lt;/if&gt;&gt;
    &quot;What do you think of &lt;&lt;if setup.people.is_known(_p2)&gt;&gt;&lt;&lt;fullname _p2&gt;&gt;&lt;&lt;else&gt;&gt;&lt;&lt;dfullname _p2&gt;&gt;&lt;&lt;/if&gt;&gt;?&quot; &lt;&lt;ps _p&gt;&gt; &lt;&lt;conj ask&gt;&gt;. &quot;You know &lt;&lt;po _p2&gt;&gt;, don&#39;t you?&quot;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;known _p2&gt;&gt;
        &lt;&lt;set _desrel to setup.people.desired_relationship(_p2)&gt;&gt;
        &lt;&lt;set _sameres to setup.people.in_residence(_p2)&gt;&gt;
        &lt;&lt;set _classmate to setup.people.is_classmate(_p2)&gt;&gt;
        &lt;&lt;if setup.people.has_any_inclination(_p2, setup.archetypes.inclination_sets.shy)&gt;&gt;
            &lt;&lt;set _desc to &quot;Kinda shy.&quot;&gt;&gt;
        &lt;&lt;elseif setup.people.has_any_inclination(_p2, setup.archetypes.inclination_sets.dominant)&gt;&gt;
            &lt;&lt;set _desc to &quot;Pretty intense sometimes.&quot;&gt;&gt;
        &lt;&lt;elseif setup.people.has_any_inclination(_p2, setup.archetypes.inclination_sets.forward)&gt;&gt;
            &lt;&lt;set _desc to &quot;Confident type.&quot;&gt;&gt;
        &lt;&lt;else&gt;&gt;
            &lt;&lt;set _desc to &quot;Decent &lt;&lt;guygirl _p2&gt;&gt;.&quot;&gt;&gt;
        &lt;&lt;/if&gt;&gt;
        &quot;Yeah,&quot; you say. &quot;&lt;&lt;= _desc&gt;&gt;
        &lt;&lt;if _sameres and _classmate&gt;&gt;
            &lt;&lt;psc _p2&gt;&gt; &lt;&lt;conj live&gt;&gt; here. We have classes together too.
        &lt;&lt;elseif _sameres&gt;&gt;
            &lt;&lt;psc _p2&gt;&gt; &lt;&lt;conj live&gt;&gt; here.
        &lt;&lt;elseif _classmate&gt;&gt;
            We have classes together.
        &lt;&lt;else&gt;&gt;
            We don&#39;t have classes together or anything, but I see &lt;&lt;po _p2&gt;&gt; around.
        &lt;&lt;/if&gt;&gt;
        &lt;&lt;if _desrel is &quot;friend&quot;&gt;&gt;
            &lt;&lt;pssc _p2&gt;&gt; pretty nice, mostly.&quot;&lt;br&gt;
            &lt;br&gt;
            &quot;Uh-huh. Just don&#39;t forget about your first and best friend,&quot; &lt;&lt;ps _p&gt;&gt; &lt;&lt;conj say&gt;&gt;, jabbing a thumb toward &lt;&lt;pp&gt;&gt; chest.&lt;br&gt;
            &lt;br&gt;
            You roll your eyes, then you both laugh.
        &lt;&lt;elseif _desrel is &quot;date&quot;&gt;&gt;
            I think &lt;&lt;ps _p2&gt;&gt; &lt;&lt;conj have&gt;&gt; a crush on me.&quot;&lt;br&gt;
            &lt;br&gt;
            &quot;Well, naturally,&quot; &lt;&lt;firstname _p&gt;&gt; says, and you both laugh and gossip about &lt;&lt;po _p2&gt;&gt; for a while.
        &lt;&lt;elseif _desrel is &quot;fuckbuddy&quot;&gt;&gt;
            &lt;&lt;pssc _p2&gt;&gt; nice. But I kinda think &lt;&lt;ps&gt;&gt; &lt;&lt;conj want&gt;&gt; to fuck me,&quot;
            &lt;&lt;if setup.people.has_had_sex(_p2)&gt;&gt;
                you say, declining to mention that &lt;&lt;ps&gt;&gt; already &lt;&lt;conj have&gt;&gt;.
            &lt;&lt;elseif setup.people.is_sexpartner(_p2)&gt;&gt;
                you say, declining to mention that you&#39;ve already fooled around with &lt;&lt;po&gt;&gt;.
            &lt;&lt;else&gt;&gt;
                you say.
            &lt;&lt;/if&gt;&gt;&lt;br&gt;
            &lt;br&gt;
            &quot;Wow,&quot; &lt;&lt;firstname _p&gt;&gt; says. &quot;Got yourself a fuckbuddy.&quot; You both laugh and gossip about &lt;&lt;po _p2&gt;&gt; for a while.
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;unknown&gt;&gt;
        &quot;Who?&quot; you ask.&lt;br&gt;
        &lt;br&gt;
        &lt;&lt;psc _p&gt;&gt; &lt;&lt;conj laugh&gt;&gt;. &quot;I guess not. I think you&#39;d like &lt;&lt;po _p2&gt;&gt; though.&quot;
    &lt;&lt;/known&gt;&gt;
&lt;&lt;/nobr&gt;&gt;

&lt;&lt;pickresidentsnextchat&gt;&gt;
&lt;&lt;link &quot;Next&quot; _chatevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata><tw-passagedata pid="312" name="EventResidentChatRival" tags="event" position="225,3975" size="100,100">&lt;&lt;set _p to $eventnpc&gt;&gt;\
You and &lt;&lt;firstname _p&gt;&gt; spend a while chatting about friends, people who annoy you, classes, and whatever else comes to mind. &lt;&lt;dalterneed Relaxation 100 true&gt;&gt; &lt;&lt;dalterneed Attention 150&gt;&gt;&lt;&lt;socialize 150&gt;&gt;

&lt;&lt;nobr&gt;&gt;
    &lt;&lt;set _students to setup.people.people_of_type(&quot;student&quot;)&gt;&gt;
    &lt;&lt;set _p2 to setup.Events.pick_person({desiredrelationships: [&quot;rival&quot;, &quot;hatefuck&quot;], norelationship: true}, _students)&gt;&gt;
    &lt;&lt;if _p2 is null&gt;&gt;&lt;&lt;set _p2 to setup.randomchoice(_students)&gt;&gt;&lt;&lt;/if&gt;&gt;
    &quot;What do you think of &lt;&lt;if setup.people.is_known(_p2)&gt;&gt;&lt;&lt;fullname _p2&gt;&gt;&lt;&lt;else&gt;&gt;&lt;&lt;dfullname _p2&gt;&gt;&lt;&lt;/if&gt;&gt;?&quot; &lt;&lt;ps _p&gt;&gt; &lt;&lt;conj ask&gt;&gt;. &quot;You know &lt;&lt;po _p2&gt;&gt;, don&#39;t you?&quot;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;known _p2&gt;&gt;
        &lt;&lt;set _desrel to setup.people.desired_relationship(_p2)&gt;&gt;
        &lt;&lt;set _sameres to setup.people.in_residence(_p2)&gt;&gt;
        &lt;&lt;set _classmate to setup.people.is_classmate(_p2)&gt;&gt;
        &lt;&lt;if setup.people.has_any_inclination(_p2, setup.archetypes.inclination_sets.shy)&gt;&gt;
            &lt;&lt;set _desc to &quot;Quiet type, kinda weird.&quot;&gt;&gt;
        &lt;&lt;elseif setup.people.has_any_inclination(_p2, setup.archetypes.inclination_sets.dominant)&gt;&gt;
            &lt;&lt;set _desc to &quot;Overly confident.&quot;&gt;&gt;
        &lt;&lt;elseif setup.people.has_any_inclination(_p2, setup.archetypes.inclination_sets.forward)&gt;&gt;
            &lt;&lt;set _desc to &quot;Smug.&quot;&gt;&gt;
        &lt;&lt;else&gt;&gt;
            &lt;&lt;set _desc to &quot;Not very friendly.&quot;&gt;&gt;
        &lt;&lt;/if&gt;&gt;
        &quot;Yeah, I know &lt;&lt;po _p2&gt;&gt;,&quot; you say. &quot;&lt;&lt;= _desc&gt;&gt;
        &lt;&lt;if _sameres and _classmate&gt;&gt;
            &lt;&lt;psc _p2&gt;&gt; &lt;&lt;conj live&gt;&gt; here. We have classes together too.
        &lt;&lt;elseif _sameres&gt;&gt;
            &lt;&lt;psc _p2&gt;&gt; &lt;&lt;conj live&gt;&gt; here.
        &lt;&lt;elseif _classmate&gt;&gt;
            We have classes together.
        &lt;&lt;else&gt;&gt;
            We don&#39;t have classes together or anything, but I see &lt;&lt;po _p2&gt;&gt; around.
        &lt;&lt;/if&gt;&gt;
        &lt;&lt;if _desrel is &quot;rival&quot;&gt;&gt;
            &lt;&lt;pssc _p2&gt;&gt; a petty &lt;&lt;jerk _p2&gt;&gt;.&quot;&lt;br&gt;
            &lt;br&gt;
            &quot;Yeah, you do know &lt;&lt;po _p2&gt;&gt;,&quot; &lt;&lt;firstname _p&gt;&gt; says, and both laugh and gossip about &lt;&lt;po _p2&gt;&gt; for a while.
        &lt;&lt;elseif _desrel is &quot;hatefuck&quot;&gt;&gt;
            &lt;&lt;pssc _p2&gt;&gt; &lt;&lt;abitch _p2&gt;&gt;. But &lt;&lt;ps&gt;&gt; still &lt;&lt;conj think&gt;&gt; &lt;&lt;pss&gt;&gt; gonna fuck me,&quot;
            &lt;&lt;if setup.people.has_had_sex(_p2)&gt;&gt;
                you say, declining to mention that &lt;&lt;ps&gt;&gt; already &lt;&lt;conj have&gt;&gt;.
            &lt;&lt;elseif setup.people.is_sexpartner(_p2)&gt;&gt;
                you say, declining to mention that you&#39;ve already fooled around with &lt;&lt;po&gt;&gt;.
            &lt;&lt;else&gt;&gt;
                you say.
            &lt;&lt;/if&gt;&gt;&lt;br&gt;
            &lt;br&gt;
            &quot;Sounds about right,&quot; &lt;&lt;firstname _p&gt;&gt; says, rolling &lt;&lt;pp&gt;&gt; eyes. You gossip about &lt;&lt;po _p2&gt;&gt; for a while.
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;unknown&gt;&gt;
        &quot;Who?&quot; you ask.&lt;br&gt;
        &lt;br&gt;
        &lt;&lt;psc _p&gt;&gt; &lt;&lt;conj laugh&gt;&gt;. &quot;I guess not. Probably for the best, to be honest. Better if you steer clear of &lt;&lt;po _p2&gt;&gt;.&quot;
    &lt;&lt;/known&gt;&gt;
&lt;&lt;/nobr&gt;&gt;

&lt;&lt;pickresidentsnextchat&gt;&gt;
&lt;&lt;link &quot;Next&quot; _chatevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata><tw-passagedata pid="313" name="EventResidentChatClasses" tags="event" position="350,3975" size="100,100">&lt;&lt;set _p to $eventnpc&gt;&gt;\
You and &lt;&lt;firstname _p&gt;&gt; spend a while chatting about friends, people who annoy you, classes, and whatever else comes to mind. &lt;&lt;dalterneed Relaxation 100 true&gt;&gt; &lt;&lt;dalterneed Attention 150&gt;&gt;&lt;&lt;socialize 150&gt;&gt;

&lt;&lt;nobr&gt;&gt;
    &lt;&lt;set _class to setup.randomchoice($pccourses)&gt;&gt;
    &quot;_class going okay for you?&quot; &lt;&lt;ps&gt;&gt; &lt;&lt;conj ask&gt;&gt;.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;if !$gpa or !$gpa[_class] or $gpa[_class].currentgrade is -1&gt;&gt;
        &quot;Hard to say,&quot; you say, laughing. &quot;Ask me again after the first test.&quot;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;set _score to $gpa[_class].currentgrade&gt;&gt;
        &lt;&lt;if _score gte 0.9&gt;&gt;
            &quot;Pretty good, actually,&quot; you say.
        &lt;&lt;elseif _score gte 0.8&gt;&gt;
            &quot;Not bad, could be better,&quot; you say.
        &lt;&lt;elseif _score gt 0.6&gt;&gt;
            &quot;Well... I&#39;m not failing,&quot; you say.
        &lt;&lt;else&gt;&gt;
            &quot;Um... pretty terrible,&quot; you say.
        &lt;&lt;/if&gt;&gt;
        &lt;&lt;if $homework and $homework[_class] and $homework[_class].assigned gt $homework[_class].completed&gt;&gt;
            &quot;Got some homework I need to do at some point.&quot;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/if&gt;&gt;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;set _score to $gpa[_class].currentgrade&gt;&gt;
    &lt;&lt;if !$gpa or !$gpa[_class] or $gpa[_class].currentgrade is -1&gt;&gt;
        &quot;Well alright,&quot; &lt;&lt;firstname _p&gt;&gt; says, laughing. &quot;We&#39;ll tackle it when we get there.&quot;
	&lt;&lt;elseif _score gte 0.8&gt;&gt;
		&quot;Nice!&quot; &lt;&lt;firstname _p&gt;&gt; says. &quot;Sometimes I have to remind myself that I need to stay on top of my priorities too.&quot;
	&lt;&lt;elseif _score gte 0.7&gt;&gt;
		&quot;Alright!&quot; &lt;&lt;firstname _p&gt;&gt; says. &quot;Sometimes we have to remind ourselves that we need to stay on top of our priorities.&quot;
	&lt;&lt;else&gt;&gt;
		&quot;Yikes!&quot; &lt;&lt;firstname _p&gt;&gt; says. &quot;Better get those grades up. But none of us are perfect, isn&#39;t that right?&quot;
    &lt;&lt;/if&gt;&gt;
    &lt;br&gt;&lt;br&gt;
    &quot;Right, couldn&#39;t be further from the truth,&quot; you say, and you both laugh.
&lt;&lt;/nobr&gt;&gt;

&lt;&lt;pickresidentsnextchat&gt;&gt;
&lt;&lt;link &quot;Next&quot; _chatevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="21566" name="EventResidentChatEnd" tags="event hangout" position="725,26975" size="100,100">
A quiet comfort settles over you, and you can’t help but feel grateful for this time spent together. You exchange a quick glance, and there’s an unspoken connection that makes you feel like this moment is something special, even if it’s just chatting. 
&lt;br&gt;
Time to part ways for now.

&lt;&lt;set $pcresidenceprevevent to ""&gt;&gt;
&lt;&lt;set _chatevent to $location&gt;&gt;
&lt;&lt;link &quot;Next&quot; _chatevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="2141" name="EventResidentWatchMovieWatch" tags="event hangout nobr" position="100,26850" size="100,100">As the movie continues and the scenes proceed, you feel it&#39;s time to settle in a bit longer.
&lt;br&gt;&lt;br&gt; 
You come across a scene that's a bit hotter than the others, and you can feel the mood shift in the room as the scene progresses. &lt;br&gt; &lt;br&gt;
&lt;&lt;if setup.people.has_any_inclination($eventnpc, &quot;active&quot;) and setup.people.attracted_enough_to_pc($eventnpc)&gt;&gt;

	&lt;&lt;if setup.people.is_masc($pc) and setup.people.is_femme($eventnpc)&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt; starts rubbing against you, leaning into you while you proceed to pull &lt;&lt;pp&gt;&gt; in closer.
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if setup.people.is_masc($eventnpc) and setup.people.is_femme($pc)&gt;&gt;conj
    You start rubbing against &lt;&lt;firstname $eventnpc&gt;&gt;, leaning into &lt;&lt;pp&gt;&gt; while &lt;&lt;ps&gt;&gt; &lt;&lt;conj proceed&gt;&gt; to pull you in closer.
	&lt;&lt;/if&gt;&gt;
	
	&lt;br&gt;
    &lt;br&gt;
	&lt;&lt;if setup.people.willing_sex($eventnpc)&gt;&gt;
		&lt;&lt;link &quot;Escalate&quot; EventResidentWatchMovieLapSit&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;link &quot;Keep watching&quot; &quot;EventResidentWatchMovieLapSitDontEscalate&quot;&gt;&gt;
		&lt;&lt;advtime 20&gt;&gt;
	&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
	&lt;&lt;if setup.people.willing_sex($eventnpc)&gt;&gt;
		&lt;&lt;link &quot;Escalate&quot; EventResidentWatchMovieLapSit&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;link &quot;Keep watching&quot; &quot;EventResidentWatchMovieLapSitDontEscalate&quot;&gt;&gt;
		&lt;&lt;advtime 20&gt;&gt;
	&lt;&lt;/link&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
<tw-passagedata pid="2145" name="EventResidentWatchMovieLapSit" tags="event hangout nobr" position="600,26850" size="100,100">
&lt;&lt;if setup.people.is_masc($eventnpc) and setup.people.is_femme($pc)&gt;&gt;
You sit back, relaxing up against &lt;&lt;firstname $eventnpc&gt;&gt;, your back nestled against &lt;&lt;pp&gt;&gt; chest, positioning yourself so that you can both still see the movie.&lt;br&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;if setup.people.is_masc($pc) and setup.people.is_femme($eventnpc)&gt;&gt;
&lt;&lt;firstname $eventnpc&gt;&gt; sits back, relaxing up against you, &lt;&lt;pp&gt;&gt; back nestled against your chest, positioning &lt;&lt;pp&gt;&gt;self so that you can both still see the movie.
&lt;&lt;/if&gt;&gt;
&lt;br&gt;&lt;br&gt;
It&#39;s comfortable, and the movie is actually pretty good too.&lt;br&gt;&lt;br&gt;


	&lt;&lt;if setup.people.willing_sex($eventnpc)&gt;&gt;
		&lt;&lt;link &quot;Escalate&quot; EventResidentWatchMovieLapSit2&gt;&gt;&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;link &quot;Keep watching&quot; &quot;EventResidentWatchMovieLapSitDontEscalate&quot;&gt;&gt;
		&lt;&lt;advtime 20&gt;&gt;
	&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="2146" name="EventResidentWatchMovieLapSit2" tags="event hangout nobr" position="725,26850" size="100,100">
You&#39;re a bit further through the movie.
&lt;&lt;if setup.people.has_any_inclination($eventnpc, &quot;active&quot;) and setup.people.willing_sex($eventnpc) and setup.people.allow_free_interaction($eventnpc)&gt;&gt;
    You feel &lt;&lt;firstname $eventnpc&gt;&gt; shifting against you a little, then &lt;&lt;pp&gt;&gt; hips give a slow roll, 
	
	&lt;&lt;if setup.people.is_masc($pc) and setup.people.is_femme($eventnpc)&gt;&gt;
		rubbing &lt;&lt;pp&gt;&gt; rear back against you.
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;if setup.people.is_masc($eventnpc) and setup.people.is_femme($pc)&gt;&gt;
		rubbing &lt;&lt;pr&gt;&gt; against your rear.
	&lt;&lt;/if&gt;&gt;&lt;br&gt;
	
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 2 &quot;Go with it&quot; EventResidentWatchMovieLapSitEscalate&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    &lt;&lt;link &quot;Just watch the movie&quot; EventResidentWatchMovieLapSitDontEscalate&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    &lt;&lt;skillgate Disinhibition 3 &quot;Make a move&quot; EventResidentWatchMovieLapSitEscalate&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    &lt;&lt;link &quot;Keep watching&quot; EventResidentWatchMovieLapSitDontEscalate&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;/if&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="2147" name="EventResidentWatchMovieLapSitDontEscalate" tags="event hangout nobr" position="850,26850" size="100,100">Both of you seem content to just remain cuddled up for the time being. It&#39;s actually quite nice.
&lt;br&gt;&lt;br&gt;

&lt;&lt;pickresidentsnextmovie&gt;&gt;
&lt;&lt;link &quot;Next&quot; _movieevent&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="2150" name="EventResidentWatchMovieLapSitEscalate" tags="event hangout nobr" position="1225,26850" size="100,100">In moments, you and &lt;&lt;po $eventnpc&gt;&gt; are both grinding together, arousal growing, breath puffing out faster. The movie is swiftly fading into the background. &lt;&lt;run $pc.add_arousal(100, 900)&gt;&gt;&lt;&lt;dalterneed Arousal 100&gt;&gt;
&lt;&lt;set _npc to new Person({person: $eventnpc})&gt;&gt;
&lt;&lt;run _npc.add_arousal(100, 900)&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;link &quot;Next&quot; EncounterRound&gt;&gt;
    &lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;, _npc], endpassage: &quot;EventResidentWatchMovieLapSitSexEnd&quot;, abortpassage: &quot;EventResidentWatchMovieLapSitSexEnd&quot;, starting_position: &quot;Reverse Cowgirl&quot;, starting_role: setup.people.is_masc($pc) ? &quot;bottom&quot; : &quot;top&quot;, endgoal: &quot;fuck&quot;})&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="2151" name="EventResidentWatchMovieLapSitSexEnd" tags="event hangout nobr" position="100,26975" size="100,100">Still breathing hard, you both settle back down, attention drifting back to the movie as you come down from your orgasms.
&lt;br&gt;&lt;br&gt;

&lt;&lt;link &quot;Next&quot; &quot;EventResidentWatchMovieEnd&quot;&gt;&gt;
	&lt;&lt;advtime 20&gt;&gt;
&lt;&lt;/link&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="215600" name="AnybodysHouseWidgets" tags="widget nobr noevents" position="725,26975" size="100,100">
&lt;&lt;widget &quot;displayresidents&quot;&gt;&gt;	
	&lt;&lt;set _people to setup.people.all_phone_favorites()&gt;&gt;
	&lt;&lt;set _linkData to []&gt;&gt;
	&lt;&lt;set _count to 0&gt;&gt;  <!-- Initialize counter -->
	
	&lt;&lt;makefavoritehomelessoffcampus&gt;&gt;
	
    &lt;&lt;for _person range _people&gt;&gt;
		&lt;&lt;set _pdata to setup.people.get_person(_person)&gt;&gt;
		&lt;&lt;set _res to _pdata.residence&gt;&gt;
		&lt;&lt;set _rm to _pdata.roommate&gt;&gt; 
		&lt;&lt;set _personfname to setup.people.fullname(_person)&gt;&gt;
		&lt;&lt;if _person and _res eq _residience and _personfname neq $niches[&quot;The Best Friend&quot;] and _rm neq &quot;PC&quot;&gt;&gt;
			&lt;&lt;if _res eq &quot;Helleborine Hall&quot; or _res eq &quot;Chicory Hall&quot;&gt;&gt;
				&lt;&lt;set _resn to &quot;dorm&quot;&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if _res eq &quot;Date Palm Street&quot; or _res eq &quot;DatePalmSt&quot;&gt;&gt;
				&lt;&lt;set _resn to &quot;apartment&quot;&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if _res eq &quot;Saffron Street&quot; or _res eq &quot;SaffronSt&quot;&gt;&gt;
				&lt;&lt;set _resn to &quot;house&quot;&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if _res eq &quot;BancroftLn&quot;&gt;&gt;
				&lt;&lt;set _resn to &quot;house&quot;&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if _res eq &quot;PrescottRd&quot;&gt;&gt;
				&lt;&lt;set _resn to &quot;house&quot;&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			&lt;&lt;if _res eq &quot;off-campus&quot;&gt;&gt;
				&lt;&lt;set _resn to &quot;apartment&quot;&gt;&gt;
			&lt;&lt;/if&gt;&gt;
			
			<!-- &lt;&lt;set _linkname to setup.people.firstname(_person) + &quot;&#39;s _resn&quot;&gt;&gt;
			&lt;&lt;link _linkname GenericDorm&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;-->
			
			&lt;&lt;set _linkname to setup.people.firstname(_person) + &quot;&#39;s _resn&quot;&gt;&gt;
			&lt;&lt;run _linkData.push({name: _personfname, linkname: _linkname})&gt;&gt;
			&lt;&lt;set _count to _count + 1&gt;&gt;  <!-- Increment counter -->
        
			&lt;&lt;if _count eq 7&gt;&gt;  <!-- Check if 7 entries have been added -->
				&lt;&lt;break&gt;&gt;  <!-- Exit the loop -->
			&lt;&lt;/if&gt;&gt;
			
		&lt;&lt;/if&gt;&gt;
	&lt;&lt;/for&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 0&gt;&gt;
		&lt;br&gt;Other Residences: &lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	&lt;&lt;set $pcresidenceowners to _linkData&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 0&gt;&gt;
	&lt;&lt;set _firstLink to _linkData[0]&gt;&gt;
	&lt;&lt;link _firstLink.linkname FirstGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 1&gt;&gt;
	&lt;&lt;set _secondLink to _linkData[1]&gt;&gt;
	&lt;&lt;link _secondLink.linkname SecondGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 2&gt;&gt;
	&lt;&lt;set _thirdLink to _linkData[2]&gt;&gt;
	&lt;&lt;link _thirdLink.linkname ThirdGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 3&gt;&gt;
	&lt;&lt;set _fourthLink to _linkData[3]&gt;&gt;
	&lt;&lt;link _fourthLink.linkname FourthGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 4&gt;&gt;
	&lt;&lt;set _fifthLink to _linkData[4]&gt;&gt;
	&lt;&lt;link _fifthLink.linkname FifthGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 5&gt;&gt;
	&lt;&lt;set _sixthLink to _linkData[5]&gt;&gt;
	&lt;&lt;link _sixthLink.linkname SixthGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;if _linkData.length gt 6&gt;&gt;
	&lt;&lt;set _seventhLink to _linkData[6]&gt;&gt;
	&lt;&lt;link _seventhLink.linkname SeventhGenEntry&gt;&gt;
	&lt;&lt;/link&gt;&gt;&lt;br&gt;
	&lt;&lt;/if&gt;&gt;
&lt;&lt;/widget&gt;&gt;

&lt;&lt;widget &quot;makefavoritehomelessoffcampus&quot;&gt;&gt;
	&lt;&lt;set _people to setup.people.all_phone_favorites()&gt;&gt;
	&lt;&lt;set _linkData to []&gt;&gt;
	&lt;&lt;set _count to 0&gt;&gt;  <!-- Initialize counter -->
	
    &lt;&lt;for _person range _people&gt;&gt;
		&lt;&lt;set _pdata to setup.people.get_person(_person)&gt;&gt;
		&lt;&lt;set _res to _pdata.residence&gt;&gt;
		&lt;&lt;if _res eq &quot;&quot; or !_res&gt;&gt;
			&lt;&lt;set _pdata.residence to &quot;off-campus&quot;&gt;&gt;
		&lt;&lt;/if&gt;&gt;
    &lt;&lt;/for&gt;&gt;
&lt;&lt;/widget&gt;&gt;

&lt;&lt;widget &quot;pickresidentsnextmovie&quot;&gt;&gt;	
	&lt;&lt;set _possibleevents to setup.Events.assemble_set([&quot;resident&quot;, &quot;movie&quot;])&gt;&gt;
	&lt;&lt;set _filteredEvents to []&gt;&gt;
	&lt;&lt;if $pcresidenceeventst&gt;&gt;
		&lt;&lt;set $pcresidenceeventst to false&gt;&gt;
	&lt;&lt;/if&gt;&gt;
		&lt;&lt;for _event range _possibleevents&gt;&gt;
			&lt;&lt;if _event.passage neq &quot;EventResidentWatchMovieStart&quot; and _event.passage neq $pcresidenceprevevent&gt;&gt;
				&lt;&lt;run _filteredEvents.push(_event.passage)&gt;&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/for&gt;&gt;
		<!--- Filtered Events: &lt;br&gt;
		&lt;&lt;for _event range _filteredEvents&gt;&gt;
			_event
		&lt;&lt;/for&gt;&gt; Final Event: _movieevent--->
		&lt;&lt;run setup.shuffle(_filteredEvents)&gt;&gt;
		&lt;&lt;set _randevent to _filteredEvents[0]&gt;&gt;
		&lt;&lt;set _movieevent to _randevent&gt;&gt;
		&lt;&lt;set $pcresidenceprevevent to _movieevent&gt;&gt;
&lt;&lt;/widget&gt;&gt;

&lt;&lt;widget &quot;pickresidentsnextchat&quot;&gt;&gt;	
	&lt;&lt;set _possibleevents to setup.Events.assemble_set([&quot;resident&quot;, &quot;chat&quot;])&gt;&gt;
	&lt;&lt;set _filteredEvents to []&gt;&gt;
		&lt;&lt;for _event range _possibleevents&gt;&gt;
			&lt;&lt;if _event.passage neq $pcresidenceprevevent&gt;&gt;
				&lt;&lt;run _filteredEvents.push(_event.passage)&gt;&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/for&gt;&gt;
			<!--- Filtered Events: &lt;br&gt;
			&lt;&lt;for _event range _filteredEvents&gt;&gt;
				_event
			&lt;&lt;/for&gt;&gt; Final Event: _movieevent--->
		&lt;&lt;run setup.shuffle(_filteredEvents)&gt;&gt;
		&lt;&lt;set _randevent to _filteredEvents[0]&gt;&gt;
		&lt;&lt;set _chatevent to _randevent&gt;&gt;
		&lt;&lt;set $pcresidenceprevevent to _chatevent&gt;&gt;
&lt;&lt;/widget&gt;&gt;

&lt;&lt;widget &quot;sleep2&quot;&gt;&gt;
    &lt;&lt;replace &quot;#sleepoutput&quot;&gt;&gt;&lt;&lt;highlight&gt;&gt;Resting and autosaving! Please wait a moment.&lt;&lt;/highlight&gt;&gt;&lt;&lt;/replace&gt;&gt;
    &lt;&lt;timed 40ms&gt;&gt;
        &lt;&lt;set _sleeptime to _args[0] || 15&gt;&gt;
        &lt;&lt;set $sleeping to true&gt;&gt;
        &lt;&lt;unset $eventnpc&gt;&gt;&lt;&lt;unset $eventnpc2&gt;&gt;&lt;&lt;unset $eventnpc3&gt;&gt;&lt;&lt;unset $eventnpc4&gt;&gt;
        &lt;&lt;unset $npcexp&gt;&gt;
        &lt;&lt;run setup.Needs.sleep(_sleeptime, _sleepquality)&gt;&gt;
        &lt;&lt;set _wakeuppassage to &quot;Residence&quot;&gt;&gt;
        &lt;&lt;run delete V.pc.resisted_orgasm&gt;&gt;
        &lt;&lt;egoto _wakeuppassage&gt;&gt;
    &lt;&lt;/timed&gt;&gt;
&lt;&lt;/widget&gt;&gt;
</tw-passagedata>
<tw-passagedata pid="175" name="Sleep2" tags="noevents sleep nobr suppressemoji" position="600,2225" size="100,100">&lt;&lt;set _loc to &quot;Residence&quot;&gt;&gt;
&lt;&lt;set _getuppassage to _loc&gt;&gt;
&lt;&lt;set _nosleep to false&gt;&gt;
&lt;&lt;if $pcneeds[&quot;Bladder&quot;] lte 100&gt;&gt;
    &lt;&lt;set _nosleep to true&gt;&gt;
    It&#39;s hard to sleep when you need to pee this bad!
&lt;&lt;elseif $pcneeds[&quot;Hunger&quot;] lte 100&gt;&gt;
    &lt;&lt;set _nosleep to true&gt;&gt;
    Your stomach is growling! Hunger makes it difficult to sleep.
&lt;&lt;elseif _loc isnot &quot;YourDorm&quot;&gt;&gt;
    You get comfortable on the bed.
&lt;&lt;elseif !$firsttime.DormSleep and V.dormbed.name is &quot;dorm room cot&quot;&gt;&gt;
    You lay down on your cot. It&#39;s narrow and the mattress isn&#39;t very comfortable, but one thing you can say is it&#39;s definitely a bed.
    &lt;&lt;set $firsttime.DormSleep to true&gt;&gt;
&lt;&lt;else&gt;&gt;
    You flop down on your &lt;&lt;= V.dormbed.name&gt;&gt;.
&lt;&lt;/if&gt;&gt;&lt;br&gt;
&lt;br&gt;

&lt;&lt;if _nosleep is false&gt;&gt;
    &lt;&lt;if _loc is &quot;YourDorm&quot;&gt;&gt;
        &lt;&lt;set _sleepquality to V.dormbed[&quot;rest per hour&quot;]&gt;&gt;
        &lt;&lt;if $sleepoutfit&gt;&gt;&lt;&lt;if $sleepoutfit isnot &quot;!Strip&quot; and !$pc.has_outfit($sleepoutfit)&gt;&gt;Your default sleep outfit, $sleepoutfit, is &lt;span class=&quot;bad&quot;&gt;missing some items&lt;/span&gt; and won&#39;t be used until you sort it out.&lt;&lt;elseif $sleepoutfit is &quot;!Strip&quot;&gt;&gt;You sleep naked.&lt;&lt;else&gt;&gt;You will change into your $sleepoutfit outfit when you go to sleep.&lt;&lt;/if&gt;&gt;&lt;br&gt;&lt;&lt;/if&gt;&gt;

        &lt;&lt;include QuickWardrobe&gt;&gt;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;set _sleepquality to 110&gt;&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;if $hour gte 20 or $hour lte 6&gt;&gt;
        &lt;&lt;set _sleeptime to setup.Time.minutes_until(7, 0)&gt;&gt;
        &lt;&lt;link &quot;Set alarm for 7:00am&quot;&gt;&gt;
            &lt;&lt;set $wakemsg to &quot;You go to bed, sleeping until your alarm wakes you in the morning.&quot;&gt;&gt;
            &lt;&lt;sleep2 _sleeptime&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime _sleeptime&gt;&gt; &lt;&lt;set _restamt to (_sleeptime / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;set _restperminute to _sleepquality / 60&gt;&gt;
    &lt;&lt;set _restneeded to 1000 - setup.Needs.get_need(&quot;Rest&quot;)&gt;&gt;
    &lt;&lt;set _restminutesneeded to Math.floor(_restneeded / _restperminute)&gt;&gt;
    &lt;&lt;if _restminutesneeded gt 0&gt;&gt;
        &lt;&lt;link &quot;Sleep until rested&quot;&gt;&gt;
            &lt;&lt;set $wakemsg to &quot;You close your eyes, sleeping until you wake up naturally, fully rested.&quot;&gt;&gt;
            &lt;&lt;sleep2 _restminutesneeded&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime _restminutesneeded&gt;&gt; &lt;&lt;dalterneed Rest _restneeded&gt;&gt;&lt;br&gt;
    &lt;&lt;/if&gt;&gt;

    &lt;&lt;link &quot;Long Sleep&quot;&gt;&gt;
        &lt;&lt;set $wakemsg to &quot;You set no alarm and just close your eyes, letting yourself oversleep.&quot;&gt;&gt;
        &lt;&lt;sleep2 600&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 600&gt;&gt; &lt;&lt;set _restamt to (600 / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;

    &lt;&lt;link &quot;Full Sleep&quot;&gt;&gt;
        &lt;&lt;set $wakemsg to &quot;You go to sleep for a full eight hours.&quot;&gt;&gt;
        &lt;&lt;sleep2 480&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 480&gt;&gt; &lt;&lt;set _restamt to (480 / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;

    &lt;&lt;link &quot;Short Sleep&quot;&gt;&gt;
        &lt;&lt;set $wakemsg to &quot;You go to sleep for somewhat less than a full eight hours.&quot;&gt;&gt;
        &lt;&lt;sleep2 360&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 360&gt;&gt; &lt;&lt;set _restamt to (360 / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;

    &lt;&lt;link &quot;Long Nap&quot;&gt;&gt;
        &lt;&lt;set $wakemsg to &quot;You indulge in a long nap.&quot;&gt;&gt;
        &lt;&lt;sleep2 120&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 120&gt;&gt; &lt;&lt;set _restamt to (120 / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;

    &lt;&lt;link &quot;Short Nap&quot;&gt;&gt;
        &lt;&lt;set $wakemsg to &quot;You set your phone&#39;s alarm for one hour and grab a short nap.&quot;&gt;&gt;
        &lt;&lt;sleep2 60&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;set _restamt to (60 / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;

    &lt;&lt;link &quot;Powernap&quot;&gt;&gt;
        &lt;&lt;set $wakemsg to &quot;You set your phone&#39;s alarm for 15 minutes and grab a quick nap.&quot;&gt;&gt;
        &lt;&lt;sleep2 15&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 15&gt;&gt; &lt;&lt;set _restamt to (15 / 60) * _sleepquality&gt;&gt;&lt;&lt;dalterneed Rest _restamt&gt;&gt;&lt;br&gt;

&lt;&lt;/if&gt;&gt;
&lt;&lt;link &quot;Just get up&quot; _getuppassage&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;span id=&quot;sleepoutput&quot;&gt;&lt;/span&gt;</tw-passagedata>
~~
	else if (setup.School.is_pc_at_class(true) && (V.inclass || V.prevclass))
~
	else if (locblock == "Residence")
	{ 
		let classestoday = setup.School.classes_today();
		let dayoffconstants = ["showers", "restroom", "food", "home"];

		const scheduleslots = setup.Time.current_schedule_slot_calcall();
		
		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			let resident = setup.people.get_person(V.pcresidenceowner);
			let roommate = setup.people.get_person(V.pcresidenceowner);
			
			if (pinfo == resident)
			{
				belonghere = true;
			}
			if (pinfo == roommate)
			{	
				belonghere = true;
			}
			if (pinfo.type == "student" && belonghere && resident)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (slotloc == "home")
				{
					retval.push(person);
				}
				if (slotloc == "free time")
				{
					retval.push(person);
				}
				if (slotloc == "food")
				{
					retval.push(person);
				}
			}
			else if (pinfo.type == "student" && belonghere && roommate)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (slotloc == "home")
				{
					retval.push(person);
				}
			}
			else if (belonghere)
			{
				retval.push(person);
			}
		}
	}
	else if (setup.School.is_pc_at_class(true) && (V.inclass || V.prevclass))
~~
	else if (setup.School.is_pc_at_class(true) && (V.inclass || V.prevclass))
else if (locblock == "Residence")
	{ 
		let classestoday = setup.School.classes_today();
		let dayoffconstants = ["showers", "restroom", "food", "home"];

		const scheduleslots = setup.Time.current_schedule_slot_calcall();
		
		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			let resident = setup.people.get_person(V.pcresidenceowner);
			let roommate = setup.people.get_person(V.pcresidenceowner);
			
			if (pinfo == resident)
			{
				belonghere = true;
			}
			if (pinfo == roommate)
			{	
				belonghere = true;
			}
			if (pinfo.type == "student" && belonghere && resident)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (slotloc == "home")
				{
					retval.push(person);
				}
				if (slotloc == "free time")
				{
					retval.push(person);
				}
				if (slotloc == "food")
				{
					retval.push(person);
				}
			}
			else if (pinfo.type == "student" && belonghere && roommate)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (slotloc == "home")
				{
					retval.push(person);
				}
			}
			else if (belonghere)
			{
				retval.push(person);
			}
		}
	}
~
	else if (locblock == "Residence")
	{ 
		let classestoday = setup.School.classes_today();
		let dayoffconstants = ["showers", "restroom", "food", "home"];

		const scheduleslots = setup.Time.current_schedule_slot_calcall();
		
		for (const [person, pinfo] of Object.entries(db))
		{
			let belonghere = false;
			let resident = setup.people.get_person(V.pcresidenceowner);
			let roommate = setup.people.get_person(V.pcresidenceowner);
			
			if (pinfo == resident)
			{
				belonghere = true;
			}
			if (pinfo == roommate)
			{		
				belonghere = true;
			}
			if (pinfo.type == "student" && belonghere && resident)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (slotloc == "home")
				{
					retval.push(person);
				}
				if (slotloc == "free time")
				{
					retval.push(person);
				}
				if (slotloc == "food")
				{
					retval.push(person);
				}
			}
			else if (pinfo.type == "student" && belonghere && roommate)
			{
				let slot = typeof pinfo.schedule == "number" ? scheduleslots[pinfo.schedule - 1] : this.Time.current_schedule_slot(setup.get_student_schedule(pinfo.schedule));
				let slotloc = (classestoday || dayoffconstants.includes(slot.location)) ? slot.location : "free time";
				if (slotloc == "home")
				{
					retval.push(person);
				}
			}
			else if (belonghere)
			{
				retval.push(person);
			}
		}
	}
	else if (setup.School.is_pc_at_class(true) && (V.inclass || V.prevclass))
~~
    // bff dorm events
~
    // residents events
	
	{
        passage: "EventResidentWatchMovieStart",
        tags: ["resident", "movie", "start"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovie",
        tags: ["resident", "movie"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovieWatch",
        tags: ["resident", "movie"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovieLaugh",
        tags: ["resident", "movie"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovieEatPizza",
        tags: ["resident", "movie"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovieEatSnacks",
        tags: ["resident", "movie"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovieEatJumpscare",
        tags: ["resident", "movie"],
        frequency: 100,
    },
	{
        passage: "EventResidentWatchMovieEnd",
        tags: ["resident", "movie"],
        frequency: 100,
    },
    {
        passage: "EventResidentChatFriend",
        tags: ["resident", "chat"],
        frequency: 100,
    },
    {
        passage: "EventResidentChatRival",
        tags: ["resident", "chat"],
        frequency: 100,
    },
    {
        passage: "EventResidentChatClasses",
        tags: ["resident", "chat"],
        frequency: 100,
    },
	/*
    {
        passage: "EventResidentChatFlirty",
        tags: ["resident", "chat", "flirty"],
        frequency: 100,
		checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.get_attitude($eventnpc, "lust") gte 500',
    },
	*/
    {
        passage: "EventResidentChatEnd",
        tags: ["resident", "chat"],
        frequency: 100,
    },
	
	// bff dorm events
~~
    The music abruptly falls silent, everyone talking and laughing too loudly for a moment until they adjust to the relative quiet. Gradually students get the message and start shuffling back to their dorms. It&#39;s a disaster in here, chip crumbs and red cups everywhere.&lt;br&gt;
&lt;&lt;/if&gt;&gt;
&lt;br&gt;
&lt;&lt;set _link to {text: &quot;Go outside&quot;, link: &quot;QuadParty&quot;, emoji: &#39;🚪&#39;}&gt;&gt;
~
&lt;&lt;if ((setup.Time.weekday() eq "Friday" and V.hour gte 18) or (setup.Time.weekday() eq "Saturday" and V.hour lte 3))&gt;&gt;
The music abruptly falls silent, everyone talking and laughing too loudly for a moment until they adjust to the relative quiet. Gradually students get the message and start shuffling back to their dorms. It&#39;s a disaster in here, chip crumbs and red cups everywhere.
&lt;&lt;else&gt;&gt;
Helleborine Hall features a cozy lounge that serves as a welcoming gathering space for residents, with comfortable seating arrangements and vibrant decor. Large windows allow natural light to flood the room, creating a warm and inviting atmosphere ideal for studying or socializing. 
&lt;br&gt;&lt;br&gt;
The lounge often hosts community events, fostering connections among students and enhancing the dorm's sense of community.
&lt;&lt;/if&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;br&gt;
&lt;&lt;set _residience to &quot;Helleborine Hall&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;br&gt;
&lt;&lt;if ((setup.Time.weekday() eq "Friday" and V.hour gte 18) or (setup.Time.weekday() eq "Saturday" and V.hour lte 3))&gt;&gt;
&lt;&lt;set _link to {text: &quot;Go outside&quot;, link: &quot;QuadParty&quot;, emoji: &#39;🚪&#39;}&gt;&gt;
&lt;&lt;else&gt;&gt;
&lt;&lt;set _link to {text: &quot;Go outside&quot;, link: &quot;HannaRdS&quot;, emoji: &#39;🚪&#39;}&gt;&gt;
&lt;&lt;/if&gt;&gt;
~~
<tw-passagedata pid="3086" name="DatePalmSt" tags="location locDatePalmSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏢" position="725,38600" size="100,100">You are on Date Palm Street, a crowded residential street. An apartment building stands here, a few storeys tall, making it one of the largest buildings in this rural college town.
~
<tw-passagedata pid="3086" name="DatePalmSt" tags="location locDatePalmSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏢" position="725,38600" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Date Palm Street, a crowded residential street. An apartment building stands here, a few storeys tall, making it one of the largest buildings in this rural college town.
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;Date Palm Street&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;DatePalmSt&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;off-campus&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;
~~
<tw-passagedata pid="3086" name="DatePalmSt" tags="location locDatePalmSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏢" position="725,38600" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Date Palm Street, a crowded residential street. An apartment building stands here, a few storeys tall, making it one of the largest buildings in this rural college town.
~
<tw-passagedata pid="3086" name="DatePalmSt" tags="location locDatePalmSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏢" position="725,38600" size="100,100">&lt;&lt;nobr&gt;&gt;&lt;&lt;nobr&gt;&gt;You are on Date Palm Street, a crowded residential street. An apartment building stands here, a few storeys tall, making it one of the largest buildings in this rural college town.
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;Date Palm Street&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;DatePalmSt&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;off-campus&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;&lt;br&gt;
~~
<tw-passagedata pid="3122" name="SaffronSt" tags="location locSaffronSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏡" position="225,39100" size="100,100">You are on Saffron Street. A cluster of houses marks the edge of town here on the road back to the university. There are more residences and businesses along the way, but things get rather sparse and rural.
~
<tw-passagedata pid="3122" name="SaffronSt" tags="location locSaffronSt locblockTown roomtypestreet outdoors street townwalk hasmap emoji🏡" position="225,39100" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Saffron Street. A cluster of houses marks the edge of town here on the road back to the university. There are more residences and businesses along the way, but things get rather sparse and rural.
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;Saffron Street&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;SaffronSt&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;
~~
<tw-passagedata pid="3018" name="BancroftLn" tags="location locBancroftLn locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏠" position="975,37725" size="100,100">You are on Bancroft Lane. A row of suite-style residences is here, meant for wealthier upperclass or postgrad types. Definitely too rich for your blood.&lt;&lt;if $exhibitionsneak&gt;&gt; You&#39;re trying to stay hidden behind some fancy shrubbery.&lt;&lt;/if&gt;&gt;
~
<tw-passagedata pid="3018" name="BancroftLn" tags="location locBancroftLn locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏠" position="975,37725" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Bancroft Lane. A row of suite-style residences is here, meant for wealthier upperclass or postgrad types. Definitely too rich for your blood.&lt;&lt;if $exhibitionsneak&gt;&gt; You&#39;re trying to stay hidden behind some fancy shrubbery.&lt;&lt;/if&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;BancroftLn&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;Bancroft Lane&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;
~~
<tw-passagedata pid="3018" name="BancroftLn" tags="location locBancroftLn locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏠" position="975,37725" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Bancroft Lane. A row of suite-style residences is here, meant for wealthier upperclass or postgrad types. Definitely too rich for your blood.&lt;&lt;if $exhibitionsneak&gt;&gt; You&#39;re trying to stay hidden behind some fancy shrubbery.&lt;&lt;/if&gt;&gt;
~
<tw-passagedata pid="3018" name="BancroftLn" tags="location locBancroftLn locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏠" position="975,37725" size="100,100">&lt;&lt;nobr&gt;&gt;&lt;&lt;nobr&gt;&gt;You are on Bancroft Lane. A row of suite-style residences is here, meant for wealthier upperclass or postgrad types. Definitely too rich for your blood.&lt;&lt;if $exhibitionsneak&gt;&gt; You&#39;re trying to stay hidden behind some fancy shrubbery.&lt;&lt;/if&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;BancroftLn&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;Bancroft Lane&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;
~~
<tw-passagedata pid="3048" name="PrescottRd" tags="location locPrescottRd locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🔱" position="975,38100" size="100,100">You are on Prescott Road. This are is well-landscaped and home to a row of Greek houses. Frat boys and sorority girls abound.&lt;&lt;if $exhibitionsneak&gt;&gt; The decorative foliage is dense here, making it fairly easy to hide.&lt;&lt;/if&gt;&gt;
~
<tw-passagedata pid="3048" name="PrescottRd" tags="location locPrescottRd locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🔱" position="975,38100" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Prescott Road. This are is well-landscaped and home to a row of Greek houses. Frat boys and sorority girls abound.&lt;&lt;if $exhibitionsneak&gt;&gt; The decorative foliage is dense here, making it fairly easy to hide.&lt;&lt;/if&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;PrescottRd&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;Prescott Road&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;
~~
<tw-passagedata pid="3048" name="PrescottRd" tags="location locPrescottRd locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🔱" position="975,38100" size="100,100">&lt;&lt;nobr&gt;&gt;You are on Prescott Road. This are is well-landscaped and home to a row of Greek houses. Frat boys and sorority girls abound.&lt;&lt;if $exhibitionsneak&gt;&gt; The decorative foliage is dense here, making it fairly easy to hide.&lt;&lt;/if&gt;&gt;
~
<tw-passagedata pid="3048" name="PrescottRd" tags="location locPrescottRd locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🔱" position="975,38100" size="100,100">&lt;&lt;nobr&gt;&gt;&lt;&lt;nobr&gt;&gt;You are on Prescott Road. This are is well-landscaped and home to a row of Greek houses. Frat boys and sorority girls abound.&lt;&lt;if $exhibitionsneak&gt;&gt; The decorative foliage is dense here, making it fairly easy to hide.&lt;&lt;/if&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;set _residience to &quot;PrescottRd&quot;&gt;&gt;
&lt;&lt;set _residience to &quot;Prescott Road&quot;&gt;&gt;
&lt;&lt;displayresidents&gt;&gt;&lt;&lt;/nobr&gt;&gt;
~~
<tw-passagedata pid="3037" name="HannaRdS" tags="location locHannaRdS locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏨" position="850,37975" size="100,100">You are on Hanna Road South, where a couple other residence halls are located: Helleborine and Trillium. Since you don&#39;t live here, your card won&#39;t open the doors.
~
<tw-passagedata pid="3037" name="HannaRdS" tags="location locHannaRdS locblockCampus roomtypeoutsidebuilding outdoors campuswalk hasmap emoji🏨" position="850,37975" size="100,100">You are on Hanna Road South, where a couple other residence halls are located: Helleborine and Trillium. Since you don&#39;t live here, your card won&#39;t open the doors.

But luckily enough, you have friends that do. 
&lt;&lt;link &quot;Go inside&quot; &quot;HelleborineHall&quot;&gt;&gt;
    &lt;&lt;advtime 1&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 1&gt;&gt;&lt;br&gt;
~~
