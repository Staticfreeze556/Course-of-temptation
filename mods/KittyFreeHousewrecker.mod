setup.Relationships.is_cheating = function(name)
{
    // if the PC will be cheating with the given NPC
    if (V.pc.equals(name) || this.partner(name) == "PC") return false;
    for (const [p, pinfo] of Object.entries(V.people))
    {
        if (pinfo.relationship && !setup.Relationships.db[pinfo.relationship].allowNonPartnerDabbling && setup.Relationships.db[pinfo.relationship].type == "romantic")
            return true;
    }
    return false;
}~setup.Relationships.is_cheating = function(name)
{
    // if the PC will be cheating with the given NPC
    //if (V.pc.equals(name) || this.partner(name) == "PC") return false;
    //for (const [p, pinfo] of Object.entries(V.people))
    //{
    //    if (pinfo.relationship && !setup.Relationships.db[pinfo.relationship].allowNonPartnerDabbling && setup.Relationships.db[pinfo.relationship].type == "romantic")
    //        return true;
    //}
    return false;
}