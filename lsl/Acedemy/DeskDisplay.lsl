/*
It should be noted that this is specifically configured for the example viewport made by
Kodos Macarthur. If this needs to be configured for another viewport, or other device,
please contact him and he will get a script configured for your viewport or device.
*/

integer api_chan;
integer listenhandle;

integer ID2Chan(string ChanKey)
{
    integer mainkey = 921;
    ChanKey = llMD5String(ChanKey);
    string tempkey = llGetSubString(ChanKey, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

default
{
    state_entry()
    {
        api_chan = ID2Chan(llGetObjectDesc(),0);
        listenhandle = llListen(api_chan, "", "", "");
    }

    listen(integer channel, string name, key id, string msg)
    {
        list message = llParseString2List(msg, [":"], []);
        if (llList2String(message, 0) == "Texture")
        {
            llSetTexture((key)llList2String(message, 1), 1);
        }
    }
}
