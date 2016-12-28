//Product Registration Info
string Product_Name = "BORG_DASH";
string SCRIPT_VER = "21";
string MOD_VER = "81c65d80-2e5c-42e2-b6f2-0e541368ca1a";//UUID KEY of the AV that MADE the LAST change to the OBJECT
integer version = 9;//this is the script updater version
integer PIN = 7754;//DO NOT CHANGE THE PIN this will be unique for each PRODUCT


//////////////// GLOBAL VARIABLES ///////////////
string UP_URL = "Updates/update.php";//this goes ON THE END of the BASE_URL
string ERROR_MESSAGE = ""; //temp string for handling error codes that will be emailed to ADMIN_EMAIL
string ADMIN_EMAIL = "admmorketh@ci-main.comule.com"; //AdmiralMorketh Sorex email

//List of URLS for fall-back  urls will be checked in this order
list BASE_URLS = ["http://ci-main.no-ip.org/","http://ci-dallas.no-ip.biz/","http://ci-main.comule.com/"];
string _POST = ""; //$_POST[""] data for the PHP hook
integer URL_INDEX = 0; //default index is 0 ci-main

//////////////// DONOT EDIT BELOW ///////////////
key http_request_id;
list HTTP_LIST = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
string update = "";

//URL Swapping Function
string CI_URL2String( list URLS, integer index )
{
    string temp = llList2String( URLS,index );
    return temp;
}

CI_ERROR( integer status, string admin_email, string email_body )
{
    string EMAIL_HEADER = llGetScriptName();
    /*error handling block for diagnostics these are normaly FATAL*/
    llOwnerSay( "Contact AdmiralMorketh Sorex and report this error code -->" );
    llOwnerSay( "WARNING TransWarp SYSTEM RETURNED: "+( string )status+" ERROR!!!!!!!" );
    llOwnerSay( "An email report detailing this error has been sent to the Collective Industries WebAdmin for diagnostics." );
    llOwnerSay( "Please bear with us as we work hard to fix this issue, and thank you for choosing Collective Industries." );
    llEmail( admin_email,EMAIL_HEADER,email_body ); //send ADMIN_EMAIL a message detailing the errors encountered
}

// CI error Handler
CI_IsERROR( string msg )
{
    list temp = llParseString2List( msg,[":"],[""] );

    if( llToLower( llList2String( temp, 0 ) ) == "error" )
    {
        CI_ERROR( 550, ADMIN_EMAIL,"ERROR FROM URL: "+CI_URL2String( BASE_URLS,URL_INDEX )+UP_URL+"?"+_POST+"\n"+msg );
    }
    else if( llToLower( llList2String( temp,0 ) ) == "warning" )
    {
        CI_ERROR( 900, ADMIN_EMAIL,"ERROR FROM URL: "+CI_URL2String( BASE_URLS,URL_INDEX )+UP_URL+"?"+_POST+"\n"+msg );
    }

}

default
{
    on_rez( integer start )
    {
        llResetScript();
    }
    state_entry()
    {
        llSetRemoteScriptAccessPin( PIN );
        update = "update|"+( string )version;
        _POST = "item="+Product_Name+"&version="+SCRIPT_VER+"&mod="+MOD_VER;
        llOwnerSay( "Loading: "+Product_Name+" "+SCRIPT_VER );

        http_request_id = llHTTPRequest( CI_URL2String( BASE_URLS,URL_INDEX ) + UP_URL, HTTP_LIST, _POST );
        llListen( -200,"",NULL_KEY,"" );
    }
    listen( integer chan,string name,key id,string msg )
    {
        if( update == msg )
        {
            llSay( -500,"update|0" );
        }
        else if( llList2String( llParseString2List( msg,["|"],[] ),0 ) == "update" )
        {
            //make sure this is a reall update
            if( llList2Integer( llParseString2List( msg,["|"],[] ),0 ) < version )
            {
                llSay( -500,"update|1" ); //send the request if the version is GREATER THEN what we have
            }
            else if( llList2Integer( llParseString2List( msg,["|"],[] ),0 ) > version )
            {
                //if we were asked for an update and updater is LESS THEN what we have print out info and remove updater
                llOwnerSay( "Loading: "+Product_Name+" "+SCRIPT_VER );
                llOwnerSay( "updater is out dated" );
                llSay( -500,"update|0" );
            }
        }
    }

    timer()
    {
        http_request_id = llHTTPRequest( CI_URL2String( BASE_URLS,URL_INDEX ) + UP_URL, HTTP_LIST, _POST );
    }
    http_response( key request_id, integer status, list metadata, string body )
    {
        integer index;
        //llOwnerSay("PHP ADMIRAL DEBUG: \n" + (string)body);
        if ( request_id == http_request_id )
        {
            if( status != 200 )
            {
                ERROR_MESSAGE = ERROR_MESSAGE + CI_URL2String( BASE_URLS,URL_INDEX )+UP_URL+"?"+_POST + " -> " + ( string )status + "\n"; //put a trailing \n (newline) to separate the status codes on the web pages each URL that was tried will be given with the Status of that URL for diagnostics
                //llOwnerSay("Contact AdmiralMorketh Sorex and report this error code -->");
                if( status == 500 )
                {
                    llSetText( "ERROR: 500 internal server error",<1,1,1>,1.0 );
                    //return;
                }
                llSleep( 2.0 ); //sleep to display error message
                //llOwnerSay("WARNING TransWarp SYSTEM RETURNED:") "+(string)status+" ERROR");
                llOwnerSay( "Checking additional URLS......." );
                URL_INDEX++; //try next URL in list
                if( URL_INDEX < llGetListLength( BASE_URLS ) )
                {
                    http_request_id = llHTTPRequest( CI_URL2String( BASE_URLS,URL_INDEX ) + UP_URL, HTTP_LIST, _POST );
                }
                else
                {
                    CI_ERROR( status, ADMIN_EMAIL, ERROR_MESSAGE );
                }
            }
            else if( status == 200 )
            {
                CI_IsERROR( body );
                llOwnerSay( "UPDATE SERVER REPORTED: "+( string )body );
                llOwnerSay( "Product Info: "+( string )CI_URL2String( BASE_URLS,URL_INDEX )+Product_Name );
                llOwnerSay( "automatic update checking will be set to 24 hours" );
                llSetTimerEvent( 86400.0 );
            }
        }
    }
}
