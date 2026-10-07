~~
&lt;&lt;widget &quot;advtime&quot;&gt;&gt;
	&lt;&lt;if _args[0]&gt;&gt;
		&lt;&lt;if _args.length gt 1&gt;&gt;&lt;&lt;set $pausedneeds to _args.slice(1)&gt;&gt;&lt;&lt;/if&gt;&gt;
		&lt;&lt;run setup.Time.advance_time(_args[0])&gt;&gt;
		&lt;&lt;unset $pausedneeds&gt;&gt;
	&lt;&lt;/if&gt;&gt;
&lt;&lt;/widget&gt;&gt;
~
&lt;&lt;widget &quot;advtime&quot;&gt;&gt;
	&lt;&lt;if _args[0]&gt;&gt;
		&lt;&lt;if _args.length gt 1&gt;&gt;&lt;&lt;set $pausedneeds to _args.slice(1)&gt;&gt;&lt;&lt;/if&gt;&gt;
		&lt;&lt;run setup.Time.safeadvance_time(_args[0])&gt;&gt;
		&lt;&lt;unset $pausedneeds&gt;&gt;
	&lt;&lt;/if&gt;&gt;
&lt;&lt;/widget&gt;&gt;
~~
setup.Time.advance_time = function(minutes)
{
    this.advance_clock(minutes);
    this.adjust_needs(minutes);

    if (V.laundrytime)
    {
        State.setVar("$laundrytime", Math.max(0, V.laundrytime - minutes));
    }
}
~
setup.Time.advance_time = function(minutes)
{
    this.advance_clock(minutes);
    this.adjust_needs(minutes);

    if (V.laundrytime)
    {
        State.setVar("$laundrytime", Math.max(0, V.laundrytime - minutes));
    }
}

setup.Time.safeadvance_time = function(minutes) {
    try 
	{
        setup.Time.advance_time(minutes); // Attempt to advance time
		
    } catch (error) {
        console.log("An error occurred while advancing time:", error); // Log the error
        return null; // Return null or any other fallback behavior
    }
}
