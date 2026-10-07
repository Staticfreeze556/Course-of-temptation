~~
    {
        passage: "EventHangoutDinnerFootsie",
        tags: ["hangout", "date", "have dinner", "4"],
        frequency: 200,
        checkvar: "setup.people.attracted_enough_to_pc($hangout.partner)",
    },
~
    {
        passage: "EventHangoutDinnerFootsie",
        tags: ["hangout", "date", "have dinner", "4"],
        frequency: 200,
        checkvar: "setup.people.attracted_enough_to_pc($hangout.partner)",
    },
    {
        passage: "EventHangoutDinnerBlowjob",
        tags: ["hangout", "date", "have dinner", "4"],
        frequency: 200,
        checkvar: "setup.people.attracted_enough_to_pc($hangout.partner)",
    },
~~
<tw-passagedata pid="2166" name="EventHangoutMovieGetHandjob" tags="event hangout nobr" position="725,27100" size="100,100">&lt;&lt;if !setup.people.willing_sex($eventnpc)&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt; stares at you, shocked, and quickly pulls &lt;&lt;pp&gt;&gt; hand away.&lt;br&gt;
    &lt;br&gt;
    Oops. A little embarrassed, you turn your attention back to the movie.&lt;br&gt;
    &lt;&lt;set $hangout.romance -= 5&gt;&gt;
    &lt;&lt;set $hangout.heat -= 5&gt;&gt;
    &lt;br&gt;
    &lt;&lt;link &quot;Next&quot;&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;&lt;&lt;advtime 60&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    &lt;&lt;set $npcexpanded to new Person({person: $eventnpc})&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt;
    &lt;&lt;if $pc.under_access()&gt;&gt;
        slips &lt;&lt;pp&gt;&gt; hand easily under your &lt;&lt;shortpants $pc&gt;&gt;
    &lt;&lt;elseif $pc.elastic_waistband()&gt;&gt;
        slips &lt;&lt;pp&gt;&gt; hand easily down inside your &lt;&lt;shortpants $pc&gt;&gt;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;= setup.and($pc.clothing_displacements_to_expose(&quot;crotch&quot;, 2, &quot;he&quot;))&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if !$pc.anything_under_pants() and !$pc.wearing_underwear()&gt;&gt;
        and &lt;&lt;ps&gt;&gt; &lt;&lt;conj suck&gt;&gt; in a breath as &lt;&lt;ps&gt;&gt; &lt;&lt;conj find&gt;&gt; you&#39;re not wearing underwear. &lt;&lt;psc&gt;&gt; &lt;&lt;conj tease&gt;&gt; your &lt;&lt;if $pc.has_part(&quot;vagina&quot;)&gt;&gt;&lt;&lt;pussy $pc&gt;&gt;&lt;&lt;else&gt;&gt;&lt;&lt;cock $pc&gt;&gt;&lt;&lt;/if&gt;&gt; there in the dark theater.
        &lt;&lt;set $hangout.heat += 2&gt;&gt;
        &lt;&lt;lust $eventnpc 2 5&gt;&gt;
    &lt;&lt;else&gt;&gt;
        and &lt;&lt;ps&gt;&gt; &lt;&lt;conj cup&gt;&gt; you through your &lt;&lt;shortunderwear $pc&gt;&gt;. &lt;&lt;psc&gt;&gt; &lt;&lt;conj tease&gt;&gt; you for a moment, then &lt;&lt;conj ease&gt;&gt; &lt;&lt;pp&gt;&gt; hand down inside your underwear there in the dark theater.
    &lt;&lt;/if&gt;&gt; &lt;&lt;dalterneed Arousal 100 true&gt;&gt;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;if $pc.has_part(&quot;vagina&quot;)&gt;&gt;
        &lt;&lt;psc&gt;&gt; &lt;&lt;conj stroke&gt;&gt; your bare folds for a few minutes, smearing your wetness around as it builds up. Then &lt;&lt;ps&gt;&gt; &lt;&lt;conj curl&gt;&gt; &lt;&lt;pp&gt;&gt; fingers inside of you, forcing a gasp from you as &lt;&lt;ps&gt;&gt; &lt;&lt;conj press&gt;&gt; the heel of &lt;&lt;pp&gt;&gt; palm to your &lt;&lt;clit $pc&gt;&gt;. &lt;&lt;dalterneed Arousal 100 true&gt;&gt;&lt;br&gt;
        &lt;br&gt;
        You find yourself slouching in the seat, opening your legs wider as &lt;&lt;pp&gt;&gt; hand begins to work you mercilessly. You can hear the wet sounds of &lt;&lt;pp&gt;&gt; fingers pumping you amidst the movie&#39;s dialogue. You&#39;re no longer taking in any of it.
    &lt;&lt;else&gt;&gt;
        &lt;&lt;psc&gt;&gt; &lt;&lt;conj stroke&gt;&gt; your cock, kneading your shaft with &lt;&lt;pp&gt;&gt; fingers as you grow hard. You let out a low groan as &lt;&lt;pp&gt;&gt; fingers curl around your rigid shaft. &lt;&lt;dalterneed Arousal 100 true&gt;&gt;&lt;br&gt;
        &lt;br&gt;
        You find yourself slouching in the seat, opening your legs wider as &lt;&lt;pp&gt;&gt; hand begins to pump your cock mercilessly. Instinctively you arch your hips, trying to fuck &lt;&lt;pp&gt;&gt; fist.
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;set _arousalamt to 100 * ($pchorny + 1)&gt;&gt;
    &lt;&lt;if $pc.has_inclination(&quot;Hair Trigger&quot;)&gt;&gt;&lt;&lt;set _arousalamt += 200&gt;&gt;
    &lt;&lt;elseif $pc.has_inclination(&quot;Takes Patience&quot;)&gt;&gt;&lt;&lt;set _arousalamt -= 200&gt;&gt;&lt;&lt;/if&gt;&gt;
    &lt;&lt;if _arousalamt lt 100&gt;&gt;&lt;&lt;set _arousalamt to 100&gt;&gt;&lt;&lt;/if&gt;&gt;
    &lt;br&gt;
    &lt;br&gt;
    You can feel your orgasm building. Do you really want to cum in the middle of a theater?&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 4 &quot;Let yourself cum&quot; EventHangoutMovieGetHandjobCum&gt;&gt;&lt;&lt;control $eventnpc 25&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    &lt;&lt;link &quot;Try to resist&quot;&gt;&gt;
        &lt;&lt;if $pc.skillcheck(&quot;Willpower&quot;, $pc.resist_arousal_difficulty())&gt;&gt;
            &lt;&lt;egoto EventHangoutMovieGetHandjobCumResist&gt;&gt;
        &lt;&lt;else&gt;&gt;
            &lt;&lt;set $header to &quot;You struggle to hold back, whispering softly for &lt;&lt;firstname $eventnpc&gt;&gt; to slow down. But you can feel your arousal building steadily.&quot;&gt;&gt;
            &lt;&lt;control $eventnpc 50&gt;&gt;
            &lt;&lt;egoto EventHangoutMovieGetHandjobCum&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;skillcheck Willpower $pc.resist_arousal_difficulty()&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
