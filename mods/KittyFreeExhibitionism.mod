setup.free_exhibitionism_allowed = function()
{
	let dare = V.rmpbully;
	dare = dare && dare.dare == "EventRMPDareGoStreaking";
	return setup.Time.timeofday() == "night" && !V.exhibitionsneaktoday && (setup.pc().has_any_inclination(setup.archetypes.inclination_sets.basic_exhibitionist) || dare);
}~setup.free_exhibitionism_allowed = function()
{
	let dare = V.rmpbully;
	dare = dare && dare.dare == "EventRMPDareGoStreaking";
	return true;
}