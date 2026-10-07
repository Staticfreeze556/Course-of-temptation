
setup.set_roommates = function(person1, person2)
{
    let db = setup.people_db();
    db[person1].roommate = person2;
    db[person2].roommate = person1;
}

~
setup.set_roommates = function(person1, person2)
{
    let db = setup.people_db();
    db[person1].roommate = person2;
    db[person2].roommate = person1;
}

setup.remove_roommates = function(person1)
{
    let db = setup.people_db();
    db[person1].roommate = null;
}

setup.is_pcroommate = function(person1)
{
    let db = setup.people_db();
	let student = db[person1];
	if (student.roommate == "PC")
		return true;
	else
		return false;
}
~~


&lt;&lt;link &quot;Done&quot;&gt;&gt;
    &lt;&lt;set $peopleatlocation to setup.people_at_location()&gt;&gt;
~

&lt;&lt;if setup.people.get_attitude($eventnpc, &quot;friendship&quot;) gte 500 or setup.people.get_attitude($eventnpc, &quot;romance&quot;) gte 500 or setup.people.get_attitude($eventnpc, &quot;lust&quot;) gte 500&gt;&gt;
            &lt;&lt;if !setup.is_pcroommate($eventnpc)&gt;&gt;
            &lt;&lt;set _linkname to &quot;Add Roommate&quot;&gt;&gt;
				&lt;&lt;link _linkname AddRoommateDialogue&gt;&gt;
				&lt;&lt;run setup.place_into_residence($eventnpc, "Chicory Hall")&gt;&gt;
				&lt;&lt;run setup.people_db()[$eventnpc].roommate = &quot;PC&quot;&gt;&gt;
				&lt;&lt;/link&gt;&gt;
                &lt;br&gt;
            &lt;&lt;/if&gt;&gt;  
        &lt;&lt;/if&gt;&gt;

&lt;&lt;if true&gt;&gt;
            &lt;&lt;if setup.is_pcroommate($eventnpc)&gt;&gt;
            &lt;&lt;set _linkname to &quot;Remove Roommate&quot;&gt;&gt;
				&lt;&lt;link _linkname RemoveRoommateDialogue&gt;&gt;
				&lt;&lt;run setup.remove_roommates($eventnpc)&gt;&gt;
				&lt;&lt;/link&gt;&gt;
                &lt;br&gt;
            &lt;&lt;/if&gt;&gt;
        &lt;&lt;/if&gt;&gt;

&lt;&lt;link &quot;Done&quot;&gt;&gt;
    &lt;&lt;set $peopleatlocation to setup.people_at_location()&gt;&gt;
~~
&lt;&lt;/if&gt;&gt;</tw-passagedata><tw-passagedata pid="73" name="InPersonDialogueOngoing" tags="noevents noclothingfix dialogue nobr" position="350,975" size="100,100">You&#39;re talking with &lt;&lt;anonorfullnamerel $eventnpc&gt;&gt;.
&lt;br&gt;&lt;br&gt;
&lt;&lt;include InPersonDialogueMenu&gt;&gt;</tw-passagedata>~
&lt;&lt;/if&gt;&gt;</tw-passagedata><tw-passagedata pid="73" name="InPersonDialogueOngoing" tags="noevents noclothingfix dialogue nobr" position="350,975" size="100,100">You&#39;re talking with &lt;&lt;anonorfullnamerel $eventnpc&gt;&gt;.
&lt;br&gt;&lt;br&gt;
&lt;&lt;include InPersonDialogueMenu&gt;&gt;</tw-passagedata><tw-passagedata pid="73" name="AddRoommateDialogue" tags="noevents noclothingfix dialogue nobr" position="350,975" size="100,100">You&#39;ve added &lt;&lt;anonorfullnamerel $eventnpc&gt;&gt; as a roommate.
&lt;br&gt;&lt;br&gt;
&lt;&lt;include InPersonDialogueMenu&gt;&gt;</tw-passagedata><tw-passagedata pid="73" name="RemoveRoommateDialogue" tags="noevents noclothingfix dialogue nobr" position="350,975" size="100,100">You&#39;ve removed &lt;&lt;anonorfullnamerel $eventnpc&gt;&gt; as a roommate.
&lt;br&gt;&lt;br&gt;
&lt;&lt;include InPersonDialogueMenu&gt;&gt;</tw-passagedata>