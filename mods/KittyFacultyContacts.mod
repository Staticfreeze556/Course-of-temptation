	setup.people.valid_phone_contact = function(name)
{
    return this.is_known(name) && this.get_type(name) != "faculty" && this.get_type(name) != "outsider" && !this.is_removed(name);
}~	setup.people.valid_phone_contact = function(name)
{
    return this.is_known(name) && this.get_type(name) && this.get_type(name) != "outsider" && !this.is_removed(name);
}