~
<tw-passagedata pid="2166" name="EventHangoutMovieGetHandjob" tags="event hangout nobr" position="725,27100" size="100,100">&lt;&lt;if !setup.people.willing_sex($eventnpc)&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt; stares at you, shocked, and quickly pulls &lt;&lt;pp&gt;&gt; hand away.&lt;br&gt;
    &lt;br&gt;
    Oops. A little embarrassed, you turn your attention back to the movie.&lt;br&gt;
    &lt;&lt;set $hangout.romance -= 5&gt;&gt;
    &lt;&lt;set $hangout.heat -= 5&gt;&gt;
    &lt;br&gt;
    &lt;&lt;link &quot;Next&quot;&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;&lt;&lt;advtime 60&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    &lt;&lt;set $npcexpanded to new Person({person: $eventnpc})&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt;
    &lt;&lt;if $pc.under_access()&gt;&gt;
        slips &lt;&lt;pp&gt;&gt; hand easily under your &lt;&lt;shortpants $pc&gt;&gt;
    &lt;&lt;elseif $pc.elastic_waistband()&gt;&gt;
        slips &lt;&lt;pp&gt;&gt; hand easily down inside your &lt;&lt;shortpants $pc&gt;&gt;
    &lt;&lt;else&gt;&gt;
        &lt;&lt;= setup.and($pc.clothing_displacements_to_expose(&quot;crotch&quot;, 2, &quot;he&quot;))&gt;&gt;
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;if !$pc.anything_under_pants() and !$pc.wearing_underwear()&gt;&gt;
        and &lt;&lt;ps&gt;&gt; &lt;&lt;conj suck&gt;&gt; in a breath as &lt;&lt;ps&gt;&gt; &lt;&lt;conj find&gt;&gt; you&#39;re not wearing underwear. &lt;&lt;psc&gt;&gt; &lt;&lt;conj tease&gt;&gt; your &lt;&lt;if $pc.has_part(&quot;vagina&quot;)&gt;&gt;&lt;&lt;pussy $pc&gt;&gt;&lt;&lt;else&gt;&gt;&lt;&lt;cock $pc&gt;&gt;&lt;&lt;/if&gt;&gt; there in the dark theater.
        &lt;&lt;set $hangout.heat += 2&gt;&gt;
        &lt;&lt;lust $eventnpc 2 5&gt;&gt;
    &lt;&lt;else&gt;&gt;
        and &lt;&lt;ps&gt;&gt; &lt;&lt;conj cup&gt;&gt; you through your &lt;&lt;shortunderwear $pc&gt;&gt;. &lt;&lt;psc&gt;&gt; &lt;&lt;conj tease&gt;&gt; you for a moment, then &lt;&lt;conj ease&gt;&gt; &lt;&lt;pp&gt;&gt; hand down inside your underwear there in the dark theater.
    &lt;&lt;/if&gt;&gt; &lt;&lt;dalterneed Arousal 100 true&gt;&gt;&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;if $pc.has_part(&quot;vagina&quot;)&gt;&gt;
        &lt;&lt;psc&gt;&gt; &lt;&lt;conj stroke&gt;&gt; your bare folds for a few minutes, smearing your wetness around as it builds up. Then &lt;&lt;ps&gt;&gt; &lt;&lt;conj curl&gt;&gt; &lt;&lt;pp&gt;&gt; fingers inside of you, forcing a gasp from you as &lt;&lt;ps&gt;&gt; &lt;&lt;conj press&gt;&gt; the heel of &lt;&lt;pp&gt;&gt; palm to your &lt;&lt;clit $pc&gt;&gt;. &lt;&lt;dalterneed Arousal 100 true&gt;&gt;&lt;br&gt;
        &lt;br&gt;
        You find yourself slouching in the seat, opening your legs wider as &lt;&lt;pp&gt;&gt; hand begins to work you mercilessly. You can hear the wet sounds of &lt;&lt;pp&gt;&gt; fingers pumping you amidst the movie&#39;s dialogue. You&#39;re no longer taking in any of it.
    &lt;&lt;else&gt;&gt;
        &lt;&lt;psc&gt;&gt; &lt;&lt;conj stroke&gt;&gt; your cock, kneading your shaft with &lt;&lt;pp&gt;&gt; fingers as you grow hard. You let out a low groan as &lt;&lt;pp&gt;&gt; fingers curl around your rigid shaft. &lt;&lt;dalterneed Arousal 100 true&gt;&gt;&lt;br&gt;
        &lt;br&gt;
        You find yourself slouching in the seat, opening your legs wider as &lt;&lt;pp&gt;&gt; hand begins to pump your cock mercilessly. Instinctively you arch your hips, trying to fuck &lt;&lt;pp&gt;&gt; fist.
    &lt;&lt;/if&gt;&gt;
    &lt;&lt;set _arousalamt to 100 * ($pchorny + 1)&gt;&gt;
    &lt;&lt;if $pc.has_inclination(&quot;Hair Trigger&quot;)&gt;&gt;&lt;&lt;set _arousalamt += 200&gt;&gt;
    &lt;&lt;elseif $pc.has_inclination(&quot;Takes Patience&quot;)&gt;&gt;&lt;&lt;set _arousalamt -= 200&gt;&gt;&lt;&lt;/if&gt;&gt;
    &lt;&lt;if _arousalamt lt 100&gt;&gt;&lt;&lt;set _arousalamt to 100&gt;&gt;&lt;&lt;/if&gt;&gt;
    &lt;br&gt;
    &lt;br&gt;
    You can feel your orgasm building. Do you really want to cum in the middle of a theater?&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 4 &quot;Let yourself cum&quot; EventHangoutMovieGetHandjobCum&gt;&gt;&lt;&lt;control $eventnpc 25&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    
	&lt;&lt;skillgate Disinhibition 4 &quot;Get a blowjob&quot; EventHangoutMovieGetBlowjobCum&gt;&gt;&lt;&lt;control $eventnpc 25&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    
    &lt;&lt;link &quot;Try to resist&quot;&gt;&gt;
        &lt;&lt;if $pc.skillcheck(&quot;Willpower&quot;, $pc.resist_arousal_difficulty())&gt;&gt;
            &lt;&lt;egoto EventHangoutMovieGetHandjobCumResist&gt;&gt;
        &lt;&lt;else&gt;&gt;
            &lt;&lt;set $header to &quot;You struggle to hold back, whispering softly for &lt;&lt;firstname $eventnpc&gt;&gt; to slow down. But you can feel your arousal building steadily.&quot;&gt;&gt;
            &lt;&lt;control $eventnpc 50&gt;&gt;
            &lt;&lt;egoto EventHangoutMovieGetHandjobCum&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;skillcheck Willpower $pc.resist_arousal_difficulty()&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata><tw-passagedata pid="21670" name="EventHangoutMovieGetBlowjobCum" tags="event hangout nobr" position="850,27100" size="100,100">&lt;&lt;if $pc.has_part(&quot;vagina&quot;)&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt; sinks down to the floor in front of your seat and pulls your pants down to your ankles.
	You bite down hard on a cry as your body begins to quake with pleasure. Your hips pump into 
	&lt;&lt;firstname $eventnpc&gt;&gt;&#39;s mouth as you feel &lt;&lt;pp&gt;&gt; milking your pussy with &lt;&lt;pp&gt;&gt; mouth.
    &lt;&lt;run setup.record_sex_memory($eventnpc, &quot;fingerbang received&quot;)&gt;&gt;
