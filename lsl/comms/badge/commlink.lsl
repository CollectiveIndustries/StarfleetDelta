key requestURL;

string POST_URL = "http://ci-main.no-ip.org/commlink.php";

// ###############################################
// Routine to parse a string sent through the
// http server via post.
//       parsePostData(theMessage)
// Returns a strided list with stride length 2.
// Each set has the key and then its value.
list parsePostData(string message)
{
    list postData = [];         // The list with the data that was passed in.
    list parsedMessage = llParseString2List(message, ["&"], []);  // The key/value pairs parsed into one list.
    integer len = ~llGetListLength(parsedMessage);

    while(++len)
    {
        string currentField = llList2String(parsedMessage, len); // Current key/value pair as a string.

        integer split = llSubStringIndex(currentField, "=");    // Find the "=" sign
        if(split == -1)   // There is only one field in this part of the message.
        {
            postData += [llUnescapeURL(currentField), ""];
        }
        else
        {
            postData += [llUnescapeURL(llDeleteSubString(currentField, split, -1)), llUnescapeURL(llDeleteSubString(currentField, 0, split))];
        }
    }
    // Return the strided list.
    return postData;
}

integer contains(string value, string mask)
{
    integer tmpy = (llGetSubString(mask,  0,  0) == "%") |
                   ((llGetSubString(mask, -1, -1) == "%") << 1);
    if(tmpy)
    {
        mask = llDeleteSubString(mask, (tmpy / -2), -(tmpy == 2));
    }

    integer tmpx = llSubStringIndex(value, mask);
    if(~tmpx)
    {
        integer diff = llStringLength(value) - llStringLength(mask);
        return  ((!tmpy && !diff)
                 || ((tmpy == 1) && (tmpx == diff))
                 || ((tmpy == 2) && !tmpx)
                 ||  (tmpy == 3));
    }
    return FALSE;
}

string strReplace(string str, string search, string replace)
{
    return llDumpList2String(llParseStringKeepNulls((str = "") + str, [search], []), replace);
}

string SearchAndReplace(string input, string old, string new)
{
    return llDumpList2String(llParseString2List(input, [old], []), new);
}

integer DEBUG = FALSE;
integer LISTEN_;
key REQ;
integer COMM_CHANNEL = 55;
init()
{
    llListenRemove(LISTEN_);
    DEBUG = FALSE;
    if(llGetSubString(llToLower(llGetObjectName()), 0, 5) == "debug")
    {
        llSetObjectName("DEBUG: " + llKey2Name(llGetOwner()) + ": Comm System V3");
        DEBUG = TRUE;
    }
    //llOwnerSay(llList2String(["Entering Run Level 5","Entering Run Level 3"],DEBUG));
    requestURL = llRequestURL(); // Request that an URL be assigned to me.
    LISTEN_ = llListen(COMM_CHANNEL, "", llGetOwner(), "");
}

CommMsg(string msg)
{
    list tmpmsg = llParseString2List(msg, [" "], []);
    string test4div = llList2String(tmpmsg, 0);

    if (contains(test4div, "$%"))
    {
        list temp = llParseString2List(strReplace(msg, "$", ""), ["|"], []);
        if(llList2String(temp, 0) == "ADMIN" && llList2String(temp, 1) == "TITLE" && llList2String(temp, 2) == "RESET")
        {
            llWhisper(899, "reset");
        }
    }
    else
    {
        llOwnerSay(msg);
    }
}

