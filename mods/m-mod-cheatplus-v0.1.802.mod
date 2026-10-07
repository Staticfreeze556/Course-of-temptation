Replace:
/* Horizontal Health Bar - Start */
With:
/* m-mod css 2506 -cheatplus */
table.cheatx {
    border-collapse: collapse;
    width: 32em;
    margin-top: auto;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 5px;
}
th.cheatx, td.cheatx {
    padding: 3px;
    text-align: center;
    border-bottom: 1px solid #444;
}
.cheatxc {
    color: #444;
}
#confirmright {
    float: right;
}
/* Horizontal Health Bar - Start */



Add Passage:
<tw-passagedata pid="880000" name="Cheats+Widget" tags="widget noevents nobr" position="888,888" size="100,100">/* m-mod widget 2506 -cheatplus */
<e>
<<widget "m-mod-cheatstabs">>
    <<set _dialogs to ["Needs+", "Misc+", "Teleport+", "TimeCut+"]>>
    <<for _dialog range _dialogs>>
        <<if _dialog isnot _dialogs[0]>>׀ <</if>>
        <<set _class to setup.remove_spaces(_dialog)>>
        <<if Dialog.isOpen(_class) or (!Dialog.isOpen() and _dialog is _dialogs[0])>>
            <<highlight>>_dialog<</highlight>>
        <<else>>
            <<capture _dialog,_class>>
                <<link _dialog>>
                    <<run setup.open_dialog(_class, _dialog, _class)>>
                <</link>>
            <</capture>>
        <</if>>
    <</for>>
<</widget>>

<<widget "time_cheat">>
    <<set _hourList to []>>
    <<for _i = 0; _i lte 23; _i++>>
        <<run _hourList.push(_i lt 10 ? "0" + _i : _i)>>
    <</for>>

    <<set _minuteList to []>>
    <<for _i = 0; _i lte 59; _i++>>
        <<run _minuteList.push(_i lt 10 ? "0" + _i : _i)>>
    <</for>>

    <<listbox "$selectedHour" autoselect>>
        <<optionsfrom _hourList>>
    <</listbox>>

    <span> : </span>

    <<listbox "$selectedMinute" autoselect>>
        <<optionsfrom _minuteList>>
    <</listbox>>&nbsp;

    <<button "Confirm Time">>
        <<set $hour to parseInt($selectedHour)>>
        <<set $minute to parseInt($selectedMinute)>>
        <<set _displayHour to ($hour lt 10) ? "0" + $hour : $hour>>
        <<set _displayMinute to ($minute lt 10) ? "0" + $minute : $minute>>
        <<replace "#currentTime">>
            <<= _displayHour>>:<<= _displayMinute>>
        <</replace>>
    <</button>>
<</widget>>

<<widget "current_time">>
    <<set _displayHour to ($hour lt 10) ? "0" + $hour : $hour>>
    <<set _displayMinute to ($minute lt 10) ? "0" + $minute : $minute>>
    <span id="currentTime"><<= _displayHour>>:<<= _displayMinute>></span>
<</widget>>

<<widget "sync_time_dropdowns">>
    <<set $selectedHour to $hour>>
    <<set $selectedMinute to $minute>>

    <<if $selectedHour lt 10>>
        <<set $selectedHour to "0" + $selectedHour>>
    <</if>>
    <<if $selectedMinute lt 10>>
        <<set $selectedMinute to "0" + $selectedMinute>>
    <</if>>
<</widget>>

<<widget "date_cheat">>
    <<set _months to [...setup.Time.months]>>
    <<run _months.delete("Frostuary")>>
    <<run _months.unshift("Frostuary")>>

    <<listbox "$selectedMonth" autoselect>>
        <<optionsfrom _months>>
    <</listbox>>

    <<set _days = []>>
    <<for _i = 1; _i lte 28; _i++>>
        <<run _days.push(_i)>>
    <</for>>

    <<listbox "$selectedDay" autoselect>>
        <<optionsfrom _days>>
    <</listbox>>&nbsp;

    <<button "Confirm Date">>
    
        <<set _monthNumber to setup.Time.months.indexOf($selectedMonth)>>
        <<set $month to _monthNumber>>
        <<set $day to $selectedDay>>

        <<set _monthIndex to $month>>
        <<set _totalDays to (_monthIndex * setup.Time.month_length) + ($day - 1)>>
        <<set $selectedWeekday to setup.Time.day_of_week[_totalDays % 7]>>

        <<replace "#selected-date-output">>
            <<= $selectedWeekday>>, <<= $selectedMonth>> <<= $day>>
        <</replace>>
    <</button>>
<</widget>>

<<widget "current_date">>
    <span id="selected-date-output"><<= $selectedWeekday>>, <<= $selectedMonth>> <<= $day>></span>
<</widget>>

<<widget "qol1">>
    <<set _dialogs to ["Internet+", "Lounge+", "Arcade+", "Others+"]>>
    <<for _dialog range _dialogs>>
        <<if _dialog isnot _dialogs[0]>>׀ <</if>>
        <<set _class to setup.remove_spaces(_dialog)>>
        <<if Dialog.isOpen(_class) or (!Dialog.isOpen() and _dialog is _dialogs[0])>>
            <<highlight>>_dialog<</highlight>>
        <<else>>
            <<capture _dialog,_class>>
                <<link _dialog>>
                    <<run setup.open_dialog(_class, _dialog, _class)>>
                <</link>>
            <</capture>>
        <</if>>
    <</for>>
<</widget>>
</e>
</tw-passagedata>

<tw-passagedata pid="880001" name="Needs+" tags="noevents dialog nobr" position="880,880" size="100,100">/* m-mod pid 2506 -cheatplus */
<e>
<<m-mod-cheatstabs>>
<br>
<span id="statsneeds"><<include "m-mod-needs">></span>
<br><br>
</e>
</tw-passagedata>

