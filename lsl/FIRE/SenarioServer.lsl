string subject;
string message;
string ConfigCard = "Access List";
integer channel; 
integer listen_handle;
key user;
playRandomSound(list UUIDS)
{
    integer listlen = llGetListLength(UUIDS);
    Debug("sound list len = ",(string)listlen);
    integer index = (integer)llFrand(listlen);
    Debug("random sound index = ",(string)index);
    llSound(llList2String(UUIDS,index), 1.0,TRUE,FALSE);
    llSleep(0.1);    
}
Debug(string msg, string var)
{
    integer DEBUG = FALSE;
    if(DEBUG == TRUE)
    {
        llSay(0, (string)llKey2Name(llGetOwner())+"'S DEBUG: " + msg + ":" + var);
    }
}
ProcessNC(string in)
{
    Debug("ProcessNC(string in)",in);
    // find first equal sign
    integer i = llSubStringIndex(in, "=");

    // if line contains equal sign
    if(i != -1)
    {
        // get name of name/value pair
        string name = llGetSubString(in, 0, i - 1);

        // get value of name/value pair
        string value = llGetSubString(in, i + 1, -1);

        // trim name
        list temp = llParseString2List(name, [" "], []);
        name = llDumpList2String(temp, " ");

        // make name lowercase (case insensitive)
        name = llToLower(name);

        // trim value
        temp = llParseString2List(value, [" "], []);
        value = llDumpList2String(temp, " ");

        if(name == "status")
        {
            ChangeStatus( (string)value);
        }

        else if(name == "sleep")
        {
            llSleep((float)value);
        }

        else if (name == "tacticle")
        {
            Tacticle( (string) value);
        }
        else if(name == "event")
        {
            Events( (string) value);
        }
        else if(name == "screen")
        {
            Screen( (string) value);
        }
        else if(name == "helm")
        {
            Helm( (string) value);
        }
        else if (name == "system")
        {
            System( (string)value);
        }
        else if (name == "bd")
        {
            BD((string)value);
        }
        else if (name == "nc")
        {
            NC((string)value);
        }
        else if (name == "sc")
        {
            SC((string)value);
        }
        else if (name == "halo")
        {
            HALO((string)value);
        }
        

    }
    else  // line does not contain equal sign
    {
        llOwnerSay("Configuration could not be read on line " + (string)lineCounter);
    }
}
SC(string in)
{
    llSay(-85,"plot "+in);
}
HALO(string image)
{
    llSay(-86,"REZIMAGE:"+(string)image);
}
NC(string in)
{
    list temp = llParseString2List(in, [":"], []);
    in = llList2String(temp,0);
    ConfigCard = in;
    lineCounter = llList2Integer(temp,1);
}
// pass phrase used for the security hash.
string passPhrase = "BorgComV1.1";

