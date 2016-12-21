integer count;

integer listenhandle;
integer NETWORK_CHANNEL;
string COORDS;
string RELAYNAME;
string PUSHERNAME;

integer debug = FALSE;

list Names = [
                 "d6110a36-8531-4831-a581-3715c8f4a1b2" // Kodos Macarthur for testing
             ];


integer ID2Chan( string id )
{
    integer mainkey = 921;
    string tempkey = llGetSubString( ( string )id, 0, 7 );
    integer hex2int = ( integer )( "0x" + tempkey );
    return hex2int + mainkey;
}

key owner;

default
{
    state_entry()
    {
        NETWORK_CHANNEL = ID2Chan( llMD5String( llGetObjectDesc(), 0 ) );
        owner = llGetOwner();
        if( debug )
        {
            llSay( 0, "Initializing, please wait..." );
        }
        if( debug )
        {
            llSay( 0, "Ready." );
        }
        listenhandle = llListen( NETWORK_CHANNEL, "", "", "" );
    }
    listen( integer chan, string name, key id, string msg )
    {
        if( llList2String( llParseString2List( msg, ["|"], [] ), 0 ) == "ALERT" )
        {
            RELAYNAME = llList2String( llParseString2List( msg, ["|"], [] ), 1 );
            PUSHERNAME = llList2Key( llParseString2List( msg, ["|"], [] ), 2 );
            vector COORDS = ( vector )COORDS;
            for ( count = 0; count < llGetListLength( Names ); count++ )
            {
                if( debug )
                {
                    llSay( 0, llList2String( Names, count ) );
                }
                string simName = llGetRegionName();
                string newSlurlPrefix = "http://maps.secondlife.com/secondlife/";
                list details = llGetObjectDetails( PUSHERNAME, [OBJECT_POS] );
                vector userPOS = llList2Vector( details, 0 );
                string urlSuffix = llEscapeURL( simName ) + "/" + ( string )llRound( userPOS.x + 1 ) + "/" + ( string )llRound( userPOS.y ) + "/" + ( string )llRound( userPOS.z );

                llInstantMessage( llList2Key( Names, count ), llGetDisplayName( PUSHERNAME ) + " is sending a Security Alert at coordinates " + newSlurlPrefix + urlSuffix + " at the " + RELAYNAME );
            }
        }
        else if( llList2String( llParseString2List( msg, ["|"], [] ), 0 ) == "ADMIN" )
        {
            if( llList2String( llParseString2List( msg, ["|"], [] ), 1 ) == "REBOOT" )
            {
                llListenRemove( listenhandle );
                llResetScript();
            }
        }
    }
}
