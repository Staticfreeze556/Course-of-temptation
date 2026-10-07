~~
	// remove anybody who has been excised from the game
	for (const removed of V.removedpeople)
	{
		let i = retval.indexOf(removed);
		if (i >= 0)
			retval.splice(i, 1);
	}
~
	// remove anybody who has been excised from the game
	for (const removed of V.removedpeople)
	{
		let i = retval.indexOf(removed);
		if (i >= 0)
			retval.splice(i, 1);
	}

    if (V.pcfollowers) 
	{
		for (const [person, pinfo] of Object.entries(db))
			{
				let pf = setup.people.fullname(person)
				if (V.pcfollowers.includes(pf))
				{	
					if (V.peopleatlocation.includes(pf))
					{
						for (const people of V.peopleatlocation)
						{
							let i = retval.indexOf(pf);
							if (i >= 0)
								retval.splice(i, 1);
						}
						retval.push(person);
					}
					else
					{
						retval.push(person);
					}
				}
			}
	}
	
~~
&lt;&lt;set $pcage to 18&gt;&gt;
~
&lt;&lt;set $pcage to 18&gt;&gt;

&lt;&lt;set $pcfollowers to []&gt;&gt;
<!--- $pcfollowers.push() --->
~~
        &lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gt 0&gt;&gt;
            &lt;&lt;link &quot;Ask &lt;&lt;po $eventnpc&gt;&gt; out on a date&quot; InPersonDialogueScheduleDate&gt;&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
            &lt;br&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/if&gt;&gt;
~
        &lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gt 0&gt;&gt;
            &lt;&lt;link &quot;Ask &lt;&lt;po $eventnpc&gt;&gt; out on a date&quot; InPersonDialogueScheduleDate&gt;&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
            &lt;br&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/if&gt;&gt;

		&lt;&lt;if $pcfollowers eq undefined or !Array.isArray($pcfollowers)&gt;&gt;
			&lt;&lt;set $pcfollowers = []&gt;&gt; 
		&lt;&lt;/if&gt;&gt;
		
        &lt;&lt;if (setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gte 400 or setup.people.get_attitude($eventnpc, &quot;lust&quot;) gte 400 or setup.people.get_attitude($eventnpc, &quot;romance&quot;) gte 400) and !$pcfollowers.includes($eventnpc)&gt;&gt;
            &lt;&lt;link &quot;Follow me&quot; InPersonDialogueMenu&gt;&gt;
				&lt;&lt;run $pcfollowers.push($eventnpc)&gt;&gt;
				&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;
			&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
            &lt;br&gt;
        &lt;&lt;/if&gt;&gt;
		&lt;&lt;if $pcfollowers.length gt 0&gt;&gt;
			&lt;&lt;if $pcfollowers.includes($eventnpc)&gt;&gt;
				&lt;&lt;link &quot;Unfollow me&quot; InPersonDialogueMenu&gt;&gt;
					&lt;&lt;set _index = $pcfollowers.indexOf($eventnpc)&gt;&gt;
					&lt;&lt;if _index !== -1&gt;&gt;
						&lt;&lt;run $pcfollowers.splice(_index, 1)&gt;&gt;
					&lt;&lt;/if&gt;&gt;
					&gt;&lt;&lt;advtime _talktime Attention&gt;&gt;
				&lt;&lt;/link&gt;&gt; &lt;&lt;dtime _talktime&gt;&gt;
				&lt;br&gt;
			&lt;&lt;/if&gt;&gt;
		&lt;&lt;/if&gt;&gt;
	
~~
        peoplehere: 1,
    },
~
        peoplehere: 1,
        checkvar: '$pcfollowers.length == 0',
    },
~~
        peoplehere: 1,
        findnpc:
~
        peoplehere: 1,
        checkvar: '$pcfollowers.length == 0',
        findnpc:
~~
        peoplehere: 1,
        frequency:
~
        peoplehere: 1,
        checkvar: '$pcfollowers.length == 0',
        frequency:
~~