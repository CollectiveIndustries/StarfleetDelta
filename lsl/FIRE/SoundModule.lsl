default
{
    state_entry()
    {
        llListen(-26,"",NULL_KEY,"");
    }
    listen(integer chan,string name,key id,string msg)
    {
        list temp;
        string name;
        temp = llParseString2List(msg,[":"],[]);
        name = llList2String(temp,0);
        name = llToLower(name);
        key value = (key)llList2Key(temp,1);
        if (name == "sound")
        {
            llSound(value,1.0,TRUE,FALSE);
        }
    }
}