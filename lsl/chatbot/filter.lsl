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
string mesg;
key gOwner;
list talkers;


listen_to(key talker)
{
    integer index = llListFindList( talkers, [talker] );
    if ( index != -1 )
    {
        talkers = llDeleteSubList(talkers, index, index);
        llMessageLinked(LINK_SET,0,"BYE",talker);
    }
    else
    {
        talkers = talkers + talker;
        llMessageLinked(LINK_SET,0,"HI",talker);
    }
}


default
{
    state_entry()
    {
        gOwner = llGetOwner();
        llListen(0,"",NULL_KEY,"");
    }

    on_rez(integer i)
    {
        llWhisper(0,"Owner say /chat or touch me");
        llResetScript();
    }

    touch_start(integer num_detected)
    {
        listen_to(llDetectedKey(0));
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "/chat")
        {
            listen_to(id);
            return;
        }
        if ((msg == "/reset") && (id == gOwner))
        {
            llWhisper(0,"Resetting");
            llResetScript();
        }



        integer index = llListFindList( talkers, [id] );
        if (index != -1)
        {
            mesg = llToLower(msg);
            llMessageLinked(LINK_SET,0,msg,id);
        }
    }

}
