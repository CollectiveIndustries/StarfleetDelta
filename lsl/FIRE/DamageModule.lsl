default
{
    state_entry()
    {
        llListen(-25,"",NULL_KEY,"");
    }
    listen(integer chan,string name,key id,string msg)
    {
         if( msg == "SHEILD")
        {
            llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),llGetPos(),<0,0,4>,ZERO_ROTATION,0);
        }
    }
}