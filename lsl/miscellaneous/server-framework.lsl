integer mainlight;
integer statlight;
integer powerbtn;

key owner;

integer debug = FALSE; //toggle debug chat output

default
{
    state_entry()
    {
        owner = llGetOwner();
        mainlight = 1;
        statlight = 2;
        powerbtn = 3;
        if( debug )
        {
            llSay( 0, "Initializing, please wait..." );
        }
        if( debug )
        {
            llSay( 0, "Ready." );
        }
        state offline;
    }
}

state offline
{
    state_entry()
    {
        if( debug )
        {
            llSay( 0, "Server Offline" );
        }
        llSetLinkPrimitiveParamsFast( LINK_THIS, [
                                          PRIM_COLOR, mainlight, <0.2, 0.5, 0.2>, 1.0,
                                          PRIM_COLOR, statlight, <0.1, 0.1, 0.1>, 1.0,
                                          PRIM_GLOW, statlight, 0.0,
                                          PRIM_FULLBRIGHT, statlight, 0,
                                          PRIM_COLOR, powerbtn, <0.25, 0, 0>, 1.0,
                                          PRIM_GLOW, powerbtn, 0.0,
                                          PRIM_FULLBRIGHT, powerbtn, 0
                                      ] );
    }
    touch_end( integer num_detected )
    {
        if( llDetectedKey( 0 ) == owner && llDetectedTouchFace( 0 ) == powerbtn )
        {
            state online;
        }
    }
}

state online
{
    state_entry()
    {
        if( debug )
        {
            llSay( 0, "Server Online" );
        }
        llSetLinkPrimitiveParamsFast( LINK_THIS, [
                                          PRIM_COLOR, mainlight, <0.4, 1, 0.4>, 1.0,
                                          PRIM_COLOR, statlight, <0, 1, 0>, 1.0,
                                          PRIM_GLOW, statlight, 0.05,
                                          PRIM_FULLBRIGHT, statlight, 1,
                                          PRIM_COLOR, powerbtn, <0, 1, 0>, 1.0,
                                          PRIM_GLOW, powerbtn, 0.05,
                                          PRIM_FULLBRIGHT, powerbtn, 1
                                      ] );
    }
    touch_end( integer num_detected )
    {
        integer face = llDetectedTouchFace( 0 );
        if( llDetectedKey( 0 ) == owner && face == powerbtn )
        {
            state offline;
        }
    }
}
