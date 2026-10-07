&lt;&lt;set _possible to []&gt;&gt;
&lt;&lt;for _person range setup.Relationships.people_of_relationship(_rels)&gt;&gt;
    &lt;&lt;if _person isnot $hangout.partner and _types.includes(setup.people.get_type(_person))&gt;&gt;
        &lt;&lt;arrappend _possible _person&gt;&gt;
    &lt;&lt;/if&gt;&gt;~&lt;&lt;set _possible to []&gt;&gt;
&lt;&lt;for _person range setup.Relationships.people_of_relationship(_rels)&gt;&gt;
    &lt;&lt;if _person isnot $hangout.partner&gt;&gt;
        &lt;&lt;arrappend _possible _person&gt;&gt;
    &lt;&lt;/if&gt;&gt;