<tw-passagedata pid="880002" name="m-mod-needs" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<br>
<table class="cheatx">
    <tr class="cheatx">
        <th class="cheatx" style="width: 15em; text-align: left"><<link "Restore all needs">>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
        <</link>></th>
        <th class="cheatx"></th>
        <th class="cheatx" style="text-align: right"></th>
        <th class="cheatx"></th>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Rest</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Rest -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Rest -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Rest -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Rest"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Rest 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Rest 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Rest 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Attention</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Attention -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Attention -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Attention -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Attention"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Attention 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Attention 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Attention 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Food</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Food -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Food -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Food -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Food"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Food 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Food 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Food 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Composure</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Composure -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Composure -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Composure -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Composure"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Composure 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Composure 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Composure 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Relaxation</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Relaxation -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Relaxation -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Relaxation -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Relaxation"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Relaxation 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Relaxation 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Relaxation 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Bladder</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Bladder -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Bladder -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Bladder -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Bladder"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Bladder 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Bladder 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Bladder 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Hygiene</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Hygiene -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Hygiene -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Hygiene -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Hygiene"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Hygiene 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Hygiene 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Hygiene 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Release</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Release -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Release -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Release -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Release"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Release 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Release 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Release 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
</table>

<span id="confirmright">
<<button "Confirm">>
    <<script>>
        Engine.show();
    <</script>>
<</button>>
</span>
<br>
<table class="cheatx">
    <tr class="cheatx">
        <th class="cheatx" style="width: 15em; text-align: left"><<link "Reset all fleeting needs">>
            <<alterneed Arousal -1000>>
            <<alterneed Satisfaction -1000>>
            <<alterneed Pain -1000>>
            <<alterneed Humiliation -1000>>
            <<alterneed Drunkenness -1000>>
            <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
        <</link>></th>
        <th class="cheatx"></th>
        <th class="cheatx" style="text-align: right"></th>
        <th class="cheatx"></th>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Intoxication</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Drunkenness -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Drunkenness -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Drunkenness -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Drunkenness"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Drunkenness 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Drunkenness 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Drunkenness 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Arousal</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Arousal -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Arousal -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Arousal -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Arousal"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Arousal 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Arousal 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Arousal 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Satisfaction</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Satisfaction -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Satisfaction -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Satisfaction -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Satisfaction"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Satisfaction 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Satisfaction 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Satisfaction 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Pain</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Pain -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Pain -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Pain -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Pain"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Pain 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Pain 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Pain 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
    <tr>
        <td class="cheatx" style="text-align: left">Humiliation</td>
        <td class="cheatx">
            <<link "׀<">>
                <<alterneed Humiliation -1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;<<&nbsp;">>
                <<alterneed Humiliation -100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "<">>
                <<alterneed Humiliation -10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
        <td class="cheatx" style="text-align: right"><<= Math.floor(Math.abs($pcneeds["Humiliation"]) / 10)>>%</td>
        <td class="cheatx" style="text-align: right">
            <<link ">">>
                <<alterneed Humiliation 10>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link "&nbsp;>>&nbsp;">>
                <<alterneed Humiliation 100>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
            <<link ">׀">>
                <<alterneed Humiliation 1000>>
                <<replace "#statsneeds">><<include "m-mod-needs">><</replace>>
            <</link>>
        </td>
    </tr>
</table>

<span id="confirmright">
<<button "Confirm">>
    <<script>>
        Engine.show();
    <</script>>
<</button>>
</span>
</e>
</tw-passagedata>

<tw-passagedata pid="880003" name="Misc+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<m-mod-cheatstabs>>
<br>
<span id="statsneeds"><<include "m-mod-time">></span>
<br><br>
</e>
</tw-passagedata>

<tw-passagedata pid="880004" name="m-mod-time" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<div style="width: 32em; text-align: center">
    <br>

    <img src="res/img/ico_money.png" class="icon"> $<<nobr;>><</nobr>>$pcmoney <br>
    Day $gameday <img src="res/img/ico_clock.png" class="icon"> <<current_time>> <br>
    <img src="res/img/ico_calendar.png" class="icon">
    <<if ndef $selectedWeekday>><<set $selectedWeekday to setup.Time.weekday()>><</if>>
    <<if ndef $selectedMonth>><<set $selectedMonth to setup.Time.month()>><</if>>
    <<current_date>> <br>

    <br>
    <div class="uibar"></div>
    <br>

    Add Money<br>
    
    <<link "׀<">>
        <<money 1000>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    &nbsp;
    <<link "<<">>
        <<money 100>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    &nbsp;
    <<link "<">>
        <<money 10>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    &nbsp;
    $<<nobr;>><</nobr>>$pcmoney
    &nbsp;
    <<link ">">>
        <<spend 10>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    &nbsp;
    <<link ">>">>
        <<spend 100>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    &nbsp;
    <<link ">׀">>
        <<spend 1000>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    <br>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>

    <br><br>
    <div class="uibar"></div>
    <br>

    Advance Time<br>
    
    <<link "1 minute">>
        <<run setup.Time.advance_time(1)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    
    |
    
    <<link "10 minutes">>
        <<run setup.Time.advance_time(10)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    
    |
    
    <<link "1 hour">>
        <<run setup.Time.advance_time(60)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    
    |
    
    <<link "10 hours">>
        <<run setup.Time.advance_time(60*10)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    
    <br><br>
    
    Advance Day<br>
    
    <<link "1 day">>
        <<run setup.Time.advance_time(60*24)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    
    |
    
    <<link "1 week">>
        <<run setup.Time.advance_time(60*24*7)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>>
    
    |
    <<link "1 month">>
        <<run setup.Time.advance_time(60*24*28)>>
        <<run setup.Needs.magic_restore()>>
        <<replace "#statsneeds">><<include "m-mod-time">><</replace>>
    <</link>><br>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>

    <br><br>
    <div class="uibar"></div>
    <br>

    Set Time <br>

    <<sync_time_dropdowns>>
    <<time_cheat>>
        
    <br><br>
    
    Set Date <br>
    
    <<date_cheat>>

    <br><br>
    <div style="text-align: left; font-size: 80%;">
        <b>Note:</b> Be careful when using "Set Date". Time travel is dangerous business. Don't panic, and don't forget your towel.
    </div>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>

