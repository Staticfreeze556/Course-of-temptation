        &lt;&lt;run $interactionstoday[$eventnpc].push(&quot;flirt&quot;)&gt;&gt;
        &lt;&lt;advtime _talktime Attention&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
    &lt;br&gt;
&lt;&lt;/if&gt;&gt;

&lt;&lt;if _valid and (!$hangoutstoday or !$hangoutstoday.includes($eventnpc))&gt;&gt;
    &lt;&lt;if !setup.people.planned_date_with($eventnpc) and setup.people.is_known($eventnpc)&gt;&gt;
        &lt;&lt;link &quot;Offer to hang out later&quot; InPersonDialogueScheduleHangout&gt;&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
        &lt;br&gt;

        &lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gt 0&gt;&gt;
            &lt;&lt;link &quot;Ask &lt;&lt;po $eventnpc&gt;&gt; out on a date&quot; InPersonDialogueScheduleDate&gt;&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
            &lt;br&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/if&gt;&gt;~        &lt;&lt;run $interactionstoday[$eventnpc].push(&quot;flirt&quot;)&gt;&gt;
        &lt;&lt;advtime _talktime Attention&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
    &lt;br&gt;
&lt;&lt;/if&gt;&gt;

&lt;&lt;if true&gt;&gt;
            &lt;&lt;if setup.people.willing_sex($eventnpc)&gt;&gt;
            &lt;&lt;set _linkname to &quot;Quick Sex&quot;&gt;&gt;
                &lt;&lt;link _linkname EncounterRound&gt;&gt;
				&lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;, $eventnpc], endpassage: &quot;EventWalkFBQuickiePost&quot;})&gt;&gt;
				&lt;&lt;/link&gt;&gt; 
                &lt;br&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/if&gt;&gt;

&lt;&lt;if _valid &gt;&gt;
    &lt;&lt;if !setup.people.planned_date_with($eventnpc) and setup.people.is_known($eventnpc)&gt;&gt;
        &lt;&lt;link &quot;Offer to hang out later&quot; InPersonDialogueScheduleHangout&gt;&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
        &lt;br&gt;

        &lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gt 0&gt;&gt;
            &lt;&lt;link &quot;Ask &lt;&lt;po $eventnpc&gt;&gt; out on a date&quot; InPersonDialogueScheduleDate&gt;&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
            &lt;br&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/if&gt;&gt;