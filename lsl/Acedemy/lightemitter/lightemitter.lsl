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
        if (llList2String(message, 0) == "Lights")
        {
            if (llList2String(message, 1) == "Dim")
            {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_POINT_LIGHT, TRUE, <1,1,1>, .2, 20.0, 2.0,
                PRIM_FULLBRIGHT, -1, FALSE,
                PRIM_GLOW, -1, .2
                ]);
            }
            else if (llList2String(message, 1) == "Bright")
            {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_POINT_LIGHT, TRUE, <1,1,1>, 1.0, 20, 2.0,
                PRIM_FULLBRIGHT, -1, TRUE,
                PRIM_GLOW, -1, 1.0
                ]);
            }
            else if (llList2String(message, 1) == "Off")
            {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_POINT_LIGHT, FALSE, <1,1,1>, 1.0, 20, 2.0,
                PRIM_FULLBRIGHT, -1, FALSE,
                PRIM_GLOW, -1, 0.0
                ]);
            }
        }
    }
}
