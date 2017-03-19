default
{
    state_entry()
    {
        llListen( 881213,"",NULL_KEY,"" );
    }
    listen( integer chan,string name,key id,string msg )
    {
        llSetTexture( msg,ALL_SIDES );
    }
}