&lt;&lt;else&gt;&gt;
	&lt;&lt;firstname $eventnpc&gt;&gt; sinks down to the floor in front of your seat and pulls down your pants.
	&lt;br&gt;&lt;br&gt;

    Looking up at you, &lt;&lt;ps&gt;&gt; then &lt;&lt;conj lean&gt;&gt; forward, taking your cock between &lt;&lt;pp&gt;&gt; lips. 
	&lt;&lt;if $pc.arousal() lt 100&gt;&gt;
		You groan softly as your cock swells in &lt;&lt;pp&gt;&gt; mouth.
	&lt;&lt;else&gt;&gt;
		You groan with pleasure as &lt;&lt;ps&gt;&gt; &lt;&lt;conj take&gt;&gt; you into &lt;&lt;pp&gt;&gt; warm, wet mouth.
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;run $pc.add_arousal(100, 900)&gt;&gt; 
	&lt;&lt;lust $eventnpc 10 15&gt;&gt;&lt;&lt;set $hangout.heat += 60&gt;&gt;
    &lt;br&gt;&lt;br&gt;
	
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj bob&gt;&gt; &lt;&lt;pp&gt;&gt; head slowly, making a good, teasing show for you. You rock your hips faster, pumping your cock in and out of &lt;&lt;pp&gt;&gt; mouth while &lt;&lt;ps&gt;&gt; &lt;&lt;conj look&gt;&gt; you 
	straight into your eyes.
    &lt;br&gt;&lt;br&gt;
	
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj keep&gt;&gt; sucking you off until &lt;&lt;ps&gt;&gt; &lt;&lt;conj feel&gt;&gt; your cock start to throb inside &lt;&lt;pp&gt;&gt; mouth. 
	&lt;br&gt;&lt;br&gt;
	
    You bite down on a groan as your hips thrust helplessly. Cum pumps out into &lt;&lt;firstname $eventnpc&gt;&gt;&#39;s mouth as you feel &lt;&lt;pp&gt;&gt; milking your cock with &lt;&lt;pp&gt;&gt; throat.
    &lt;&lt;run setup.record_sex_memory($eventnpc, &quot;blowjob received&quot;)&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;cheatingreaction $eventnpc&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;orgasm $pc $eventnpc mouth&gt;&gt;
