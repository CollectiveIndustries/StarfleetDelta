// Global inits

integer listenhandle;
integer adminhandle;
integer NETWORK_CHANNEL;

key destination;
string reqtype;

list TAG_PARAMS_POST = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];  //Convenience
list TAG_PARAMS_GET = [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];    //Convenience

key TagReq = "";

string TAG_PAGE = "http://ci-main.no-ip.org/tag.php"; //Cloning the titler lookup for info grabbing
string HTTP_ERROR = "There was an error looking up the info. Please report this to Engineering and/or IT as soon as possible.";
string result = "";


key owner;

integer debug = FALSE; // Set to true for debug output

// Function Definitions

integer ID2Chan(string id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

// String searcher function, using % for wildcard
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

string getTime()
{
    integer seconds = (integer)llGetWallclock();
    integer minutes = seconds / 60;
    seconds = seconds % 60;
    integer hours = minutes / 60;
    minutes = minutes % 60;

    string stringHours   = llGetSubString("0" + (string)hours,   -2, -1);
    string stringMinutes = llGetSubString("0" + (string)minutes, -2, -1);
    string stringSeconds = llGetSubString("0" + (string)seconds, -2, -1);

    string time = stringHours + ":" + stringMinutes;
    return time;
}

string getStardate()
{
    integer seconds = (integer)llGetWallclock();
    integer minutes = seconds / 60;
    seconds = seconds % 60;
    integer hours = minutes / 60;

    list dateComponents = llParseString2List(llGetDate(), ["-"], []);
    string year  = llList2String(dateComponents, 0);
    string yearshort = llDeleteSubString((string)year, 0, 1);
    string month = llList2String(dateComponents, 1);
    string day   = llList2String(dateComponents, 2);
    string stardate = (string)yearshort + (string)month + (string)day + "." + (string)hours;
    return stardate;
}

string getDate()
{
    string date = llGetDate();
    list dateComponents = llParseString2List(llGetDate(), ["-"], []);
    date = llDumpList2String(dateComponents, "");
    return date;
}


default
{
    state_entry()
    {
        llSay(0, "Booting up.");
        owner = llGetOwner();
        if(debug)
        {
            llSay(0, "Initializing, please wait...");
        }
        if(debug)
        {
            llSay(0, "Ready.");
        }
        NETWORK_CHANNEL = ID2Chan(llMD5String(llGetObjectDesc(), 0));
        listenhandle = llListen(NETWORK_CHANNEL, "", "", "");
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(llList2String(llParseString2List(msg, ["|"], []), 0) == "CORE")
        {
            destination = llList2Key(llParseString2List(msg, ["|"], []), 1);
            reqtype = llList2String(llParseString2List(msg, ["|"], []), 2);
            if(debug)
            {
                llSay(0, "Processing request type: " + reqtype + " on " + llGetObjectDesc());
            }
            if (reqtype == "TIME")
            {
                llRegionSayTo(destination, NETWORK_CHANNEL, "SID|" + reqtype + "|" + "The time is " + getTime());
            }
            else if (reqtype == "DATE")
            {
                llRegionSayTo(destination, NETWORK_CHANNEL, "SID|" + reqtype + "|" + "The date is " + getDate());
            }
            else if (reqtype == "STARDATE")
            {
                llRegionSayTo(destination, NETWORK_CHANNEL, "SID|" + reqtype + "|" + "The stardate is " + getStardate());
                if(debug)
                {
                    llSay(0, "Sending results for " + reqtype + " to " + (string)destination);
                }
            }
            else if (reqtype == "DIAGNOSTIC")
            {
                llRegionSayTo(destination, NETWORK_CHANNEL, "SID|" + reqtype + "|" + "Diagnostic complete. Preparing results...");
                llRegionSayTo(destination, NETWORK_CHANNEL, "SID|" + reqtype + "|" + "Systems nominal. This terminal is connected to Computer Core at address: " + (string)llGetKey());
            }
            else if (reqtype == "WHOAMI")
            {
                key userid = llList2Key(llParseString2List(msg, ["|"], []), 3);
                TagReq = llHTTPRequest(TAG_PAGE, TAG_PARAMS_POST, "uuid=" + (string)userid);
            }
        }
        else if(llList2String(llParseString2List(msg, ["|"], []), 0) == "ADMIN")
        {
            string setting = llToLower(llList2String(llParseString2List(msg, ["|"], []), 1));
            string value = llToLower(llList2String(llParseString2List(msg, ["|"], []), 2));
            if(debug)
            {
                llSay(0, "Processing admin command: " + setting + ":" + (string)value);
            }
            if (setting == "debug")
            {
                if (value == "off")
                {
                    debug = FALSE;
                }
                else if (value == "on")
                {
                    debug = TRUE;
                }
            }
            else if (setting == "reboot")
            {
                llResetScript();
            }
        }
    }
    http_response(key req , integer stat, list met, string body)
    {
        if(req == TagReq)
        {
            if(stat == 200)
            {
                if(llToLower(llGetSubString(body, 0, 5)) == "error:")
                {
                    if(debug)
                    {
                        llWhisper(0, HTTP_ERROR + "\nSTAT: " + (string)stat + "\nRES: " + (string)body);
                    }
                }
                else
                {
                    list tmp = llParseString2List(body, ["\n"], []);
                    llRegionSayTo(destination, NETWORK_CHANNEL, "SID|" + reqtype + "|" + "You are " + llList2String(tmp, 1) + " " + llList2String(tmp, 2) + ", " + llList2String(tmp, 3));
                }
            }
        }
    }
}
