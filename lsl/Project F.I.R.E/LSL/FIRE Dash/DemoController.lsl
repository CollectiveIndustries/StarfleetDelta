/*
// pass phrase used for the security hash.
string passPhrase = "BAlert";

//* ******************************************************** \\
//* messageWithHash(string message,key id)                   //
//*                                                          \\
//* Routine to shout on the channel the message with the     //
//* security hash.                                           \\
//* ******************************************************** //
string messageWithHash(string message,key id) 
{
    return(message + "\n" + llSHA1String(message+passPhrase+(string)id));
}

//integer inchan = 4 ; // Input channel
integer bchan = -999 ; // "Secret" channel/frequency message is sent on.*/

integer com_chan = 4050;
integer SCom = FALSE;

integer SHEILDS = FALSE;

string tex = "tex1";    
string anim = "off";
integer channel; 
integer listen_handle;
key user;
list sub_menu;
list main_menu = ["Alerts","Sensor Grid","Channels","OPTIONS"];
integer REZZERS = 01201;

init() {
    llListenRemove(listen_handle);
    user = llDetectedKey(0);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", user, "");
}

 show_menu(list s_m)
{  
    sub_menu = s_m;
     llDialog(user, "\nPick the Colour you'd like~", llList2ListStrided(sub_menu, 0, -1, 2), channel);
}

default
{
    on_rez(integer s) { init(); }
    state_entry() { init(); }
    touch_start(integer s)
    {
        user = llDetectedKey(0);
        if (llDetectedKey(0) == user) 
        {    
            llDialog(user, "\nSelect Category from below~", main_menu, channel);
        }
    }
    
    listen(integer channel, string name, key id, string message) {
                        
        if (llListFindList(main_menu, [message]) != -1) 
        {
            // main menu Lists
            if (message == "Alerts") 
                llDialog(user, "\nBorg Alert Systems", ["Red Alert", "Yellow Alert", "Blue Alert", "Grey Alert", "Intruder", "Orange Alert","Green Alert","No Sound","Stand Down","Abandon Ship"], channel);
            if (message == "Sensor Grid") 
                llDialog(user, "\nSensor Grid Controles", ["ON","OFF"], channel);
            if (message == "Channels") 
                llDialog(user, "\nAnimation menu~", ["Fed Com","Borg Com","QH"], channel);
            if (message == "OPTIONS") 
                llDialog(user, "\nAnimation menu~", ["FULL COM","Shake","REZ_ON","REZ_OFF","DAMAGE on","DAMAGE off","SHEILDS","RESET"], channel);
        }
        //Sub Menu Items
        else if (message == "FULL COM") 
        {
            if(SCom == FALSE)
            {
                llOwnerSay("systems online: Stargate Alarms tethered.");
                SCom = TRUE;
                return;
            }
            if (SCom == TRUE)
            {
                llOwnerSay("systems offline: Stargate Alarms untethered.");
                SCom = FALSE;
                return;
            }
        }
        else if (message == "Red Alert") {
                tex = "tex2";
                llRegionSay(com_chan,"red alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"red alert");
                }  
            }
        else if (message == "No Sound") {
                tex = "tex3";
                llRegionSay(com_chan,"computer mute alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"computer mute alert");
                }
            }
        else if (message == "Yellow Alert") {
                tex = "tex4";
                llRegionSay(com_chan,"yellow alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"yellow alert");
                }
            }
        else if (message == "Blue Alert") {
                tex = "tex5";
                llRegionSay(com_chan,"blue alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"blue alert");
                }
                //llRegionSay(bchan,messageWithHash("Blue Alert",llGetKey()));
            }
        else if (message == "Intruder") {
                tex = "tex6";
                llRegionSay(com_chan,"intruder");// interface for the securi9ty pannel
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"intruder");
                }
            }
        else if (message == "Grey Alert") {
                tex = "tex7";
                llRegionSay(com_chan,"grey alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"grey alert");
                }
            }
            else if (message == "Orange Alert") {
                tex = "tex8";
                llRegionSay(com_chan,"orange alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"orange alert");
                }
            }
        else if (message == "Green Alert") {
                tex = "tex9";
                llRegionSay(com_chan,"cancel alert");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"cancel alert");
                }
            }
        else if (message == "Stand Down") {
                tex = "tex10";
                llRegionSay(com_chan,"stand down");
                if(SCom == TRUE)
                {
                    llRegionSay(4051,"stand down");
                }
            }
        else if (message == "OFF") {
                tex = "tex11";
                 llRegionSay(com_chan,"deactivate grid");
            }
        else if (message == "ON") {
                tex = "tex12";
                llRegionSay(com_chan,"activate grid");
            }
         else if (message == "Fed Com") 
         {
                com_chan = -999;
                llSay(0,"The Borg have adapted to federation Com Channels");
            }
        else if (message == "Borg Com") 
        {
                com_chan = 4050;
                llSay(0,"Reintegrating to Regular Com chanels");
            }
        else if (message == "QH") 
        {
                com_chan = 7;
            }
        else if (message == "Abandon Ship") 
        {
                llRegionSay(com_chan,"lockdown");
        }
        else if (message == "Shake") 
        {
                llRegionSay(4052,"shake");
        }
        else if (message == "REZ_ON") 
        {
                llRegionSay(REZZERS,"REZ_ON");
        }
        else if (message == "REZ_OFF") 
        {
                llRegionSay(REZZERS,"REZ_OFF");
        }
        else if (message == "DAMAGE on")
        {
                llRegionSay(-25,"DAMAGE");
        }
        else if (message == "DAMAGE off")
        {
                llRegionSay(-25,"REPAIR");
        }
        else if (message == "RESET")
        {
            llRegionSay(-100,"RESET");
        }
        else if (message == "SHEILDS")
        {
            if(SHEILDS == FALSE)
            {
                llOwnerSay("sheilds ONLINE");
                SHEILDS = TRUE;
                llRegionSay(-22,"SHEILD");
                return;
            }
            else if (SHEILDS == TRUE)
            {
                llOwnerSay("sheilds OFFLINE");
                SHEILDS = FALSE;
                llRegionSay(-22,"StandBY");
                return;
            }
        }
            
    }   
}