Once you come down, &lt;&lt;ps&gt;&gt; &lt;&lt;conj withdraw&gt;&gt; &lt;&lt;pp&gt;&gt; mouth. &lt;&lt;psc&gt;&gt; &lt;&lt;conj grin&gt;&gt; at you as &lt;&lt;ps&gt;&gt; &lt;&lt;conj make&gt;&gt; a little show of swallowing the rest of your cum and licking &lt;&lt;pp&gt;&gt; fingers clean.
&lt;&lt;lust $eventnpc 10 15&gt;&gt;&lt;&lt;set $hangout.heat += 5&gt;&gt;
&lt;br&gt;&lt;br&gt;
Still breathing hard, you try to return your attention to the movie.&lt;br&gt;
&lt;br&gt;
&lt;&lt;unset $npcexpanded&gt;&gt;
&lt;&lt;link &quot;Next&quot;&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;&lt;&lt;advtime 60&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata>
~~
<tw-passagedata pid="2020" name="EventHangoutDinnerHoldHandsReject" tags="event hangout" position="1225,25225" size="100,100">You try to act like you don&#39;t notice what &lt;&lt;firstname $eventnpc&gt;&gt; is trying to do, although you clearly do. It&#39;s rather awkward and &lt;&lt;pss&gt;&gt; clearly disappointed.
&lt;&lt;set $hangout.romance -= 3&gt;&gt;&lt;&lt;set $hangout.heat -= 3&gt;&gt;\