default
{
    on_rez(integer start_param)
    {
        llSleep(0.5); // Just in case it doesn't attach instantly
        integer IsAttached = (llGetAttached() > 0);  // TRUE if attached, FALSE otherwise
        if(!IsAttached)
        {
            llOwnerSay( "Im a commlink I need to be attached to the Avatar. In your inventory right click and ADD. Entering Run Level 0" );
            llDie();
        }
    }

    state_entry()
    {
        init();
    }

    attach(key id)
    {
        if (id)     // is a valid key and not NULL_KEY
        {
            llOwnerSay("Comm channel is: " + (string)COMM_CHANNEL + " To change your input channel use /" + (string)COMM_CHANNEL + "#input NUMBER");
            llOwnerSay("Syncing with Database....");
            init();
        }
        else
        {
            llHTTPRequest(POST_URL, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "debug=" + (string)DEBUG + "&object_uuid=" + (string)llGetKey() + "&owner_uuid=" + (string)llGetOwner() + "&msg=REMOVE");
            llOwnerSay("Commlink Detatched.");
            llOwnerSay("Entering Run Level 0");
        }
    }

    changed(integer change)
    {
        if(change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_TELEPORT | CHANGED_OWNER))
        {
            //llOwnerSay("System changed. Entering Run Level 6");
            init();
        }
    }

    listen(integer chjan, string name, key id, string msg)
    {
        //llOwnerSay(msg);
        list tmpmsg = llParseString2List(msg, [" "], []);
        string test4div = llList2String(tmpmsg, 0);
        if (contains(test4div, "#input%"))
        {
            COMM_CHANNEL = llList2Integer(tmpmsg, 1);
            llListenRemove(LISTEN_);
            LISTEN_ = llListen(COMM_CHANNEL, "", llGetOwner(), "");
            llOwnerSay("Channel has been updated: " + (string)COMM_CHANNEL);
        }
        else if (contains(test4div, "@%"))
        {
            tmpmsg = llDeleteSubList(tmpmsg, 0, 0);
            REQ = llHTTPRequest(POST_URL, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "debug=" + (string)DEBUG + "&owner_uuid=" + (string)llGetOwner() + "&msg=" + (string)llDumpList2String(tmpmsg, " ") + "&branch=div_lock&div_lookup=" + (string)llDeleteSubString(test4div, 0, 0));
        }
        else
        {
            if(DEBUG)
            {
                llSay(0, "NON DIV LOCK");
            }
            REQ = llHTTPRequest(POST_URL, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "debug=" + (string)DEBUG + "&owner_uuid=" + (string)llGetOwner() + "&msg=" + (string)msg);
        }
    }

    http_response(key req , integer stat, list met, string body)
    {
        if(DEBUG)
        {
            llSay(0, body);
        }
        // Fall back for any error messages that come back.
        if(req == REQ)
        {
            if(llToLower(llList2String(llParseString2List(body, ["|"], [""]), 0)) == "error")
            {
                llOwnerSay(llList2String(llParseString2List(body, ["|"], [""]), 1));
            }
            else if(llToLower(llList2String(llParseString2List(body, ["|"], [""]), 0)) == "info")
            {
                if(llToLower(llList2String(llParseString2List(body, ["|"], [""]), 1)) == "pong")
                {
                    llOwnerSay(SearchAndReplace(strReplace(SearchAndReplace(body, "INFO|PONG", ""), "|", "\n"), "-EOF-", ""));
                }
            }
        }
    }

    http_request(key id, string method, string body)
    {
        list incomingMessage;

        if ((method == URL_REQUEST_GRANTED) && (id == requestURL) )
        {
            // An URL has been assigned to me.
            //llSay(0,"Obtained URL: " + body);
            llOwnerSay("Commlink Synced.");
            REQ = llHTTPRequest(POST_URL, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "debug=" + (string)DEBUG + "&object_uuid=" + (string)llGetKey() + "&owner_uuid=" + (string)llGetOwner() + "&url=" + (string)llEscapeURL(body) + "&msg=UPDATE");
            requestURL = NULL_KEY;
        }
        else if ((method == URL_REQUEST_DENIED) && (id == requestURL))
        {
            // I could not obtain a URL
            llOwnerSay("There was a problem, and a URL was not assigned: " + body);
            requestURL = NULL_KEY;
        }
        else if (method == "POST")
        {
            // An incoming message was received.
            CommMsg(body);
            llHTTPResponse(id, 200, "You passed the following:\n" + llDumpList2String(parsePostData(body), "\n"));
        }
        else
        {
            // An incoming message has come in using a method that has
            // not been anticipated.
            llHTTPResponse(id, 405, "Unsupported Method");
        }
    }
}