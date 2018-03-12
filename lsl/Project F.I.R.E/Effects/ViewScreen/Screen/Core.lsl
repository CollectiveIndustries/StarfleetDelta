PreLoad(integer type)
{
    if(type == INVENTORY_TEXTURE)
    {
        integer total = llGetInventoryNumber(type);
        integer index;
        string names;
        for (index=0;index<total;index++)
        {
            names = llGetInventoryName(type,index);
            llSetTexture(names,ALL_SIDES);
            llRegionSay(-125,"VIEWER:"+(string)llGetInventoryKey(names) );
            llSleep(25.0);
        }
    }
    else
    {
        //other preload crap
    }
}
state default
{
    state_entry()
    {
        llListen(881213,"",NULL_KEY,"");
    }
    listen(integer chan,string name,key id,string msg)
    {
        if(msg == "PRELOAD_TEXTURES")
        {
            PreLoad(INVENTORY_TEXTURE);
        }
        else
        {
            llSetTexture(msg,ALL_SIDES);
            llRegionSay(-125,"VIEWER:"+(string)llGetInventoryKey(msg) );
        }
    }
}