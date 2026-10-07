~~
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
~
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

	&lt;&lt;set _major to $pcmajor&gt;&gt;
    &lt;&lt;if _comp and _major is &quot;compsci&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freecodelink to {text: &quot;Freelance Code Design&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freecodelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;art&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Graphic Design&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;art&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Digital Illustration&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Artistic&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;math&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Statistical Consulting&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;psychology&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Behavioral Analysis Consulting&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;history&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Cultural Consultancy&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;science&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Research and Data Analysis&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;business&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Business Consulting&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;english&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Proofreading and Editing&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/nobr&gt;&gt;
~~
    &lt;&lt;if _comp&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _gamelink to {text: &quot;Play game&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _gamelink&gt;&gt;
            &lt;&lt;advtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Video Gaming&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
~
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

	&lt;&lt;set _major to $pcmajor&gt;&gt;
    &lt;&lt;if _comp and _major is &quot;compsci&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freecodelink to {text: &quot;Freelance Code Design&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freecodelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;art&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Graphic Design&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;art&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Digital Illustration&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Artistic&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;math&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Statistical Consulting&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;psychology&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Behavioral Analysis Consulting&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;history&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Cultural Consultancy&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;science&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Research and Data Analysis&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;business&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Business Consulting&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
    &lt;&lt;if _comp and _major is &quot;english&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;set _freelancelink to {text: &quot;Freelance Proofreading and Editing&quot;, emoji: &quot;🎮&quot;}&gt;&gt;
        &lt;&lt;link _freelancelink&gt;&gt;
            &lt;&lt;safeadvtime 30 Relaxation&gt;&gt;
            &lt;&lt;run setup.Needs.enjoy(75)&gt;&gt;
            &lt;&lt;raiseskill &quot;Intellectual&quot; 1&gt;&gt;
            &lt;&lt;set _event to setup.Events.passage([&quot;freelance jobs&quot;])&gt;&gt;
            &lt;&lt;egoto _event&gt;&gt;
        &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 75&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/nobr&gt;&gt;
~~
&lt;&lt;/nobr&gt;&gt;
&lt;&lt;/nobr&gt;&gt;
~
&lt;&lt;/nobr&gt;&gt;
~~
    {
        passage: "EventVideoGameSoloNoBra",
        tags: ["video game solo", "hard nipples"],
        nolocations: ["YourDorm"],
        frequency: 65,
    },
~
    {
        passage: "EventVideoGameSoloNoBra",
        tags: ["video game solo", "hard nipples"],
        nolocations: ["YourDorm"],
        frequency: 65,
    },
    {
        passage: "EventFreelanceJobs",
        tags: ["freelance jobs"],
        frequency: 100,
    },
~~
<tw-passagedata pid="1060" name="EventVideoGameSolo" tags="event" position="1225,13225" size="100,100">You sit back with a controller and become absorbed by a video game for a while. &lt;&lt;dalterneed Relaxation 50&gt;&gt;

&lt;&lt;continuelink&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="1060" name="EventVideoGameSolo" tags="event" position="1225,13225" size="100,100">You sit back with a controller and become absorbed by a video game for a while. &lt;&lt;dalterneed Relaxation 50&gt;&gt;

&lt;&lt;continuelink&gt;&gt;</tw-passagedata><tw-passagedata pid="1060" name="EventFreelanceJobs" tags="event" position="1225,13225" size="100,100">
&lt;&lt;nobr&gt;&gt;

	&lt;&lt;set _major to $pcmajor&gt;&gt;
    &lt;&lt;if _major is &quot;compsci&quot;&gt;&gt;
		You sit back with your computer and do some freelance coding jobs on Fiveler. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Intellectual&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if _major is &quot;art&quot;&gt;&gt;
		You sit back with your computer and do some freelance art design jobs on Artwagon. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Artistic&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if _major is &quot;psychology&quot;&gt;&gt;
		You sit back with your computer and do some freelance behavior consultancy on Psychx. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Artistic&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if _major is &quot;history&quot;&gt;&gt;
		You sit back with your computer and do some freelance historical consultancy on Histx. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Artistic&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if _major is &quot;science&quot;&gt;&gt;
		You sit back with your computer and do some freelance scientific data analysis on Sciblog. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Artistic&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if _major is &quot;business&quot;&gt;&gt;
		You sit back with your computer and do some freelance business consulting on BisndIn. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Artistic&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if _major is &quot;english&quot;&gt;&gt;
		You sit back with your computer and do some freelance Proofreading and editing on Englink. &lt;br&gt;&lt;br&gt;
		&lt;&lt;set _money to $pc.skill_level(&quot;Artistic&quot;)*3&gt;&gt;
		&lt;&lt;run $pcmoney += _money&gt;&gt;
		&lt;&lt;dalterneed Relaxation 50&gt;&gt;
		&lt;&lt;continuelink&gt;&gt;
    &lt;&lt;/if&gt;&gt;
	
	
&lt;&lt;/nobr&gt;&gt;</tw-passagedata>
~~