</div>
</e>
</tw-passagedata>

<tw-passagedata pid="880005" name="Teleport+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<m-mod-cheatstabs>>
<div style="width: 32em;">
<br>
Residence:<br>
🛏️ [[Hanna Road North|HannaRdN]] (Your Dorm)<br>
🏨 [[Hanna Road South|HannaRdS]] (Residence Halls)
<br><br>
Academic buildings:<br>
📚 [[Thoreau Road|ThoreauRd]] (Gen Ed)<br>
🎨 [[Emerson Road|EmersonRd]] (Art)<br>
🔬 [[Hallowell Road|HallowellRd]] (Science/Compsci)
<br><br>
Campus recreation & services:<br>
🌳 [[University Mall|UniMall]]<br>
🍕 [[Summit Market|SummitMarket]]<br>
🏋️ [[Blodgett Gymnasium|BlodgettGym]]<br>
🏫 [[Smith Library|Library]]<br>
🏤 [[Chamberlain Hall|ChamberlainHall]]
<br><br>
To town:<br>
🚌 [[Student Parking|StudentParking]] (To Town)
<br><br>
Other:<br>
🏛️ [[Longfellow Road|LongfellowRd]] (Clinic)<br>
🔱 [[Prescott Road|PrescottRd]] (Greek Houses)<br>
🏠 [[Bancroft Lane|BancroftLn]] (Suites)
<br><br>
Riverside:<br>
🛒 [[Riverside Plaza|RiversidePlaza]]<br>
🍔 [[Nutmeg Street|NutmegSt]] (QuickieBurger)<br>
🍻 [[Yohimbe Street|YohimbeSt]] (The River Rat)<br>
🏭 [[Fadogia Street|FadogiaSt]] (industrial park)<br>
💼 [[Ginseng Street|GinsengSt]] (business park)<br>
🏡 [[Saffron Street|SaffronSt]] (residences)<br>
🏢 [[Date Palm Street|DatePalmSt]] (apartments)<br>
🙌 [[Riverside Community Center|CommunityCenter]] (thrift shop)<br>
</div>
</e>
</tw-passagedata>



Replace:
    /* MENU */
    &lt;div class=&quot;storymenu-button-container&quot;&gt;
        &lt;&lt;if _finishedchargen&gt;&gt;
            &lt;div class=&quot;storymenu-button-block&quot;&gt;
With:
     /* MENU */
    &lt;div class=&quot;storymenu-button-container&quot;&gt;
        &lt;&lt;if _finishedchargen&gt;&gt;
<e>
            <<if $cheatsenabled>>
                <div class="storymenu-button-block">
                    <div class="two-column-container">
                        <div class="two-column">
                            <<button "Reroll RNG">>
                                <<script>>
                                    State.restore(true);
                                    if (State.prng.isEnabled()) {
                                        State.random();
                                        const frame = State.history[State.activeIndex];
                                        frame.pull = State.prng.pull;
                                    }
                                    Engine.show();
                                <</script>>
                            <</button>>
                        </div>
                        <div class="two-column">
                            <<button "Cheats+">>
                                <<script>>
                                    Dialog.setup("Needs+", "cheatstabs");
                                    Dialog.wiki(Story.get("Needs+").processText());
                                    Dialog.open();
                                <</script>>
                            <</button>>
                        </div>
                    </div>
                </div>
            <</if>>
            <div class="storymenu-button-block">
</e>



