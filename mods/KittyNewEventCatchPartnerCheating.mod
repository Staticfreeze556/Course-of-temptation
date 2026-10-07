
    {
        passage: "EventCampusWalkSpotSex",
        tags: ["campus walk"],
        frequency: 8,
        peoplehere: 4,
        locations: ["ThoreauRd", "EmersonRd", "HallowellRd"],
    },
~
    {
        passage: "EventCampusWalkSpotSex",
        tags: ["campus walk"],
        frequency: 8,
        peoplehere: 4,
        locations: ["ThoreauRd", "EmersonRd", "HallowellRd"],
    },
    {
        passage: "EventCampusWalkSpotPartnerCheating",
        tags: ["town walk", "campus walk"],
        frequency: 1500,
        findnpc: {inclinations: "cheater", strictinclinations: true, relationship: ["partner", "soulmate", "open partner", "poly partner", "submissive", "dominant"]},
    },
~~
    &lt;&lt;case &quot;transgender male&quot;&gt;&gt;
        &lt;&lt;arrappend _msgs &quot;It&#39;s two people with their hands down each other&#39;s pants, breathing hard as they touch one another. It&#39;s hard to tell who they are in the dim lighting, but they can see each other just fine, you would guess by the amount of intense eye contact they&#39;re giving each other as they get each other off.&quot;&gt;&gt;
    &lt;&lt;case &quot;nonbinary afab&quot; &quot;nonbinary amab&quot;&gt;&gt;
        &lt;&lt;arrappend _msgs &quot;It&#39;s two people with their hands down each other&#39;s pants, breathing hard as they touch one another. It&#39;s hard to tell who they are in the dim lighting, but they can see each other just fine, you would guess by the amount of intense eye contact they&#39;re giving each other as they get each other off.&quot;&gt;&gt;
&lt;&lt;/switch&gt;&gt;
&lt;&lt;= setup.randomchoice(_msgs)&gt;&gt;
&lt;&lt;dalterneed Arousal 50 true&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;raiseskill Voyeurism 1&gt;&gt;&lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 2&gt;&gt;
&lt;&lt;continuelink&gt;&gt;</tw-passagedata>
~
    &lt;&lt;case &quot;transgender male&quot;&gt;&gt;
        &lt;&lt;arrappend _msgs &quot;It&#39;s two people with their hands down each other&#39;s pants, breathing hard as they touch one another. It&#39;s hard to tell who they are in the dim lighting, but they can see each other just fine, you would guess by the amount of intense eye contact they&#39;re giving each other as they get each other off.&quot;&gt;&gt;
    &lt;&lt;case &quot;nonbinary afab&quot; &quot;nonbinary amab&quot;&gt;&gt;
        &lt;&lt;arrappend _msgs &quot;It&#39;s two people with their hands down each other&#39;s pants, breathing hard as they touch one another. It&#39;s hard to tell who they are in the dim lighting, but they can see each other just fine, you would guess by the amount of intense eye contact they&#39;re giving each other as they get each other off.&quot;&gt;&gt;
&lt;&lt;/switch&gt;&gt;
&lt;&lt;= setup.randomchoice(_msgs)&gt;&gt;
&lt;&lt;dalterneed Arousal 50 true&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;raiseskill Voyeurism 1&gt;&gt;&lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 2&gt;&gt;
&lt;&lt;continuelink&gt;&gt;</tw-passagedata><tw-passagedata pid="444" name="EventCampusWalkSpotPartnerCheating" tags="event nobr" position="475,5600" size="100,100">As you&#39;re &lt;&lt;if setup.dorm_has(&quot;bicycle&quot;)&gt;&gt;biking&lt;&lt;else&gt;&gt;walking&lt;&lt;/if&gt;&gt; down the path, you spot movement in a narrow space between two nearby buildings.
&lt;br&gt;&lt;br&gt;
In a moment of utter disbelief, you see &lt;&lt;anonorfullname $eventnpc&gt;&gt; having sex with somebody else. How could this happen to you! Unfortunately it looks like you&#39;re going to have to have that tough conversation with them later...
&lt;&lt;dalterneed Composure -500 true&gt;&gt;
&lt;br&gt;&lt;br&gt;
&lt;&lt;raiseskill Voyeurism 1&gt;&gt;&lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 2&gt;&gt;
&lt;&lt;continuelink&gt;&gt;</tw-passagedata>