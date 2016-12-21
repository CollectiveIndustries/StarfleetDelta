// Script Name: Pandora_Chatbot.lsl
//A chatbot that connects to an ALICE/AIML website.

// Downloaded from : http://www.free-lsl-scripts.com/freescripts.plx?ID=1274

// This program is free software; you can redistribute it and/or modify it.
//
// There are literally thousands of hours of work in these scripts. Please respect
// the creators wishes and follow their license requirements.
//
// License information must be included in any script you give out or use.
// Licenses are included in the script or comments by the original author, in which case
// the authors license must be followed.

// A GNU license, if attached, means the code must be MODIFIABLE everywhere.
// Any source code changes, including any derivatives, must be published to
// anyone who asks for it.  You cannot attach a license to make this
// more or less restrictive.  see http://www.gnu.org/copyleft/gpl.html

// Creative Commons licenses apply to all scripts from the Second Life
// wiki and script library and are Copyrighted by Linden Lab. See
// http://creativecommons.org/licenses/

// Please leave any author credits and headers intact in any script you use or publish.
// If you don't like these restrictions, then don't use these scripts.
////////////////////////////////////////////////////////////////////
key requestid;
string botid;
string cust;
string reply;
string newreply;
integer that_begin;
integer that_end;
integer cust_begin;

string ANSWER( string in )
{
    integer begining;
    integer end;
    //<that>BOT ANSWERS HERE</that>
    begining = llSubStringIndex( in, "<that>" ); //get the begining marker for the return chat
    end = llSubStringIndex( in, "</that>" ); //get the ending marker marker for the return chat
    return llGetSubString( in, begining + 6, end - 1 ); //select ONLY that section of chat
}

string SearchAndReplace( string input, string old, string new )
{
    return llDumpList2String( llParseString2List( input, [old], [] ), new );
}

default
{
    state_entry()
    {
        cust = "";
        botid = "a62644feee375ab9"; //change this to your BOTID or any BOTID for any webbased AIML chat bot
    }

    on_rez( integer param )
    {
        llResetScript();
    }

    link_message( integer sender_num, integer num, string msg, key id )
    {
        requestid = llHTTPRequest( "http://www.pandorabots.com/pandora/talk-xml?botid=" + botid + "&input=" + llEscapeURL( msg ) + "&custid=" + cust, [HTTP_METHOD, "POST"], "" );
    }
    http_response( key request_id, integer status, list metadata, string body )
    {
        if ( request_id == requestid )
        {
            //lt status="0" botid="d39d74092e343ef7" custid="927920cc9b50855e">
            //<that>BOT ANSWERS HERE</that>
            cust_begin = llSubStringIndex( body, "custid=" );
            cust = llGetSubString( body, cust_begin + 8, cust_begin + 23 );
            that_begin = llSubStringIndex( body, "<that>" ); // this should be < that > (delete @)
            that_end = llSubStringIndex( body, "</that>" ); //this should be < / that > (delete @)
            reply = llGetSubString( body, that_begin + 6, that_end - 1 );
            newreply = SearchAndReplace( reply, "%20", " " );
            reply = newreply;
            newreply = SearchAndReplace( reply, "& quot;", "\"" ); //this should be &quot; (delete @) the wiki changes it to "
            reply = newreply;
            newreply = SearchAndReplace( reply, "& lt;br& gt;", "\n" ); //the first search should be & lt;br & gt; (delete @)
            reply = newreply;
            newreply = SearchAndReplace( reply, "& gt;", ">" ); //the first search should be & gt; (delete @)
            reply = newreply;
            newreply = SearchAndReplace( reply, "& lt;", "<" ); //this first search should be & lt;

            llSay( 0, newreply );
            //llSay(0,ANSWER(body));
        }
    }
}
