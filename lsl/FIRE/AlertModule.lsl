string alert = "none";
integer sound = TRUE;
float LRadius = 2.75;//light radius
//color variables for the alert lights
vector Red =    <1.0,0.0,0.0>;
vector Yellow = <1.0,1.0,0.0>;
vector Blue =   <0.0,0.0,1.0>;
vector Orange = <1.0,0.5,0.0>;//needs tweaking
vector Grey =   <0.5,0.5,0.5>;

Flash(vector color, string audio, integer sounds)
{
    llSetColor(color,ALL_SIDES);
    llSetLinkColor(LINK_THIS,color, ALL_SIDES);
    llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 1.0]);
    llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, color, LRadius, 5.0, 0.0]);
    if (sounds == TRUE & sound == TRUE)/*turns the sounds off when you select mute from menu*/ 
    {
        llTriggerSound(audio,1.0);
    }
    llSleep(1.5);
    llSetColor(<0.1,0.1,0.1>,ALL_SIDES);
    llSetLinkColor(LINK_THIS,<0.1,0.1,0.1>, ALL_SIDES);
    llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
    llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, color, 1.0, LRadius, 0.0]);
    llSleep(1.5);
}


vector none = <0.1,0.1,0.1>; //defualt color for off
string Red_Alert    = "465fecec-5d6e-9ff0-3e40-78e146b54faa";
string Yellow_Alert = "1459f0be-a13b-1a39-f893-7cf97f1a52eb";
string Blue_Alert   = "f05b807b-85bc-deea-21d0-93ef0cf316d6";
string Orange_Alert = "8479106b-8be7-209a-fcfb-7ec24b96ca29";
string Abandon_Ship = "f3027ebf-f8ac-4537-75fe-225e7c83a8e1";
string Grey_Alert   = "";//no sound for grey alert this is for power saving reasons
default
{
    state_entry()
    {
        llListen(4050,"", "","");
        llPreloadSound(Red_Alert); // Preload Red Alert sound
        llPreloadSound(Yellow_Alert); // Preload Yellow Alert sound
        llPreloadSound(Blue_Alert); // Preload Blue Alert sound
        llPreloadSound(Abandon_Ship); // Abandon Ship sound
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "red alert")
            {
                alert = "red";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(1.5);
                return;
            }
            
            if (message == "orange alert")
            {
                alert = "orange";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(1.5);
                return;
            }
            
        if (message == "computer mute alert")
            {
                sound = FALSE;
                llMessageLinked(LINK_THIS,0,"audio off",NULL_KEY);
                llSay(0,"Alert audio muted...");
                return;
            }
        
        if (message == "computer unmute alert")
            {
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSay(0,"Alert audio resumed...");
                return;
            }
            
            if (message == "grey alert")
            {
                alert = "grey";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio off",NULL_KEY);
                llSetTimerEvent(1.5);
                return;
            }
            
        if (message == "blue alert")
            {
                alert = "blue";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(1.5);
                return;
            }
            
        if (message == "yellow alert")
            {
                alert = "yellow";
                llSetTimerEvent(1.5);
                llTriggerSound("1459f0be-a13b-1a39-f893-7cf97f1a52eb",1.0);
            }
        
        if (message == "cancel alert")
            {
                alert = "none";
                llSetTimerEvent(0.0);
                llSetColor(<0.1,0.1,0.1>,ALL_SIDES);
                llSetLinkColor(LINK_THIS,<0.1,0.1,0.1>, ALL_SIDES);
                return;
            }
        
        if (message == "stand down")
            {
                alert = "none";
                llSetTimerEvent(0.0);
                llSetColor(<0.1,0.1,0.1>,ALL_SIDES);
                llSetLinkColor(LINK_THIS,<0.1,0.1,0.1>, ALL_SIDES);
                return;
            }
            
        if (message == "condition green")
            {
                alert = "none";
                llSetTimerEvent(0.0);
                llSetColor(<0.1,0.1,0.1>,ALL_SIDES);
                llSetLinkColor(LINK_THIS,<0.1,0.1,0.1>, ALL_SIDES);
                return;
            }
        
        if (message == "lockdown" || message == "Abandon Ship")
            {
                alert = "abandon";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(1.5);
                return;
            }     
    }
    
    timer()
    {
        if (alert == "red")
        {
            Flash(Red,Red_Alert,TRUE);
        }
        
        if (alert == "orange")
        {
            Flash(Orange,Orange_Alert,TRUE);
        }
        
        if (alert == "yellow")
        {
            Flash(Yellow,Yellow_Alert,FALSE);
        }
        
        if (alert == "blue")
        {
            Flash(Blue,Blue_Alert,TRUE);
        }
        
         if (alert == "grey")
        {
            Flash(Grey,Grey_Alert,FALSE);//no sound for grey alert saves power
        }
        
        if (alert == "abandon")
        {
            Flash(Red,Abandon_Ship,TRUE);
        }
        
        else if (alert == "none")
        {
            llSetLinkColor(LINK_THIS,<0.1,0.1,0.1>, ALL_SIDES);
        }
    }
    
   
}
