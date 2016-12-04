integer api_chan;
integer listenhandle;

integer ID2Chan(string id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

default
{
    state_entry()
    {
        api_chan = ID2Chan(llMD5String(llGetObjectDesc(),0));
        listenhandle = llListen(api_chan, "", "", "");
        llOwnerSay("Listening for traffic on channel " + (string)api_chan);
    }
    listen(integer channel, string name, key id, string msg)
    {
//        llSay(0, msg);
        list message = llParseString2List(msg, [":"], []);
        if (llList2String(message, 0) == "Status")
        {
            if (llList2String(message, 1) == "In_Use")
            {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_COLOR, 3, <1,0,0>, 1.0,
                PRIM_COLOR, 5, <1,0,0>, 1.0
                ]);
                llSetText("Class in session", <1,0,0>, 1.0);
            }
            else if (llList2String(message, 1) == "Available")
            {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_COLOR, 3, <0,1,0>, 1.0,
                PRIM_COLOR, 5, <0,1,0>, 1.0
                ]);
                llSetText("Classroom available for use", <0,1,0>, 1.0);
            }
        }
    }
}
