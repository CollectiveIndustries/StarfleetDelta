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
    }
    listen(integer channel, string name, key id, string msg)
    {
//        llSay(0, msg);
        list message = llParseString2List(msg, [":"], []);
        if (llList2String(message, 0) == "Sound")
        {
            llPreloadSound((key)llList2String(message, 1));
            llTriggerSound((key)llList2String(message, 1), 1.0);
        }
    }
}
