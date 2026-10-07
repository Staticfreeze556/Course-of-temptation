&lt;&lt;if $round2available&gt;&gt;
    &lt;&lt;run _allowed.push(&quot;fuck&quot;)&gt;&gt;
&lt;&lt;/if&gt;&gt;

&lt;&lt;if _allowed.includes(&quot;fuck&quot;)&gt;&gt;
    &lt;&lt;link &quot;Go for round two&quot; EncounterRound&gt;&gt;
        &lt;&lt;unset $round2available&gt;&gt;
        &lt;&lt;set _role to $pc.has_part(&quot;penis&quot;) ? &quot;top&quot; : &quot;bottom&quot;&gt;&gt;
        &lt;&lt;set _npcexp to new Person({person: $lastpartner})&gt;&gt;
        &lt;&lt;run _npcexp.remove_all_clothing()&gt;&gt;
        &lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;, _npcexp], endpassage: $postencounterpassage, starting_position: &quot;Spooning&quot;, starting_role: _role})&gt;&gt;
    &lt;&lt;/link&gt;&gt;
    &lt;br&gt;~&lt;&lt;if true&gt;&gt;
    &lt;&lt;run _allowed.push(&quot;fuck&quot;)&gt;&gt;
&lt;&lt;/if&gt;&gt;

&lt;&lt;if _allowed.includes(&quot;fuck&quot;)&gt;&gt;
    &lt;&lt;link &quot;Go another round&quot; EncounterRound&gt;&gt;
        &lt;&lt;unset $round2available&gt;&gt;
        &lt;&lt;set _role to $pc.has_part(&quot;penis&quot;) ? &quot;top&quot; : &quot;bottom&quot;&gt;&gt;
        &lt;&lt;set _npcexp to new Person({person: $lastpartner})&gt;&gt;
        &lt;&lt;run _npcexp.remove_all_clothing()&gt;&gt;
        &lt;&lt;run setup.build_encounter({people: [&quot;PC&quot;, _npcexp], endpassage: $postencounterpassage, starting_position: &quot;Spooning&quot;, starting_role: _role})&gt;&gt;
    &lt;&lt;/link&gt;&gt;
    &lt;br&gt;