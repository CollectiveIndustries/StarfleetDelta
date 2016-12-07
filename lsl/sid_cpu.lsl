integer listenhandle;

key defaulttexture;

string timeurl;
key time_req;

string stardateurl;
key stardate_req;

string dateurl;
key date_req;

integer contains(string value, string mask) {
    integer tmpy = (llGetSubString(mask,  0,  0) == "%") | 
                  ((llGetSubString(mask, -1, -1) == "%") << 1);
    if(tmpy)
        mask = llDeleteSubString(mask, (tmpy / -2), -(tmpy == 2));
 
    integer tmpx = llSubStringIndex(value, mask);
    if(~tmpx) {
        integer diff = llStringLength(value) - llStringLength(mask);
        return  ((!tmpy && !diff)
             || ((tmpy == 1) && (tmpx == diff))
             || ((tmpy == 2) && !tmpx)
             ||  (tmpy == 3));
    }
    return FALSE;
}

display(string uuid, integer face)
{
    llSetTexture((key)uuid, face);
    llSleep(30);
    llSetTexture(defaulttexture, face);
}

default
{
    state_entry()
    {
        llSay(0, "Initializing, please wait...");
        defaulttexture = "cbe05b00-d0f6-6692-6d24-eeecef8ea04e";
        llSetTexture(defaulttexture, 1);
        timeurl = "http://www.timeapi.org/pst/now?format=%25H:%25M";
        dateurl = "http://www.timeapi.org/pst/now?format=%25Y-%25m-%25d";
        stardateurl = "http://www.timeapi.org/pst/now?format=%25y%25m%25d.%25H";
        state available;
    }
}

state available
{
    state_entry()
    {
        llSay(0, "This terminal is now linked to the Starfleet Interactive Database.");
        llSetTexture("cbe05b00-d0f6-6692-6d24-eeecef8ea04e", 1);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [
        PRIM_COLOR, 2, <0,1,0>, 1.0
        ]);
        listenhandle = llListen(0,"","","");
    }
    listen(integer channel, string name, key id, string msg)
    {
        msg = llToLower(msg);
        {
            if (contains(msg, "%time%"))
            {
                time_req = llHTTPRequest(timeurl, [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"],"");
            }
            else if (contains(msg, "%stardate%"))
            {
                stardate_req = llHTTPRequest(stardateurl, [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"],"");
            }
            else if (contains(msg, "%date%"))
            {
                date_req = llHTTPRequest(dateurl, [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"],"");
            }
            else if (contains(msg, "%texture%"))
            {
                list parsed = llParseString2List(msg, [" "], []);
                display(llList2String(parsed, -1), 1);
            }
            else if (contains(msg, "%sound%"))
            {
                list parsed = llParseString2List(msg, [" "], []);
                llTriggerSound(llList2Key(parsed, -1), 1.0);
            }
        }
    }
    touch_end(integer num)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            state offline;
        }
    }
    http_response(key request_id, integer stat, list metadata, string body)
    {
        if (request_id == time_req)
        {
            llSay(0, "The time is currently " + body);
        }
        else if (request_id == stardate_req)
        {
            llSay(0, "The stardate is " + body);
        }
        else if (request_id == date_req)
        {
            llSay(0, "The date is " + body);
        }
    }
}

state offline
{
    state_entry()
    {
        llListenRemove(listenhandle);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [
        PRIM_COLOR, 2, <1,0,0>, 1.0
        ]);
    }
    touch_end(integer num)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            state available;
        }
    }
}
