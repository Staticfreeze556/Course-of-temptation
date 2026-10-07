&lt;&lt;if !$pc.fully_dressed() and !$pc.inoffensive_topless() and !setup.free_exhibitionism_allowed()&gt;&gt;
    You can&#39;t go outside without being fully dressed. &lt;&lt;= $pc.not_fully_dressed_reason()&gt;&gt;
&lt;&lt;elseif !$pc.wearing_shoes() &amp;&amp; !setup.free_exhibitionism_allowed()&gt;&gt;
    You can&#39;t go outside without being fully dressed. You&#39;re not wearing shoes.
&lt;&lt;elseif $pc.inoffensive_topless() and $pc.wearing_shoes()&gt;&gt;~&lt;&lt;if false &gt;&gt;
    You can&#39;t go outside without being fully dressed. &lt;&lt;= $pc.not_fully_dressed_reason()&gt;&gt;
&lt;&lt;elseif false &amp;&amp; false&gt;&gt;
    You can&#39;t go outside without being fully dressed. You&#39;re not wearing shoes.
&lt;&lt;elseif $pc.inoffensive_topless() and $pc.wearing_shoes()&gt;&gt;~~&lt;&lt;if !$pc.fully_dressed() and !$pc.inoffensive_topless()&gt;&gt;
    &lt;br&gt;
    You&#39;ll have to be fully dressed before you can go back out into the gym.
    &lt;&lt;if ($clothesleftinshower and $clothesleftinshower.length gt 0) or $pendingoutfit == &quot;!Strip&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Change into last worn clothes&quot; $gymlockerroom&gt;&gt;
            &lt;&lt;run $pc.swap_all_clothing_to_closet(false)&gt;&gt;
            &lt;&lt;run $pc.wear_all_clothes($clothesleftinshower)&gt;&gt;
            &lt;&lt;unset $clothesleftinshower&gt;&gt;
        &lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;else&gt;&gt;~&lt;&lt;if false &gt;&gt;
    &lt;br&gt;
    You&#39;ll have to be fully dressed before you can go back out into the gym.
    &lt;&lt;if ($clothesleftinshower and $clothesleftinshower.length gt 0) or $pendingoutfit == &quot;!Strip&quot;&gt;&gt;
        &lt;br&gt;
        &lt;&lt;link &quot;Change into last worn clothes&quot; $gymlockerroom&gt;&gt;
            &lt;&lt;run $pc.swap_all_clothing_to_closet(false)&gt;&gt;
            &lt;&lt;run $pc.wear_all_clothes($clothesleftinshower)&gt;&gt;
            &lt;&lt;unset $clothesleftinshower&gt;&gt;
        &lt;&lt;/link&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;else&gt;&gt;