&lt;&lt;link &quot;Next&quot;&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;&lt;&lt;advtime 10&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata><tw-passagedata pid="2021" name="EventHangoutDinnerFootsie" tags="event hangout nobr" position="100,25350" size="100,100">&lt;&lt;set _desrel to setup.people.desired_relationship($eventnpc)&gt;&gt;
&lt;&lt;if (_desrel is &quot;fuckbuddy&quot; or setup.people.willing_sex($eventnpc)) and setup.people.has_any_inclination($eventnpc, &quot;active&quot;)&gt;&gt;
    The conversation pauses, and &lt;&lt;firstname $eventnpc&gt;&gt; gives you a look that you can&#39;t quite decipher. But a moment later, the meaning becomes clear as you feel &lt;&lt;pp&gt;&gt; foot sliding up along your leg.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 1 &quot;Go with it&quot; EventHangoutDinnerFootsieReceive&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    &lt;&lt;link &quot;Ignore it&quot; EventHangoutDinnerFootsieReject&gt;&gt;
    &lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    There&#39;s a lull in the conversation, and you find yourself contemplating &lt;&lt;firstname $eventnpc&gt;&gt; from across the table.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 2 &quot;Play a little footsie&quot; EventHangoutDinnerFootsieGive&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    &lt;&lt;link &quot;Smile&quot; EventHangoutDinnerFootsieSmile&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Do nothing&quot;&gt;&gt;
        &lt;&lt;advtime 10&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;
    &lt;&lt;/link&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
~
    &lt;&lt;link &quot;Smile&quot; EventHangoutDinnerFootsieSmile&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Do nothing&quot;&gt;&gt;
        &lt;&lt;advtime 10&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;
    &lt;&lt;/link&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata><tw-passagedata pid="2021" name="EventHangoutDinnerFootsie" tags="event hangout nobr" position="100,25350" size="100,100">&lt;&lt;set _desrel to setup.people.desired_relationship($eventnpc)&gt;&gt;
&lt;&lt;if (_desrel is &quot;fuckbuddy&quot; or setup.people.willing_sex($eventnpc)) and setup.people.has_any_inclination($eventnpc, &quot;active&quot;)&gt;&gt;
    The conversation pauses, and &lt;&lt;firstname $eventnpc&gt;&gt; gives you a look that you can&#39;t quite decipher. But a moment later, the meaning becomes clear as you feel &lt;&lt;pp&gt;&gt; foot sliding up along your leg.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 1 &quot;Go with it&quot; EventHangoutDinnerFootsieReceive&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
	&lt;&lt;if !$pc.has_part(&quot;vagina&quot;)&gt;&gt;
    &lt;&lt;skillgate Disinhibition 3 &quot;Get a blowjob&quot; EventHangoutDinnerBlowjobReceive &gt;&gt;&lt;&lt;/skillgate&gt;&gt;
	&lt;&lt;/if&gt;&gt;
    &lt;&lt;link &quot;Ignore it&quot; EventHangoutDinnerFootsieReject&gt;&gt;
    &lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
    There&#39;s a lull in the conversation, and you find yourself contemplating &lt;&lt;firstname $eventnpc&gt;&gt; from across the table.&lt;br&gt;
    &lt;br&gt;
    &lt;&lt;skillgate Disinhibition 2 &quot;Play a little footsie&quot; EventHangoutDinnerFootsieGive&gt;&gt;&lt;&lt;/skillgate&gt;&gt;
    &lt;&lt;link &quot;Smile&quot; EventHangoutDinnerFootsieSmile&gt;&gt;
    &lt;&lt;/link&gt;&gt;&lt;br&gt;
    &lt;&lt;link &quot;Do nothing&quot;&gt;&gt;
        &lt;&lt;advtime 10&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;
    &lt;&lt;/link&gt;&gt;