Replace:
&lt;&lt;set _link to {text: &quot;Watch TV&quot;, emoji: &#39;📺&#39;}&gt;&gt;
&lt;&lt;link _link&gt;&gt;
    &lt;&lt;advtime 60 Relaxation&gt;&gt;
    &lt;&lt;run setup.Needs.enjoy(110)&gt;&gt;
    &lt;&lt;set _event to setup.Events.passage([&quot;lounge tv&quot;])&gt;&gt;
    &lt;&lt;egoto _event&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 110&gt;&gt;
With:
<e>
<<if ndef $qolwatchtv>><<set $qolwatchtv to 60>><</if>>
<<set _link to {text: "Watch TV", emoji: '📺'}>>
<<link _link>>
    <<advtime $qolwatchtv Relaxation>>
    <<run setup.Needs.enjoy(110)>>
    <<set _event to setup.Events.passage(["lounge tv"])>>
    <<egoto _event>>
<</link>> <<dtime $qolwatchtv>> <<dalterneed Relaxation 110>>
</e>



Replace:
&lt;&lt;if $pc.skillleveled(&quot;Exhibitionism&quot;, 6) and $pc.skillleveled(&quot;Disinhibition&quot;, 4) and $lastloungeporn isnot $gameday&gt;&gt;
    &lt;br&gt;
    &lt;&lt;set _link to {text: &quot;Watch porn&quot;, link: &quot;EventLoungePorn&quot;, emoji: &#39;💦&#39;}&gt;&gt;
    &lt;&lt;link _link&gt;&gt;
            &lt;&lt;raiseskill Disinhibition 4&gt;&gt;
        &lt;&lt;raiseskill Exhibitionism 6&gt;&gt;
        &lt;&lt;raiseskill &quot;Sexual Knowledge&quot; 3&gt;&gt;
        &lt;&lt;advtime 60 Relaxation Arousal&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;skill Disinhibition 4&gt;&gt; &lt;&lt;skill Exhibitionism 6&gt;&gt; &lt;&lt;dalterneed Relaxation 120&gt;&gt; &lt;&lt;dalterneed Arousal 200&gt;&gt;
&lt;&lt;/if&gt;&gt;
With:
<e>
<<if ndef $qolwatchporn>><<set $qolwatchporn to 60>><</if>>
<<if $pc.skillleveled("Exhibitionism", 6) and $pc.skillleveled("Disinhibition", 4) and $lastloungeporn isnot $gameday>>
    <br>
    <<set _link to {text: "Watch porn", link: "EventLoungePorn", emoji: '💦'}>>
    <<link _link>>
            <<raiseskill Disinhibition 4>>
        <<raiseskill Exhibitionism 6>>
        <<raiseskill "Sexual Knowledge" 3>>
        <<advtime $qolwatchporn Relaxation Arousal>>
    <</link>> <<dtime $qolwatchporn>> <<skill Disinhibition 4>> <<skill Exhibitionism 6>> <<dalterneed Relaxation 120>> <<dalterneed Arousal 200>>
<</if>>
</e>



Replace:
&lt;&lt;set _link to {text: &quot;Play game alone&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
&lt;&lt;link _link&gt;&gt;
    &lt;&lt;advtime 30 Relaxation&gt;&gt;
    &lt;&lt;run setup.Needs.enjoy(50)&gt;&gt;
    &lt;&lt;raiseskill &quot;Video Gaming&quot; 2&gt;&gt;
    &lt;&lt;set _event to setup.Events.passage([&quot;video game solo&quot;])&gt;&gt;
    &lt;&lt;egoto _event&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt; &lt;&lt;dalterneed Relaxation 50&gt;&gt;
With:
<e>
<<if ndef $qolgamesolo>><<set $qolgamesolo to 30>><</if>>
<<set _link to {text: "Play game alone", emoji: '🎮'}>>
<<link _link>>
    <<advtime $qolgamesolo Relaxation>>
    <<run setup.Needs.enjoy(50)>>
    <<raiseskill "Video Gaming" 2>>
    <<set _event to setup.Events.passage(["video game solo"])>>
    <<egoto _event>>
<</link>> <<dtime $qolgamesolo>> <<dalterneed Relaxation 50>>
</e>



Replace:
&lt;&lt;if $peopleatlocation.length gt 0 and $hour lt 22&gt;&gt;
    &lt;&lt;set _link to {text: &quot;Play game with somebody&quot;, emoji: &#39;🎮&#39;}&gt;&gt;
    &lt;&lt;link _link&gt;&gt;
With:
<e>
<<if ndef $qolgamenpc>><<set $qolgamenpc to 30>><</if>>
<<if $peopleatlocation.length gt 0 and $hour lt 22>>
    <<set _link to {text: "Play game with somebody", emoji: '🎮'}>>
    <<link _link>>
</e>



Replace:
        &lt;&lt;else&gt;&gt;
            &lt;&lt;advtime 30 Relaxation Attention&gt;&gt;
            &lt;&lt;alterneed Relaxation 50&gt;&gt;
            &lt;&lt;socialize 30&gt;&gt;
            &lt;&lt;egoto _eventpassage&gt;&gt;
        &lt;&lt;/if&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
With:
<e>
        <<else>>
            <<advtime $qolgamenpc Relaxation Attention>>
            <<alterneed Relaxation 50>>
            <<socialize 30>>
            <<egoto _eventpassage>>
        <</if>>
    <</link>> <<dtime $qolgamenpc>>
</e>



Replace:
            &lt;&lt;advtime 30 Relaxation&gt;&gt;
            &lt;&lt;script&gt;&gt;
                const info = setup.ClickbaitTV.videotypes[T.type];
                if (info.watch.learn)
                    for (const [skill, lvl] of Object.entries(info.watch.learn))
                        V.pc.raise_skill(skill, lvl);
                if (info.watch.needs)
                    for (const [need, amt] of Object.entries(info.watch.needs))
                        setup.Needs.increase_need(need, amt);
            &lt;&lt;/script&gt;&gt;
            &lt;&lt;set $header to &quot;You spend a half an hour watching &quot; + setup.a_or_an(_type) + &quot; &quot; + _type + &quot;.&quot;&gt;&gt;
With:
<e>
            <<if ndef $qolictv>><<set $qolictv to 30>><</if>>
            <<advtime $qolictv Relaxation>>
            <<script>>
                const info = setup.ClickbaitTV.videotypes[T.type];
                if (info.watch.learn)
                    for (const [skill, lvl] of Object.entries(info.watch.learn))
                        V.pc.raise_skill(skill, lvl);
                if (info.watch.needs)
                    for (const [need, amt] of Object.entries(info.watch.needs))
                        setup.Needs.increase_need(need, amt);
            <</script>>
            <<set $header to "You spend some time watching " + setup.a_or_an(_type) + " " + _type + ".">>
</e>



Replace:
&lt;&lt;link &quot;Watch a stream&quot; EventWatchSpecialStream&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt; &lt;&lt;dalterneed Relaxation 110&gt;&gt;
With:
<e>
<<if ndef $qolintv>><<set $qolintv to 60>><</if>>
<<link "Watch a stream" EventWatchSpecialStream>>
<</link>> <<dtime $qolintv>> <<dalterneed Relaxation 110>>
</e>



Replace:
&lt;&lt;advtime 60 Relaxation&gt;&gt;
    &lt;&lt;alterneed Relaxation 110&gt;&gt;
    You spend an hour clicking around to different streams that seem fun and watching for a while. &lt;&lt;dalterneed Relaxation 110&gt;&gt;
With:
<e>
<<advtime $qolintv Relaxation>>
    <<alterneed Relaxation 110>>
    You spend some time clicking around to different streams that seem fun and watching for a while. <<dalterneed Relaxation 110>>
</e>



Replace:
&lt;&lt;set _porntime to 60&gt;&gt;
With:
<e>
<<if ndef $qoliapt1>><<set $qoliapt1 to 60>><</if>>
<<set _porntime to $qoliapt1>>
</e>



Replace:
&lt;&lt;set _paidporntime to 30&gt;&gt;
With:
<e>
<<if ndef $qoliapt2>><<set $qoliapt2 to 30>><</if>>
<<set _paidporntime to $qoliapt2>>
</e>



Replace:
&lt;&lt;link &quot;Watch a stream&quot; EventWatchPornStream&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;
With:
<e>
<<if ndef $qolicc>><<set $qolicc to 60>><</if>>
<<link "Watch a stream" EventWatchPornStream>>
<</link>> <<dtime $qolicc>>
</e>



Replace:
&lt;&lt;advtime 60 Relaxation Arousal&gt;&gt;
&lt;&lt;alterneed Relaxation 120&gt;&gt;
You spend an hour clicking around to different streams that seem fun and watching for a while. There are a lot of people doing a lot of dirty things out there.
With:
<e>
<<advtime $qolicc Relaxation Arousal>>
<<alterneed Relaxation 120>>
</e>
You spend an hour clicking around to different streams that seem fun and watching for a while. There are a lot of people doing a lot of dirty things out there.



Replace:
You&#39;re inside Master Blaster Arcade.
With:
<e>
<<if ndef $qolact>><<set $qolact to 45>><</if>>
<<if ndef $qolaakp>><<set $qolaakp to 45>><</if>>
<<if ndef $qoladdi>><<set $qoladdi to 45>><</if>>
<<if ndef $qolasb>><<set $qolasb to 60>><</if>>
You're inside Master Blaster Arcade.
</e>

Replace:
    &lt;&lt;set _link to {text: &quot;Play Clocktower&quot;, emoji: &#39;🕹️&#39;}&gt;&gt;
    &lt;&lt;link _link&gt;&gt;
        &lt;&lt;advtime 45 Relaxation&gt;&gt;
        &lt;&lt;alterneed Relaxation 75&gt;&gt;
        &lt;&lt;set $arcadegame to &quot;Clocktower&quot;&gt;&gt;
        &lt;&lt;set _passage to setup.Events.passage([&quot;arcade&quot;, &quot;solo&quot;, $arcadegame])&gt;&gt;
        &lt;&lt;spend 2&gt;&gt;
        &lt;&lt;egoto _passage&gt;&gt;
    &lt;&lt;/link&gt;&gt; ($2) &lt;&lt;dtime 45&gt;&gt;
With:
<e>
    <<set _link to {text: "Play Clocktower", emoji: '🕹️'}>>
    <<link _link>>
        <<advtime $qolact Relaxation>>
        <<alterneed Relaxation 75>>
        <<set $arcadegame to "Clocktower">>
        <<set _passage to setup.Events.passage(["arcade", "solo", $arcadegame])>>
        <<spend 2>>
        <<egoto _passage>>
    <</link>> ($2) <<dtime $qolact>>
</e>



Replace:
    &lt;&lt;set _link to {text: &quot;Play Anti-Kaiju Patrol&quot;, emoji: &#39;🕹️&#39;}&gt;&gt;
    &lt;&lt;link _link&gt;&gt;
        &lt;&lt;advtime 45 Relaxation&gt;&gt;
        &lt;&lt;alterneed Relaxation 75&gt;&gt;
        &lt;&lt;set $arcadegame to &quot;Anti-Kaiju Patrol&quot;&gt;&gt;
        &lt;&lt;set _passage to setup.Events.passage([&quot;arcade&quot;, &quot;solo&quot;, $arcadegame])&gt;&gt;
        &lt;&lt;spend 2&gt;&gt;
        &lt;&lt;egoto _passage&gt;&gt;
    &lt;&lt;/link&gt;&gt; ($2) &lt;&lt;dtime 45&gt;&gt;
With:
<e>
    <<set _link to {text: "Play Anti-Kaiju Patrol", emoji: '🕹️'}>>
    <<link _link>>
        <<advtime $qolaakp Relaxation>>
        <<alterneed Relaxation 75>>
        <<set $arcadegame to "Anti-Kaiju Patrol">>
        <<set _passage to setup.Events.passage(["arcade", "solo", $arcadegame])>>
        <<spend 2>>
        <<egoto _passage>>
    <</link>> ($2) <<dtime $qolaakp>>
</e>



Replace:
        &lt;&lt;set _link to {text: &quot;Play Disco Disco Insurrection&quot;, emoji: &#39;🪩&#39;}&gt;&gt;
        &lt;&lt;link _link&gt;&gt;
            &lt;&lt;advtime 45 Relaxation&gt;&gt;
            &lt;&lt;alterneed Relaxation 85&gt;&gt;
            &lt;&lt;alterneed Rest -10&gt;&gt;
            &lt;&lt;set $arcadegame to &quot;Disco Disco Insurrection&quot;&gt;&gt;
            &lt;&lt;set _passage to setup.Events.passage([&quot;arcade&quot;, &quot;solo&quot;, $arcadegame])&gt;&gt;
            &lt;&lt;spend 4&gt;&gt;
            &lt;&lt;egoto _passage&gt;&gt;
        &lt;&lt;/link&gt;&gt; ($4) &lt;&lt;dtime 45&gt;&gt;
With:
<e>
        <<set _link to {text: "Play Disco Disco Insurrection", emoji: '🪩'}>>
        <<link _link>>
            <<advtime $qoladdi Relaxation>>
            <<alterneed Relaxation 85>>
            <<alterneed Rest -10>>
            <<set $arcadegame to "Disco Disco Insurrection">>
            <<set _passage to setup.Events.passage(["arcade", "solo", $arcadegame])>>
            <<spend 4>>
            <<egoto _passage>>
        <</link>> ($4) <<dtime $qoladdi>>
</e>



Replace:
    &lt;&lt;set _linkdest to &quot;Arcade&quot; + setup.remove_spaces(_game)&gt;&gt;
    &lt;&lt;link &quot;Agree&quot; _linkdest&gt;&gt;
        &lt;&lt;advtime 60&gt;&gt;
With:
<e>
    <<set _linkdest to "Arcade" + setup.remove_spaces(_game)>>
    <<link "Agree" _linkdest>>
        <<advtime $qolasb>>
</e>



Replace:
        &lt;&lt;set $arcade.text to &quot;Start&quot;&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;&lt;br&gt;
With:
<e>
        <<set $arcade.text to "Start">>
    <</link>> <<dtime $qolasb>><br>
</e>


Replace:
&lt;&lt;set _bookshelf to setup.dorm_category_item(&quot;books&quot;)&gt;&gt;
With:
<e>
<<if ndef $qolmread>><<set $qolmread to 30>><</if>>
<<set _bookshelf to setup.dorm_category_item("books")>>
</e>



Replace:
    &lt;&lt;link &quot;Read one of your books&quot; LibraryRead&gt;&gt;
    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
With:
<e>
    <<link "Read one of your books" LibraryRead>>
    <</link>> <<dtime $qolmread>>
</e>



Replace:
    &lt;&lt;link &quot;Read something&quot; DormRead&gt;&gt;

    &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
With:
<e>
    <<link "Read something" DormRead>>

    <</link>> <<dtime $qolmread>>
</e>



Replace:
&lt;&lt;widget &quot;booklink&quot;&gt;&gt;
    &lt;&lt;set _book to _args[0]&gt;&gt;
With:
<e>
<<widget "booklink">>
	<<if ndef $qolmread>><<set $qolmread to 30>><</if>>
    <<set _book to _args[0]>>
</e>



Replace:
                &lt;&lt;advtime 30&gt;&gt;
            &lt;&lt;/link&gt;&gt;
        &lt;&lt;/capture&gt;&gt;

        &lt;&lt;dtime 30&gt;&gt;
With:
<e>
                <<advtime $qolmread>>
            <</link>>
        <</capture>>

        <<dtime $qolmread>>
</e>



Replace:
        &lt;&lt;advtime 30 Relaxation&gt;&gt;
        &lt;&lt;alterneed Relaxation 50&gt;&gt;
        &lt;&lt;alterneed Rest -20&gt;&gt;
        &lt;&lt;alterneed Hygiene -40&gt;&gt;
        &lt;&lt;raiseskill Physical 2&gt;&gt;
        &lt;&lt;gymcardio 3&gt;&gt;
        &lt;&lt;set _tags to [&quot;park run&quot;]&gt;&gt;
        &lt;&lt;if $exhibitionsneak&gt;&gt;&lt;&lt;run _tags.push(&quot;exhibitionism sneak&quot;)&gt;&gt;&lt;&lt;/if&gt;&gt;
        &lt;&lt;set _eventpassage to setup.Events.passage(_tags)&gt;&gt;
        &lt;&lt;egoto _eventpassage&gt;&gt;
    &lt;&lt;/if&gt;&gt;
&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
With:
<e>
        <<if ndef $qolmjog>><<set $qolmjog to 30>><</if>>
        <<advtime $qolmjog Relaxation>>
        <<alterneed Relaxation 50>>
        <<alterneed Rest -20>>
        <<alterneed Hygiene -40>>
        <<raiseskill Physical 2>>
        <<gymcardio 3>>
        <<set _tags to ["park run"]>>
        <<if $exhibitionsneak>><<run _tags.push("exhibitionism sneak")>><</if>>
        <<set _eventpassage to setup.Events.passage(_tags)>>
        <<egoto _eventpassage>>
    <</if>>
<</link>> <<dtime $qolmjog>>
</e>



Replace:
    &lt;&lt;link &quot;Socialize&quot; ParkSocialMenu&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;
With:
<e>
    <<if ndef $qolmsocial>><<set $qolmsocial to 60>><</if>>
    <<link "Socialize" ParkSocialMenu>><</link>> <<dtime $qolmsocial>>
</e>



Replace:
                &lt;&lt;advtime 60 Attention Relaxation&gt;&gt;
                &lt;&lt;playerinitsocializing&gt;&gt;
            &lt;&lt;/link&gt;&gt; &lt;&lt;dtime 60&gt;&gt;
With:
<e>
                <<advtime $qolmsocial Attention Relaxation>>
                <<playerinitsocializing>>
            <</link>> <<dtime $qolmsocial>>
</e>



Replace:
    &lt;&lt;link &quot;Browse the art&quot; EmersonGallery&gt;&gt;&lt;&lt;set $header to &quot;You spend some time looking over the student and alumni art. You do your best to clear your head and really contemplate it. &lt;&lt;dalterneed Relaxation 50 true&gt;&gt;&quot;&gt;&gt;&lt;&lt;raiseskill Artistic 1&gt;&gt;&lt;&lt;advtime 30 Relaxation&gt;&gt;&lt;&lt;/link&gt;&gt; &lt;&lt;dtime 30&gt;&gt;
With:
<e>
    <<if ndef $qolmart>><<set $qolmart to 30>><</if>>
    <<link "Browse the art" EmersonGallery>><<set $header to "You spend some time looking over the student and alumni art. You do your best to clear your head and really contemplate it. <<dalterneed Relaxation 50 true>>">><<raiseskill Artistic 1>><<advtime $qolmart Relaxation>><</link>> <<dtime $qolmart>>
</e>


Add Passage:
<tw-passagedata pid="880006" name="TimeCut+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<include "Internet+">>
</e>
</tw-passagedata>

<tw-passagedata pid="880007" name="Internet+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<m-mod-cheatstabs>>
<br>
 + <<qol1>>
<div style="width: 32em;">
    <br>
    <<if ndef $qolictv>><<set $qolictv to 30>><</if>>
    <<if ndef $qolintv>><<set $qolintv to 60>><</if>>
    <<if ndef $qoliapt1>><<set $qoliapt1 to 60>><</if>>
    <<if ndef $qoliapt2>><<set $qoliapt2 to 30>><</if>>
    <<if ndef $qolicc>><<set $qolicc to 60>><</if>>
    <span style="font-size: 120%;">Internet</span>
    <br><br>

    <table class="options-table">
        <tr>
            <td class="options-col-label" style="width: 50%;">
                ClickbaitTV<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="ictvlabel" for="slider-ictv-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolictv>>
                </label>
                <input type="range" id="slider-ictv-duration" name="slider-ictv-duration" min="10" max="30" @value="$qolictv" class="slider" data-var="$qolictv" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Niche.tv<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="intvlabel" for="slider-intv-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolintv>>
                </label>
                <input type="range" id="slider-intv-duration" name="slider-intv-duration" min="10" max="60" @value="$qolintv" class="slider" data-var="$qolintv" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                AmateurPornTown Free<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="iapt1label" for="slider-iapt1-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qoliapt1>>
                </label>
                <input type="range" id="slider-iapt1-duration" name="slider-iapt1-duration" min="10" max="60" @value="$qoliapt1" class="slider" data-var="$qoliapt1" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                AmateurPornTown Paid<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="iapt2label" for="slider-iapt2-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qoliapt2>>
                </label>
                <input type="range" id="slider-iapt2-duration" name="slider-iapt2-duration" min="10" max="30" @value="$qoliapt2" class="slider" data-var="$qoliapt2" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                CollegeCams<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="icclabel" for="slider-icc-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolicc>>
                </label>
                <input type="range" id="slider-icc-duration" name="slider-icc-duration" min="10" max="60" @value="$qolicc" class="slider" data-var="$qolicc" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
    </table>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>

    <br><br>
    <<script>>
        $(document).on("input", "#slider-ictv-duration", function()
        {
            let lab = `${V.qolictv}`;
            $("#ictvlabel").empty().text(lab);
        });
        $(document).on("input", "#slider-intv-duration", function()
        {
            let lab = `${V.qolintv}`;
            $("#intvlabel").empty().text(lab);
        });
        $(document).on("input", "#slider-iapt1-duration", function()
        {
            let lab = `${V.qoliapt1}`;
            $("#iapt1label").empty().text(lab);
        });
        $(document).on("input", "#slider-iapt2-duration", function()
        {
            let lab = `${V.qoliapt2}`;
            $("#iapt2label").empty().text(lab);
        });
        $(document).on("input", "#slider-icc-duration", function()
        {
            let lab = `${V.qolicc}`;
            $("#icclabel").empty().text(lab);
        });
    <</script>>
</div>
</e>
</tw-passagedata>

<tw-passagedata pid="880008" name="Lounge+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<m-mod-cheatstabs>>
<br>
 + <<qol1>>
<div style="width: 32em;">
    <br>
    <<if ndef $qolwatchtv>><<set $qolwatchtv to 60>><</if>>
    <<if ndef $qolwatchporn>><<set $qolwatchporn to 60>><</if>>
    <<if ndef $qolgamesolo>><<set $qolgamesolo to 30>><</if>>
    <<if ndef $qolgamenpc>><<set $qolgamenpc to 30>><</if>>
    <span style="font-size: 120%;">Residents Lounge</span>
    <br><br>

    <table class="options-table">
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Watch TV<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="watchtvlabel" for="slider-watchtv-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolwatchtv>>
                </label>
                <input type="range" id="slider-watchtv-duration" name="slider-watchtv-duration" min="10" max="60" @value="$qolwatchtv" class="slider" data-var="$qolwatchtv" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Watch porn<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="watchpornlabel" for="slider-watchporn-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolwatchporn>>
                </label>
                <input type="range" id="slider-watchporn-duration" name="slider-watchporn-duration" min="10" max="60" @value="$qolwatchporn" class="slider" data-var="$qolwatchporn" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Play game alone<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="gamesololabel" for="slider-gamesolo-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolgamesolo>>
                </label>
                <input type="range" id="slider-gamesolo-duration" name="slider-gamesolo-duration" min="10" max="30" @value="$qolgamesolo" class="slider" data-var="$qolgamesolo" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Play game with npc<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="gamenpclabel" for="slider-gamenpc-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolgamenpc>>
                </label>
                <input type="range" id="slider-gamenpc-duration" name="slider-gamenpc-duration" min="10" max="30" @value="$qolgamenpc" class="slider" data-var="$qolgamenpc" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
    </table>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>
    
    <br><br>

    <<script>>
        $(document).on("input", "#slider-watchtv-duration", function()
        {
            let lab = `${V.qolwatchtv}`;
            $("#watchtvlabel").empty().text(lab);
        });
        $(document).on("input", "#slider-watchporn-duration", function()
        {
            let lab = `${V.qolwatchporn}`;
            $("#watchpornlabel").empty().text(lab);
        });
        $(document).on("input", "#slider-gamesolo-duration", function()
        {
            let lab = `${V.qolgamesolo}`;
            $("#gamesololabel").empty().text(lab);
        });
        $(document).on("input", "#slider-gamenpc-duration", function()
        {
            let lab = `${V.qolgamenpc}`;
            $("#gamenpclabel").empty().text(lab);
        });
    <</script>>
</div>
</e>
</tw-passagedata>

<tw-passagedata pid="880009" name="Arcade+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<m-mod-cheatstabs>>
<br>
 + <<qol1>>
<div style="width: 32em;">
    <br>
    <<if ndef $qolact>><<set $qolact to 45>><</if>>
    <<if ndef $qolaakp>><<set $qolaakp to 45>><</if>>
    <<if ndef $qoladdi>><<set $qoladdi to 45>><</if>>
    <<if ndef $qolasb>><<set $qolasb to 60>><</if>>
    <span style="font-size: 120%;">Arcade</span>
    <br><br>

    <table class="options-table">
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Clocktower<br>
                <span class="small" style="font-weight: normal;">(default is 45)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="actlabel" for="slider-act-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolact>>
                </label>
                <input type="range" id="slider-act-duration" name="slider-ac-duration" min="10" max="45" @value="$qolact" class="slider" data-var="$qolact" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Anti-Kaiju Patrol<br>
                <span class="small" style="font-weight: normal;">(default is 45)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="aakplabel" for="slider-aakp-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolaakp>>
                </label>
                <input type="range" id="slider-aakp-duration" name="slider-aakp-duration" min="10" max="45" @value="$qolaakp" class="slider" data-var="$qolaakp" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Disco Disco Insurrection<br>
                <span class="small" style="font-weight: normal;">(default is 45)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="addilabel" for="slider-addi-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qoladdi>>
                </label>
                <input type="range" id="slider-addi-duration" name="slider-addi-duration" min="10" max="45" @value="$qoladdi" class="slider" data-var="$qoladdi" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Side bet<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="asblabel" for="slider-asb-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolasb>>
                </label>
                <input type="range" id="slider-asb-duration" name="slider-asb-duration" min="10" max="60" @value="$qolasb" class="slider" data-var="$qolasb" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
    </table>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>
    
    <br><br>	

    <<script>>
        $(document).on("input", "#slider-act-duration", function()
        {
            let lab = `${V.qolact}`;
            $("#actlabel").empty().text(lab);
        });
        $(document).on("input", "#slider-aakp-duration", function()
        {
            let lab = `${V.qolaakp}`;
            $("#aakplabel").empty().text(lab);
        });
        $(document).on("input", "#slider-addi-duration", function()
        {
            let lab = `${V.qoladdi}`;
            $("#addilabel").empty().text(lab);
        });
        $(document).on("input", "#slider-asb-duration", function()
        {
            let lab = `${V.qolasb}`;
            $("#asblabel").empty().text(lab);
        });
    <</script>>
</div>
</e>
</tw-passagedata>

<tw-passagedata pid="880010" name="Others+" tags="noevents dialog nobr" position="880,880" size="100,100">
<e>
<<m-mod-cheatstabs>>
<br>
 + <<qol1>>
<div style="width: 32em;">
    <br>
    <<if ndef $qolmread>><<set $qolmread to 30>><</if>>
    <<if ndef $qolmjog>><<set $qolmjog to 30>><</if>>
    <<if ndef $qolmsocial>><<set $qolmsocial to 60>><</if>>
    <<if ndef $qolmart>><<set $qolmart to 30>><</if>>
    <span style="font-size: 120%;">Misc</span>
    <br><br>

    <table class="options-table">
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Read something<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="mreadlabel" for="slider-mread-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolmread>>
                </label>
                <input type="range" id="slider-mread-duration" name="slider-mread-duration" min="10" max="30" @value="$qolmread" class="slider" data-var="$qolmread" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Jog at mall<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="mjoglabel" for="slider-mjog-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolmjog>>
                </label>
                <input type="range" id="slider-mjog-duration" name="slider-mjog-duration" min="10" max="30" @value="$qolmjog" class="slider" data-var="$qolmjog" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Socialize at mall<br>
                <span class="small" style="font-weight: normal;">(default is 60)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="msociallabel" for="slider-msocial-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolmsocial>>
                </label>
                <input type="range" id="slider-msocial-duration" name="slider-msocial-duration" min="10" max="60" @value="$qolmsocial" class="slider" data-var="$qolmsocial" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
        <tr>
            <td class="options-col-label" style="width: 50%;">
                Browse art at Emerson<br>
                <span class="small" style="font-weight: normal;">(default is 30)</span>
            </td>
            <td class="options-col-content" style="text-align: right;">
                <label id="martlabel" for="slider-mart-duration" class="options-item-value" style="vertical-align: middle;">
                    <<= $qolmart>>
                </label>
                <input type="range" id="slider-mart-duration" name="slider-mart-duration" min="10" max="30" @value="$qolmart" class="slider" data-var="$qolmart" oninput="SugarCubeInput(this)" style="width: 80%; vertical-align: middle;">
            </td>
        </tr>
    </table>

    <span id="confirmright">
    <<button "Confirm">>
        <<script>>
            Engine.show();
        <</script>>
    <</button>>
    </span>

    <br><br>
    <<script>>
        $(document).on("input", "#slider-mread-duration", function()
        {
            let lab = `${V.qolmread}`;
            $("#mreadlabel").empty().text(lab);
        });
        $(document).on("input", "#slider-mjog-duration", function()
        {
            let lab = `${V.qolmjog}`;
            $("#mjoglabel").empty().text(lab);
        });
        $(document).on("input", "#slider-msocial-duration", function()
        {
            let lab = `${V.qolmsocial}`;
            $("#msociallabel").empty().text(lab);
        });
        $(document).on("input", "#slider-mart-duration", function()
        {
            let lab = `${V.qolmart}`;
            $("#martlabel").empty().text(lab);
        });
    <</script>>
</div>
</e>
</tw-passagedata>


r:
&lt;&lt;set $favoritepeople to []&gt;&gt;

&lt;&lt;set $plrinitsocialdays to []&gt;&gt;
w:
<e>
<<set $favoritepeople to []>>

<<set $plrinitsocialdays to []>>

<<set $opttemperatureeffects to true>>
<<set $qolwatchtv to 60>>
<<set $qolwatchporn to 60>>
<<set $qolgamesolo to 30>>
<<set $qolgamenpc to 30>>
<<set $qolictv to 30>>
<<set $qolintv to 60>>
<<set $qoliapt1 to 60>>
<<set $qoliapt2 to 30>>
<<set $qolicc to 60>>
<<set $qolact to 45>>
<<set $qolaakp to 45>>
<<set $qoladdi to 45>>
<<set $qolasb to 60>>
<<set $qolmread to 30>>
<<set $qolmjog to 30>>
<<set $qolmsocial to 60>>
<<set $qolmart to 30>>
</e>