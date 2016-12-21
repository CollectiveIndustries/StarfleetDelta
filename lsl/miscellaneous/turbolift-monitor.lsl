integer listenhandle;
integer debug = FALSE; //toggle debug chat output

default
{
    state_entry()
    {
        listenhandle = llListen( 42010, "", "", "" );
    }
    listen( integer chan, string name, key id, string msg )
    {
        if( llList2String( llParseString2List( msg, ["::"], [] ), 0 ) == "LIFT" )
        {
            llSay( 0, "Incoming lift at " + llList2String( llParseString2List( msg, ["::"], [] ), 1 ) + " - " +  llList2String( llParseString2List( msg, ["::"], [] ), 2 ) );
        }
    }
}