&lt;&lt;/if&gt;&gt;</tw-passagedata>
<tw-passagedata pid="21670" name="EventHangoutDinnerBlowjobReceive" tags="event hangout nobr" position="850,27100" size="100,100">&lt;&lt;if $pc.has_part(&quot;vagina&quot;)&gt;&gt;
    &lt;&lt;firstname $eventnpc&gt;&gt; ducks under the table in front of your seat and pulls your pants down and whips out your .
	You bite down hard on a cry as your body begins to quake with pleasure. Your hips pump into 
	&lt;&lt;firstname $eventnpc&gt;&gt;&#39;s mouth as you feel &lt;&lt;pp&gt;&gt; milking your pussy with &lt;&lt;pp&gt;&gt; mouth.
    &lt;&lt;run setup.record_sex_memory($eventnpc, &quot;fingerbang received&quot;)&gt;&gt;
&lt;&lt;else&gt;&gt;
	&lt;&lt;firstname $eventnpc&gt;&gt; sinks down to the floor underneath the table and pulls down your pants.
	&lt;br&gt;&lt;br&gt;

    &lt;&lt;psc&gt;&gt; &lt;&lt;conj lean&gt;&gt; forward, taking your cock between &lt;&lt;pp&gt;&gt; lips. 
	&lt;&lt;if $pc.arousal() lt 100&gt;&gt;
		You groan softly as your cock swells in &lt;&lt;pp&gt;&gt; mouth.
	&lt;&lt;else&gt;&gt;
		You groan as &lt;&lt;ps&gt;&gt; &lt;&lt;conj take&gt;&gt; you into &lt;&lt;pp&gt;&gt; warm, wet mouth.
	&lt;&lt;/if&gt;&gt;
	
	&lt;&lt;run $pc.add_arousal(100, 900)&gt;&gt; 
	&lt;&lt;lust $eventnpc 10 15&gt;&gt;&lt;&lt;set $hangout.heat += 60&gt;&gt;
    &lt;br&gt;&lt;br&gt;
	
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj bob&gt;&gt; &lt;&lt;pp&gt;&gt; head slowly. You rock your hips faster, pumping your cock in and out of &lt;&lt;pp&gt;&gt; mouth.
    &lt;br&gt;&lt;br&gt;
	
    &lt;&lt;psc&gt;&gt; &lt;&lt;conj keep&gt;&gt; sucking you off until &lt;&lt;ps&gt;&gt; &lt;&lt;conj feel&gt;&gt; your cock start to throb inside &lt;&lt;pp&gt;&gt; mouth. 
	&lt;br&gt;&lt;br&gt;
	
    You bite down on a groan as your hips thrust helplessly. Cum pumps out into &lt;&lt;firstname $eventnpc&gt;&gt;&#39;s mouth as you feel &lt;&lt;pp&gt;&gt; milking your cock with &lt;&lt;pp&gt;&gt; throat.
    &lt;&lt;run setup.record_sex_memory($eventnpc, &quot;blowjob received&quot;)&gt;&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;cheatingreaction $eventnpc&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;orgasm $pc $eventnpc mouth&gt;&gt;
Once you come down, &lt;&lt;ps&gt;&gt; &lt;&lt;conj withdraw&gt;&gt; &lt;&lt;pp&gt;&gt; mouth. &lt;&lt;ps&gt;&gt; &lt;&lt;conj come&gt;&gt; up from underneath the table and  grins at you as &lt;&lt;ps&gt;&gt; &lt;&lt;conj make&gt;&gt; a little show of licking &lt;&lt;pp&gt;&gt; fingers clean before swallowing your leftover cum.
&lt;&lt;lust $eventnpc 10 15&gt;&gt;&lt;&lt;set $hangout.heat += 5&gt;&gt;
&lt;br&gt;&lt;br&gt;
Still breathing hard, you try to return your attention to the dinner.&lt;br&gt;
&lt;br&gt;
&lt;&lt;unset $npcexpanded&gt;&gt;
&lt;&lt;link &quot;Next&quot;&gt;&gt;&lt;&lt;gotonexthangoutevent&gt;&gt;&lt;&lt;advtime 60&gt;&gt;&lt;&lt;/link&gt;&gt;</tw-passagedata>
~~