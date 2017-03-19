default
{
    state_entry()
    {
        llListen( -100,"",NULL_KEY,"" );

    }
    listen( integer chan,string name,key id,string msg )
    {
        if( msg == "WARP" )
        {
            llMessageLinked( LINK_SET,0,"WARP",NULL_KEY );
        }
        else if( msg == "IMPULSE" )
        {
            llMessageLinked( LINK_SET,0,"IMPULSE",NULL_KEY );
        }
    }
}