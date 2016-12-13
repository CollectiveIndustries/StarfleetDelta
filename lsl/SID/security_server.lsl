integer mainlight;
integer statlight;
integer powerbtn;
integer count;

integer listenhandle;
integer NETWORK_CHANNEL;
string COORDS;
string RELAYNAME;
string PUSHERNAME;

integer debug = FALSE;

list Names = [
"d6110a36-8531-4831-a581-3715c8f4a1b2", // Kodos Macarthur for testing
"c3209b01-62f2-4097-ab11-6e371507ac8d"  // Evo
];


integer ID2Chan(string id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

key owner;

default
{
    state_entry()
    {
        NETWORK_CHANNEL = ID2Chan(llMD5String(llGetObjectDesc(),0));
        owner = llGetOwner();
        mainlight = 1;
        statlight = 2;
        powerbtn = 3;
        if(debug) llSay(0, "Initializing, please wait...");
        if(debug) llSay(0, "Ready.");
        state online;
    }
}

state offline
{
    state_entry()
    {
        llListenRemove(listenhandle);
        if(debug) llSay(0, "Server Offline");
        llSetLinkPrimitiveParamsFast(LINK_THIS, [
        PRIM_COLOR, mainlight, <0.2,0.5,0.2>, 1.0,
        PRIM_COLOR, statlight, <0.1,0.1,0.1>, 1.0,
        PRIM_GLOW, statlight, 0.0,
        PRIM_FULLBRIGHT, statlight, 0,
        PRIM_COLOR, powerbtn, <0.25,0,0>, 1.0,
        PRIM_GLOW, powerbtn, 0.0,
        PRIM_FULLBRIGHT, powerbtn, 0
        ]);
    }
    touch_end(integer num_detected)
    {
        if(llDetectedKey(0) == owner && llDetectedTouchFace(0) == powerbtn)
        state online;
    }
}

state online
{
    state_entry()
    {
        llSay(0, "Booting up.");
        listenhandle = llListen(NETWORK_CHANNEL, "", "", "");
        if(debug) llSay(0, "Server Online");
        llSetLinkPrimitiveParamsFast(LINK_THIS, [
        PRIM_COLOR, mainlight, <0.4,1,0.4>, 1.0,
        PRIM_COLOR, statlight, <0,1,0>, 1.0,
        PRIM_GLOW, statlight, 0.05,
        PRIM_FULLBRIGHT, statlight, 1,
        PRIM_COLOR, powerbtn, <0,1,0>, 1.0,
        PRIM_GLOW, powerbtn, 0.05,
        PRIM_FULLBRIGHT, powerbtn, 1
        ]);
    }
    
    touch_end(integer num_detected)
    {
        integer face = llDetectedTouchFace(0);
        if(llDetectedKey(0) == owner && face == powerbtn)
        state offline;
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(llList2String(llParseString2List(msg, ["|"], []), 0) == "ALERT")
        {
            RELAYNAME = llList2String(llParseString2List(msg, ["|"], []), 1);
            PUSHERNAME = llList2Key(llParseString2List(msg, ["|"], []), 2);
            vector COORDS = (vector)COORDS;
            for (count = 0; count < llGetListLength(Names);count++)
            {
                if(debug) llSay(0, llList2String(Names, count));
                string simName = llGetRegionName();
                string newSlurlPrefix = "http://maps.secondlife.com/secondlife/";
                list details = llGetObjectDetails(PUSHERNAME, [OBJECT_POS]);
                vector userPOS = llList2Vector(details, 0);
                string urlSuffix = llEscapeURL(simName) + "/" + (string)llRound(userPOS.x + 1) + "/" + (string)llRound(userPOS.y) + "/" + (string)llRound(userPOS.z);
                
                llInstantMessage(llList2Key(Names, count), llGetDisplayName(PUSHERNAME) + " is sending a Security Alert at coordinates " + newSlurlPrefix + urlSuffix + " in region " + llGetRegionName() + " at the " + RELAYNAME);
            }
        }
        else if(llList2String(llParseString2List(msg, ["|"], []), 0) == "ADMIN")
        {
            if(llList2String(llParseString2List(msg, ["|"], []), 1) == "REBOOT")
            {
                llListenRemove(listenhandle);
                llResetScript();
            }
        }
    }
}       
