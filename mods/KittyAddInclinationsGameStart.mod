&lt;&lt;nobr&gt;&gt;
	&lt;&lt;highlight &quot;small nokeys&quot;&gt;&gt;
	&lt;&lt;link &quot;About gender...&quot;&gt;&gt;
		&lt;&lt;script&gt;&gt;
			Dialog.setup(&quot;Help: About Gender&quot;, &quot;help&quot;);
			Dialog.wiki(Story.get(&quot;HelpAboutGender&quot;).processText());
			Dialog.open();
		&lt;&lt;/script&gt;&gt;
	&lt;&lt;/link&gt;&gt;
	&lt;&lt;/highlight&gt;&gt;
&lt;&lt;/nobr&gt;&gt;~&lt;&lt;nobr&gt;&gt;
	&lt;&lt;highlight &quot;small nokeys&quot;&gt;&gt;
	&lt;&lt;link &quot;About gender...&quot;&gt;&gt;
		&lt;&lt;script&gt;&gt;
			Dialog.setup(&quot;Help: About Gender&quot;, &quot;help&quot;);
			Dialog.wiki(Story.get(&quot;HelpAboutGender&quot;).processText());
			Dialog.open();
		&lt;&lt;/script&gt;&gt;
	&lt;&lt;/link&gt;&gt;
	&lt;&lt;/highlight&gt;&gt;
&lt;&lt;/nobr&gt;&gt;


&lt;&lt;nobr&gt;&gt;
Inclinations help determine how your character reacts to certain things.
&lt;&lt;if true&gt;&gt;
    Grant yourself an inclination (use at your own risk!)
    &lt;&lt;set _grantinclination to &quot;Inclination name&quot;&gt;&gt;
    &lt;&lt;set _incfound to false&gt;&gt;
    &lt;span id=&quot;textbox-inclinationgranter&quot;&gt;&lt;&lt;textbox &quot;_grantinclination&quot; &quot;Inclination name&quot;&gt;&gt;&lt;/span&gt;
    &lt;&lt;script&gt;&gt;
  		$(document).ready(function() {
    	$(&#39;input[type=&quot;text&quot;]&#39;).attr(&#39;autocomplete&#39;, &#39;off&#39;);
  		});
	&lt;&lt;/script&gt;&gt;
    &lt;&lt;button &quot;Grant&quot;&gt;&gt;
        &lt;&lt;for _inc range Object.keys(setup.inclinations)&gt;&gt;
            &lt;&lt;if _inc.toLowerCase() is _grantinclination.toLowerCase()&gt;&gt;
                &lt;&lt;run setup.inclinations.unlock(_inc)&gt;&gt;
                &lt;&lt;run $inclinationsunlocked[_inc].dreamed = true&gt;&gt;
                &lt;&lt;run setup.add_inclination(_inc)&gt;&gt;
                &lt;&lt;set _incfound to true&gt;&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/for&gt;&gt;
        &lt;&lt;if _incfound&gt;&gt;
            &lt;&lt;replace &quot;#incresult&quot;&gt;&gt;Inclination &quot;_grantinclination&quot; granted!&lt;&lt;/replace&gt;&gt;
        &lt;&lt;else&gt;&gt;
            &lt;&lt;replace &quot;#incresult&quot;&gt;&gt;There&#39;s no inclination named &quot;_grantinclination&quot;. Check for typos, and try again!&lt;&lt;/replace&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;set _incfound to false&gt;&gt;
    &lt;&lt;/button&gt;&gt;
    &lt;span id=&quot;incresult&quot;&gt;&lt;/span&gt;
&lt;&lt;/if&gt;&gt;
&lt;&lt;set _found to false&gt;&gt;
&lt;&lt;for _inc range Object.keys($inclinationsunlocked)&gt;&gt;
    &lt;&lt;set _prereqs to $pc.inclination_prereqs(_inc)&gt;&gt;
    &lt;&lt;set _supporting to $pc.supporting_inclinations(_inc)&gt;&gt;
    &lt;&lt;set _opposing to $pc.inclinations_opposing(_inc)&gt;&gt;
    &lt;&lt;set _incname to _inc&gt;&gt;
    &lt;&lt;set _inc to $inclinationsunlocked[_inc]&gt;&gt;
    &lt;&lt;if _inc.dreamed&gt;&gt;
        &lt;&lt;capture _incname&gt;&gt;
            &lt;&lt;set _found to true&gt;&gt;
            &lt;b&gt;&lt;&lt;= _incname&gt;&gt;&lt;/b&gt;:
            &lt;&lt;set _info to setup.inclinations.get(_incname)&gt;&gt;
            &lt;&lt;= _info.description&gt;&gt;
            &lt;&lt;if $pc.has_inclination(_incname)&gt;&gt;
                &lt;&lt;if _inc.locked&gt;&gt;
                    &lt;span class=&quot;bad&quot;&gt;Locked.&lt;/span&gt;
                &lt;&lt;elseif _supporting.length gt 0&gt;&gt;
                    &lt;span class=&quot;ungood&quot;&gt;
                        Prereq for &lt;&lt;and _supporting&gt;&gt;.
                    &lt;/span&gt;
                &lt;&lt;else&gt;&gt;
                    &lt;span class=&quot;notice&quot;&gt;Embraced.&lt;/span&gt;
                    &lt;span style=&quot;font-size: 80%&quot;&gt;
                    (&lt;&lt;link &quot;Reject it.&quot;&gt;&gt;
                        &lt;&lt;run setup.remove_inclination(_incname)&gt;&gt;
                        &lt;&lt;script&gt;&gt;
                            Dialog.setup(&quot;Inclinations&quot;, &quot;inclinations&quot;);
                            Dialog.wiki(Story.get(&quot;Inclinations&quot;).processText());
                            Dialog.open();
                        &lt;&lt;/script&gt;&gt;
                    &lt;&lt;/link&gt;&gt;)
                    &lt;/span&gt;
                &lt;&lt;/if&gt;&gt;
            &lt;&lt;else&gt;&gt;
                &lt;&lt;if _opposing.length gt 0&gt;&gt;
                    &lt;span class=&quot;ungood&quot;&gt;
                        Incompatible with &lt;&lt;and _opposing&gt;&gt;.
                    &lt;/span&gt;
                &lt;&lt;else&gt;&gt;
                    &lt;span class=&quot;ungood&quot;&gt;Rejected.&lt;/span&gt;
                    &lt;span style=&quot;font-size: 80%&quot;&gt;
                    (&lt;&lt;link &quot;Embrace it.&quot;&gt;&gt;
                        &lt;&lt;run setup.add_inclination(_incname)&gt;&gt;
                        &lt;&lt;script&gt;&gt;
                            Dialog.setup(&quot;Inclinations&quot;, &quot;inclinations&quot;);
                            Dialog.wiki(Story.get(&quot;Inclinations&quot;).processText());
                            Dialog.open();
                        &lt;&lt;/script&gt;&gt;
                    &lt;&lt;/link&gt;&gt;)
                    &lt;/span&gt;
                &lt;&lt;/if&gt;&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/capture&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/for&gt;&gt;&lt;&lt;/nobr&gt;&gt;