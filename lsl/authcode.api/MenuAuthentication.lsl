string authurl = "https://starfleetdelta.com/auth.php";
key authrequest;

key user;
integer gListener; // Dialog listeners
integer oListener;

list users;

default
{
    state_entry()
    {
        llSetPrimitiveParams( [PRIM_COLOR, 1, <0, 0, 1>, 1.0] );
        llSay( 0, "Initializing, please wait..." );
        llSleep( 3.0 );
        state available;
    }
}

state available
{
    state_entry()
    {
        llSetText( "", <1, 1, 1>, 1.0 );
        llSay( 0, "Terminal is now available" );
        llSetPrimitiveParams( [
            PRIM_COLOR, 1, <0, 1, 0>, 1.0,
            PRIM_COLOR, 2, <0, 1, 0>, 1.0,
            PRIM_COLOR, 3, <0, 1, 0>, 1.0,
            PRIM_COLOR, 4, <0, 1, 0>, 1.0
        ] );
    }
    touch_start( integer num_detected )
    {
        user = llDetectedKey( 0 );
    }
    touch_end( integer num_detected )
    {
        if( user == llGetOwner() )
        {
            llListenRemove( oListener );
            oListener = llListen( -1357, "", "", "" );
            llDialog( user, "Select an option", ["Touch", "List Users", "Turn Off"], -1357 );
            llSetTimerEvent( 30.0 );
        }
        else
        {
            state in_use;
        }
    }
    timer()
    {
        llListenRemove( oListener );
        llSetTimerEvent( 0 );
        state available;
    }
    listen( integer chan, string name, key id, string msg )
    {
        if ( msg == "Touch" )
        {
            llListenRemove( oListener );
            llSetTimerEvent( 0 );
            state in_use;
        }
        else if ( msg == "List Users" )
        {
            llOwnerSay( llList2CSV( users ) );
            users = [];
            llSetTimerEvent( 0.1 );
        }
        else if ( msg == "Turn Off" )
        {
            llListenRemove( oListener );
            llSetTimerEvent( 0 );
            state off;
        }
    }
}

state in_use
{
    state_entry()
    {
        llSay( 0, "Terminal now in use by " + llGetDisplayName( user ) );
        llSetPrimitiveParams( [PRIM_COLOR, 4, <1, 0, 0>, 1.0] );
        llListenRemove( gListener );
        gListener = llListen( -2468, "", "", "" );
        users += llGetDisplayName( user );
        llTextBox( user, "Please enter what you want to use for a command code.\n\nPlease note that you cannot use more than 32 characters", -2468 );
        llSetTimerEvent( 60.0 );
    }
    timer()
    {
        llListenRemove( gListener );
        llSetTimerEvent( 0 );
        state available;
    }
    listen( integer chan, string name, key id, string msg )
    {
        llListenRemove( gListener );
        authrequest = llHTTPRequest( authurl, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "uuid=" + ( string )user + "&code=" + ( string )msg );
    }
    http_response( key request_id, integer stat, list metadata, string body )
    {
        if ( request_id == authrequest )
        {
            if ( stat == 200 )
            {
                list result = llParseString2List( body, ["|"], [] );
                string status = llList2String( result, 0 );
                if ( status == "OK" )
                {
                    integer accountID = llList2Integer( result, 1 );
                    string rank = llList2String( result, 2 );
                    string name = llList2String( result, 3 );
                    string division = llList2String( result, 4 );
                    string dname = llRequestDisplayName( user );
                    llSay( 0, "Acknowledged. Welcome, " + rank + " " + name + ". Your command code has been authenticated." );
                    llSleep( 5 );
                    state available;
                }
                else if ( status == "ERROR" )
                {
                    string errcode = llList2String( result, 1 );
                    llSay( 0, "There was an error. Error: " + errcode );
                    llSleep( 2 );
                    state available;
                }
            }
            else if ( stat == 500 )
            {
                llSetText( "Error 500", <1, 1, 1>, 1.0 );
                llSleep( 2 );
                state available;
            }
            else
            {
                llSetText( "Generic Error: " + body, <1, 1, 1>, 1.0 );
                llSleep( 2 );
                state available;
            }
        }
    }
}

state off
{
    state_entry()
    {
        llSay( 0, "Terminal offline." );
        llSetPrimitiveParams( [
            PRIM_COLOR, 1, <0.1, 0.1, 0.1>, 1.0,
            PRIM_COLOR, 2, <0.1, 0.1, 0.1>, 1.0,
            PRIM_COLOR, 3, <0.1, 0.1, 0.1>, 1.0,
            PRIM_COLOR, 4, <0.1, 0.1, 0.1>, 1.0
        ] );
    }
    touch_end( integer num_detected )
    {
        integer face = llDetectedTouchFace( 0 );
        if( llDetectedKey( 0 ) == llGetOwner() && face == 1 )
        {
            state default;
        }
    }
}
