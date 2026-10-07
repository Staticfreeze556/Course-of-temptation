~~
&lt;&lt;if $sport.possession is $ourteam and State.random() lte 0.33 and $sport.playing is &quot;football&quot; and $sport.playeringame&gt;&gt;
    A few minutes later, you find yourself with the ball! Members of the other team are charging straight towards you!
    &lt;&lt;set $sport.hasball to &quot;PC&quot;&gt;&gt;
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;link &quot;Pass it!&quot; EventSportsGameFootballPlayerPass&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;br&gt;
    &lt;&lt;link &quot;Run it!&quot; EventSportsGameFootballTackle&gt;&gt;&lt;&lt;set $sport.tackledifficulty++&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
~
&lt;&lt;set $sport.possession to $ourteam&gt;&gt;
&lt;&lt;if $sport.possession is $ourteam and $sport.playing is &quot;football&quot; and $sport.playeringame&gt;&gt;
    A few minutes later, you find yourself with the ball! Members of the other team are charging straight towards you!
    &lt;&lt;set $sport.hasball to &quot;PC&quot;&gt;&gt;
    &lt;br&gt;&lt;br&gt;
    &lt;&lt;link &quot;Pass it!&quot; EventSportsGameFootballPlayerPass&gt;&gt;&lt;&lt;/link&gt;&gt;
    &lt;br&gt;
    &lt;&lt;link &quot;Run it!&quot; EventSportsGameFootballTackle&gt;&gt;&lt;&lt;set $sport.tackledifficulty++&gt;&gt;&lt;&lt;/link&gt;&gt;
&lt;&lt;else&gt;&gt;
~~
&lt;&lt;if (_win or $eventnpc.has_any_inclination(&quot;slut&quot;))&gt;&gt;
~
&lt;&lt;if (_win or $eventnpc.has_any_inclination(&quot;slut&quot;) or setup.people.willing_sex($eventnpc))&gt;&gt;
~~