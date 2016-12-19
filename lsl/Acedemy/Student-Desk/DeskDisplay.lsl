integer api_chan;
integer listenhandle;

integer COURSE_ID;
integer totalquestions;
integer questionindex = 1;
string question;
list answers;
string correctans;
string chosenans;
key USER;

integer INIT = FALSE;

integer debug = TRUE;

list POST_PARAMS = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
list GET_PARAMS = [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];

key EXAM; // For sending COURSE_ID
string COURSE_PAGE = "http://ci-main.no-ip.org/exams.php";

integer ID2Chan( string id )
{
    integer mainkey = 921;
    string tempkey = llGetSubString( ( string )id, 0, 7 );
    integer hex2int = ( integer )( "0x" + tempkey );
    return hex2int + mainkey;
}

setText( string text )
{
    llSetText( text, <1,1,1>, 1.0 );
}

default
{
    state_entry()
    {
        setText( "" );
        llSetTexture( "61320ebe-48bb-8b93-cea9-d1036ab26507", 1 );
        api_chan = ID2Chan( llMD5String( llGetObjectDesc(),0 ) );
        listenhandle = llListen( api_chan, "", "", "" );
    }
    listen( integer channel, string name, key id, string msg )
    {

        list message = llParseString2List( msg, [":"], [] );
        if ( llList2String( message, 0 ) == "Texture" )
        {
            llSetTexture( ( key )llList2String( message, 1 ), 1 );
        }
        else if ( llList2String( message, 0 ) == "COURSE_ID" )
        {
            COURSE_ID = llList2Integer( message, 1 );
            if( debug )
            {
                llSay( 0, "Course ID is now set to " + ( string )COURSE_ID );
            }
        }
        else if ( msg == "START_EXAM:TRUE" )
        {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        if( debug )
        {
            llSay( 0, "I'm now in use!" );
        }
        llSetText( "Exam Ready!\nTouch me to begin!", <1,1,1>, 1.0 );
    }
    touch_start( integer num )
    {
        USER = llDetectedKey( 0 );
        if( debug )
        {
            llSay( 0, "I have been touched by " + llGetDisplayName( USER ) );
        }
        EXAM = llHTTPRequest( COURSE_PAGE, POST_PARAMS, "branch=init&course_id=" + ( string )COURSE_ID );
        llSay( 0, "This is post-HTTP Request Test Text." );
    }
    http_response( key reqid, integer stat, list metadata, string body )
    {
        if( debug )
        {
            llSay( 0, body );
        }
        if ( reqid == EXAM && stat == 200 )
        {
            if ( !INIT )
            {
                list parsedBody = llParseString2List( body, ["|"], [] );
                if ( llList2String( parsedBody, 0 ) == "TOTAL" )
                {
                    totalquestions = llList2Integer( parsedBody, 1 );
                    INIT = TRUE;
                    EXAM = llHTTPRequest( COURSE_PAGE, POST_PARAMS, "branch=line&course_id=" + ( string )COURSE_ID+"&qindex="+( string )questionindex );
                    questionindex += 1;
                    jump break;
                    if( debug )
                    {
                        llSay( 0, "Total questions set to " + ( string )totalquestions );
                    }
                }
            }
            else //INIT == TRUE
            {

            }
            @break;
        }
        else
        {
            llSay( 0, "There was an error. Error details as follows: \nERROR CODE: " + ( string ) stat + "\nERROR INFO: " + body );
        }
    }
}