/* ********************************************************
 * messageWithHash(string message,key id) 
 *
 * Routine to shout on the channel the message with the 
 * security hash.
 * ******************************************************** *|/
string messageWithHash(string message,key id) 
{
    return(message + "\n" + llSHA1String(message+passPhrase+(string)id));
}
integer bchan = -2468 ; // "Secret" channel/frequency message is sent on.
BD(string in)
{
    llRegionSay(bchan,messageWithHash(llKey2Name(llGetKey())+"> "+in,llGetKey()));
}
System(string in)
{
    in = llToLower(in);
    if(in == "reset")
    {
        llRegionSay(SCREEN,"1Space-Stars");
        llRegionSay(EFFECTS,"REPAIR");
        llRegionSay(ALERT,"stand down");   
        llSay(1,"llDIE()");//clear map   
        llSay(-7,"HaloDie");//clean the holo com  
    }
    else if(in == "preload")
    {
        llRegionSay(SCREEN,"PRELOAD_TEXTURES");
    }
}
Screen(string in)
{
    if(llToLower(in) == "base")
    {
        llShout(SCREEN, "Unimatrix");
        //llShout(SCREEN+1,"1Space-Stars");
    }
    else
    {
        llRegionSay(SCREEN,in);
    }
}
Events(string in)
{
    in = llToLower(in);
    if(in == "damage")
    {
        //reciving Damage
        llRegionSay(1213,"Borg Damage");
        llSleep(1);//let the item rez
        llRegionSay(TAC, "fire!");
        llRegionSay(SOUND, "sound:432efa96-6d41-8f60-31e7-6ec86648023b");
        //damange system modual
        llRegionSay(EFFECTS, "DAMAGE");
        //stability system
        llRegionSay(4052, "shake");
        //sound system
        llRegionSay(SOUND, "sound:bfc57452-f97c-6c98-0d9a-e860e5b49983");
        llRegionSay(SYSTEM,"tractor die");
    }
    else if (in == "federation")
    {
        //ViewScreen
        llShout(SCREEN, "NCC1701");
        //llShout(SCREEN+1,"1Space-Stars");
        //Com system
        llShout(COM,"open channel");
        //sound system
        llRegionSay(SOUND, "sound:bc0d5cb2-571a-e9ee-b208-f7dd9a526829");
    }
    else if (in == "8472")
    {
        llShout(SCREEN,"Bioship");
        //llShout(SCREEN+1,"Borg Cube");
        //Com system
        llShout(COM,"open channel");
        //sound system
        llRegionSay(SOUND, "sound:bc0d5cb2-571a-e9ee-b208-f7dd9a526829");
    }
        
    
}
//Helm Station Commands
Helm(string in)
{
    in = llToLower(in);
    if(in == "warp")
    {
        //llRegionSay(19121, "Delete"); // clean the main viewer out
        llRegionSay(HELM, "+warp");
        llRegionSay(SYSTEM,"WARP");
        llSay(1,"llDIE()");//clear map in warp travel
        llSay(-7,"HaloDie");//clean the holo com 
    }
    else if(in == "all stop")
    {
        llRegionSay(HELM, "-warp");
        llRegionSay(SYSTEM,"IMPULSE");
    }
}
//Tacticle station commands
Tacticle(string in)
{
    in = llToLower(in);
    if(in == "fire")
    {
        llShout(1213,"photon (out)");
        llRegionSay(SOUND, "sound:432efa96-6d41-8f60-31e7-6ec86648023b");
        llSleep(1);
        llRegionSay(TAC, "fire!");
    }
    else if(in == "tractor")
    {
        llRegionSay(SYSTEM, "borg tractor");
        
    }
}
//Alert Status switch
ChangeStatus(string in)
{
    in = llToLower(in);
    if(in == "red")
    {
        llRegionSay(ALERT, "red alert");
    }
    else if(in == "green")
    {
        llRegionSay(ALERT, "stand down");
    }
    else if (in == "yellow")
    {
        llRegionSay(ALERT, "yellow alert");
    }
    else if( in == "blue")
    {
        llRegionSay(ALERT, "blue alert");
    }
    else if(in == "mute")
    {
        llRegionSay(ALERT, "computer mute alert");
    }
    //else if (
}
ShowMenu(list menu_items,key id, integer page, integer sort)
{
    integer max = llGetListLength(menu_items);
    if (sort == TRUE)
        menu_items = llListSort(menu_items, 1, 1);

    if(llGetListLength(menu_items) > 12)
    {
        page = page % (1 + (llGetListLength(menu_items) - 1) / 11);
        menu_items = llList2List(menu_items, 11 * page, 11 * page + 10);
        menu_items = menu_items + [">>> " + (string)(page + 1) + " >>>"];
    }
    llDialog(id, "menu", menu_items, ID2Chan(llGetOwner()) );
    llListen(ID2Chan(llGetOwner()),"", NULL_KEY,"");
}
integer ID2Chan(key id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}       
//NC junk dont touch
string ConfigCard = "Config";
integer lineCounter = 0;
key dataRequestID;
//channels DO NOT CHANGE
integer SCREEN = 881213;
integer HELM = -16;
integer ALERT = 4050;
integer TAC = 18;
integer SOUND = -26;
integer EFFECTS = -25;
integer COM = -17;
integer SYSTEM = -100;
default
{
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
    state_entry()
    {
        if (INVENTORY_NOTECARD == llGetInventoryType(ConfigCard))
        {
            llSay(0,"NC found: switching to Run Level: 4");
            state readNotecard;
        }
        else
        {
            llSay(0,(string)ConfigCard + " - Note Card not found SennarioServer offline");
        }
    }
}
state readNotecard
{
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
    state_entry()
    {
        //lineCounter = 0;
        dataRequestID = llGetNotecardLine(ConfigCard, lineCounter);
    }
    dataserver(key query_id, string data) 
    {
        //llSetText("LOADING...LINE: "+(string)lineCounter,<1,1,1>,1.0);
        if (query_id == dataRequestID) 
        {
            if (data != EOF) 
            {    
                if(llGetSubString((string)data,0,0) != "#")
                {                     
                    ProcessNC(data);
                   ++lineCounter;                
                    dataRequestID = llGetNotecardLine(ConfigCard, lineCounter);    
                }
                else 
                {
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(ConfigCard, lineCounter);
                }
            }
            else if (data == EOF)
            {
                state idle;
            }
        }
    }
}
state idle
{
    state_entry()
    {
        llListen(-100,"",NULL_KEY,"");
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
    touch(integer num)
    {
        playRandomSound(["34839c0b-b96b-c669-dd95-4a5143e2582a","34839c0b-b96b-c669-dd95-4a5143e2582a","376e1255-2c0f-1ee2-305c-b45013b54dfc","538ad4bc-64ab-e405-dbab-fd526213b772","8569f73f-15db-e2f5-9dab-249d2beb559e","f66de3b8-2af7-a9d2-a77d-8921e829beaa","ddbc6ccb-4944-01c2-1e4e-18c17154be9f","8ae365ee-600a-549c-66dd-3c7c8ebf3c8e","798f0e9f-7f17-e1fe-7075-bad8d506cde3"]);
        ShowMenu(["RESET"],llDetectedKey(0),1,FALSE);
    }
    listen(integer chan,string name,key id,string msg)
    {
        playRandomSound(["34839c0b-b96b-c669-dd95-4a5143e2582a","34839c0b-b96b-c669-dd95-4a5143e2582a","376e1255-2c0f-1ee2-305c-b45013b54dfc","538ad4bc-64ab-e405-dbab-fd526213b772","8569f73f-15db-e2f5-9dab-249d2beb559e","f66de3b8-2af7-a9d2-a77d-8921e829beaa","ddbc6ccb-4944-01c2-1e4e-18c17154be9f","8ae365ee-600a-549c-66dd-3c7c8ebf3c8e","798f0e9f-7f17-e1fe-7075-bad8d506cde3"]);
        if (msg == "RESET")
        {
            llResetScript();
        }
    }
}