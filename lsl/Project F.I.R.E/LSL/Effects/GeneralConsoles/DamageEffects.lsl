default
{
    state_entry()
    {
        llListen(-25,"",NULL_KEY,"");
    }
    listen(integer chan,string name,key id,string msg)
    {
         if( msg == "DAMAGE")
        {
            llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),llGetPos(),ZERO_VECTOR,ZERO_ROTATION,0);
        }
    }
}
