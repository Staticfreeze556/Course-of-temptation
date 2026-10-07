setup.Relationships.qualified = function(name, relationship, includecooldowns = true, includeexclusivity = true)
{
    const relinfo = this.db[relationship];
    name = setup.people.get_name(name);
    const pdata = setup.people.get_person(name);
    if (pdata.type == "faculty" && !relinfo.faculty) return false;
    let lastrelevent = pdata.lastRelEvent;
    const currel = this.relationship_with(name);

    /*
    console.log(this.matches_qualifications_all(name, relinfo.qualifying));
    console.log(!this.matches_qualifications_any(name, relinfo.disqualifying));
    console.log((relinfo.allowSpecial || setup.people.allow_free_interaction(name)));
    console.log((!relinfo.prereqRelationship || currel == relinfo.prereqRelationship));
    console.log((!relinfo.Ds || !pdata.noDs));
    console.log((!currel || this.db[currel].prereqRelationship != relationship));
    console.log((relinfo.type != "romantic" || !pdata.breakupDay || V.gameday - pdata.breakupDay >= 28));
    console.log(!this.in_exclusive_relationship_not_with(name, "PC", relinfo.type));
    console.log(!includeexclusivity || !relinfo.exclusive || !this.in_relationship_not_with(name, "PC", relinfo.type));
    console.log((!relinfo.setPartner || !this.partner(name) || this.partner(name) == "PC"));
    console.log((relinfo.desiredRelationships && relinfo.desiredRelationships.includes(setup.people.desired_relationship(name, false))));
    */

    return (!includecooldowns || !lastrelevent || V.gameday - lastrelevent > this.eventCooldown || relinfo.unilateralEntry) && // long enough since rel event?
        this.matches_qualifications_all(name, relinfo.qualifying) && // matches all qualifying conditions
        !this.matches_qualifications_any(name, relinfo.disqualifying) && // matches no disqualifying conditions
        (relinfo.allowSpecial || setup.people.allow_free_interaction(name)) && // allowed with special NPCs, or NPC isn't special, or free interaction is allowed
        (relationship != "friend" || !includecooldowns || this.add_friends_today()) && // are we adding friends today?
        (!relinfo.prereqRelationship || currel == relinfo.prereqRelationship) && // fulfill prereq?
        (!relinfo.Ds || !pdata.noDs) && // are we pursuing D/s with this person?
        (!relinfo.antiprereqRelationships || !relinfo.antiprereqRelationships.includes(currel)) && // not any antiprereqs?
        (!currel || this.db[currel].prereqRelationship != relationship) && // is this not a prereq of current relationship? (avoid tiering down)
        (relinfo.type != "romantic" || !pdata.breakupDay || V.gameday - pdata.breakupDay >= 28) && // not recently broken up?
        !this.in_exclusive_relationship_not_with(name, "PC", relinfo.type) && // not already in exclusive relationship of this type
        (!includeexclusivity || !relinfo.exclusive || !this.in_relationship_not_with(name, "PC", relinfo.type)) && // won't start out violating exclusivity
        (!relinfo.setPartner || !this.partner(name) || this.partner(name) == "PC") && // don't overwrite partner
        (relinfo.desiredRelationships && relinfo.desiredRelationships.includes(setup.people.desired_relationship(name, false))); // matches required desrel
}~setup.Relationships.qualified = function(name, relationship, includecooldowns = true, includeexclusivity = true)
{
    const relinfo = this.db[relationship];
    name = setup.people.get_name(name);
    const pdata = setup.people.get_person(name);
    //if (pdata.type == "faculty" && !relinfo.faculty) return false;
    let lastrelevent = pdata.lastRelEvent;
    const currel = this.relationship_with(name);

    /*
    console.log(this.matches_qualifications_all(name, relinfo.qualifying));
    console.log(!this.matches_qualifications_any(name, relinfo.disqualifying));
    console.log((relinfo.allowSpecial || setup.people.allow_free_interaction(name)));
    console.log((!relinfo.prereqRelationship || currel == relinfo.prereqRelationship));
    console.log((!relinfo.Ds || !pdata.noDs));
    console.log((!currel || this.db[currel].prereqRelationship != relationship));
    console.log((relinfo.type != "romantic" || !pdata.breakupDay || V.gameday - pdata.breakupDay >= 28));
    console.log(!this.in_exclusive_relationship_not_with(name, "PC", relinfo.type));
    console.log(!includeexclusivity || !relinfo.exclusive || !this.in_relationship_not_with(name, "PC", relinfo.type));
    console.log((!relinfo.setPartner || !this.partner(name) || this.partner(name) == "PC"));
    console.log((relinfo.desiredRelationships && relinfo.desiredRelationships.includes(setup.people.desired_relationship(name, false))));
    */

    return true // long enough since rel event?
        this.matches_qualifications_all(name, relinfo.qualifying) && // matches all qualifying conditions
        !this.matches_qualifications_any(name, relinfo.disqualifying) && // matches no disqualifying conditions
        (relinfo.allowSpecial || setup.people.allow_free_interaction(name)) && // allowed with special NPCs, or NPC isn't special, or free interaction is allowed
        (relationship != "friend" || !includecooldowns || this.add_friends_today()) && // are we adding friends today?
        (!relinfo.prereqRelationship || currel == relinfo.prereqRelationship) && // fulfill prereq?
        (!relinfo.Ds || !pdata.noDs) && // are we pursuing D/s with this person?
        (!relinfo.antiprereqRelationships || !relinfo.antiprereqRelationships.includes(currel)) && // not any antiprereqs?
        (!currel || this.db[currel].prereqRelationship != relationship) && // is this not a prereq of current relationship? (avoid tiering down)
        (relinfo.type != "romantic" || !pdata.breakupDay || V.gameday - pdata.breakupDay >= 28) && // not recently broken up?
        !this.in_exclusive_relationship_not_with(name, "PC", relinfo.type) && // not already in exclusive relationship of this type
        (!includeexclusivity || !relinfo.exclusive || !this.in_relationship_not_with(name, "PC", relinfo.type)) && // won't start out violating exclusivity
        (!relinfo.setPartner || !this.partner(name) || this.partner(name) == "PC") && // don't overwrite partner
        (relinfo.desiredRelationships && relinfo.desiredRelationships.includes(setup.people.desired_relationship(name, false))); // matches required desrel
}