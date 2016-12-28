////////////////////////////////   DO NOT EDIT BEYOND THIS LINE   ////////////////////////////////
string UPDATE_URL = "http://ci-main.no-ip.org/updateSERVER.php";
key http_request_id;
list HTTP_LIST = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
default
{
    touch( integer num )
    {
        llSetText( "SYSTEM OFFLINE",<1,0,0>,1.0 );
        state offline;
    }
    state_entry()
    {
        llSay( 0,"System Sycning with DataBase Please wait" );
        llSetText( "update system ONLINE",<1,1,1>,1.0 );
        llSleep( 5.0 );
        llSetTimerEvent( 240.0 ); //updates only need to be proccesed every 2 minutes
        http_request_id = llHTTPRequest( UPDATE_URL, HTTP_LIST, "" );
    }
    timer()
    {
        http_request_id = llHTTPRequest( UPDATE_URL, HTTP_LIST, "" );
    }

    http_response( key request_id, integer status, list metadata, string body )
    {
        list UPDATES = llParseString2List( body,["UPDATE"],[] );
        list hand_out = [];
        string temp = "";
        integer list_leng = llGetListLength( UPDATES ); //How many updates do we need to hand out
        integer index;
        key CUSTOMER;
        string ITEM;
        if( status != 200 )
        {
            if( status == 499 )
            {
                llSetText( "499 Client Closed Request (Nginx)",<0,1,0>,1.0 );
                return;
            }
            else if( status == 504 )
            {
                llSetText( "504 Gateway Timeout",<0,1,0>,1.0 );
                return;
            }
            else
            {
                llSetText( ( string )status+" HTTP ERROR CONTACT Collective Industries",<0,1,0>,1.0 );
                return;
            }
        }

        //llSay(0,"PHP ADMIRAL DEBUG: \n" + (string)status);
        if ( request_id == http_request_id && status == 200 )
        {
            llSetText( "PROCESSING UPDATES",<0,1,0>,1.0 );
            for( index = 0; index < list_leng; index++ )
            {
                temp = ( temp = "" ) + llList2String( UPDATES,index );
                hand_out = llParseString2List( temp,["|"],[] );
                CUSTOMER = llList2Key( hand_out,0 );
                if( CUSTOMER != " " )
                {
                    ITEM = llList2String( hand_out,1 );
                    ITEM = llStringTrim( ITEM, STRING_TRIM );
                    llGiveInventory( CUSTOMER,ITEM );
                    llInstantMessage( CUSTOMER,"your "+ITEM+" will be sent to you momentarily." );
                }//there was nothing in the DataBase so we exit
            }
            //llOwnerSay("SERVER REPORTED: "+(string)body);

        }
    }
}
state offline
{
    state_entry()
    {
        llSay( 0,"System Offline no updates will be processed." );
    }
    touch( integer num )
    {
        llResetScript();
    }
}
