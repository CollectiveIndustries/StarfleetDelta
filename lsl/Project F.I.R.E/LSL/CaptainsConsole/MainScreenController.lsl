integer DISPLAY_ON_SIDE = 5;
list gLMs;
integer gNumLMs;
key gItemKey;
key BLANK = "";
integer PICTURE_BRIGHT = TRUE;
integer chan = 0001;
integer gStride = 9;
integer gPos = 0;
integer gChann;
integer mode = 0;
integer startParam = 10;
integer current_texture = 0;
string texture;

display_texture(integer check)  //Display texture and set name in description (picture mode)
{                               //"Check" holds the number of textures in contents. The function uses "current_texture" to display.
    string name = llGetInventoryName(INVENTORY_TEXTURE,current_texture);
    llSetTexture(name,DISPLAY_ON_SIDE);
}

off()
{
    llSetPrimitiveParams([PRIM_BUMP_SHINY, DISPLAY_ON_SIDE, PRIM_SHINY_LOW, PRIM_BUMP_NONE, PRIM_COLOR, DISPLAY_ON_SIDE, <0.1,0.1,0.1>, 1.0,PRIM_MATERIAL, PRIM_MATERIAL_PLASTIC, PRIM_FULLBRIGHT, DISPLAY_ON_SIDE, FALSE, PRIM_TEXTURE, DISPLAY_ON_SIDE, BLANK, llGetTextureScale(DISPLAY_ON_SIDE), llGetTextureOffset(DISPLAY_ON_SIDE), llGetTextureRot(DISPLAY_ON_SIDE)]);

}

on()
{
    llSetPrimitiveParams([PRIM_BUMP_SHINY, DISPLAY_ON_SIDE, PRIM_SHINY_NONE, PRIM_BUMP_NONE, PRIM_COLOR, DISPLAY_ON_SIDE, <1,1,1>, 1.0, PRIM_MATERIAL, PRIM_MATERIAL_PLASTIC, PRIM_FULLBRIGHT, DISPLAY_ON_SIDE, PICTURE_BRIGHT]);
    integer check = llGetInventoryNumber(INVENTORY_TEXTURE);

    if(check == 0)
    {
        llSetTexture(BLANK,DISPLAY_ON_SIDE);
        return;
    }
    else
        if(current_texture > check)
            //Set to first texture if available
            current_texture = 0;

    display_texture(current_texture);
}

dialog(key id)
{
    integer nTop = gPos + gStride;
    list  buttons=llList2List(gLMs, gPos, nTop);
{ buttons += ["Scenarios"];
    }
{ buttons += ["Tactical"];
    }
{ buttons += ["Helm"];
    }
{ buttons += ["Viewscreen"];
    }
{ buttons += ["Conditions"];
    }
{ buttons += ["Power"];
    }
    llDialog(id,
        "Empty Console:", buttons, gChann);
}

default
{
    changed(integer mask)
    {
        if (mask & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
    on_rez(integer params){llResetScript();}//end onrez
    state_entry()
    {
        gChann=(integer)llFrand(3223);
        llListen(gChann,"","","");
        llListen(0001,"","","");
    }

    touch_start(integer total_number)
    {
        key toucher = llDetectedKey(0);
        gPos = 0;
        gStride = 9;
        dialog(toucher);
    }

    listen(integer channel, string name, key id, string msg)
    {
        integer found_index = llListFindList(gLMs,[msg]);

        if (msg == "Tactical")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Report"];
            }
        { buttons += ["Sensors"];
            }
        { buttons += ["Sheilds"];
            }
        { buttons += ["Weapons"];
            }
        { buttons += ["Power"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Weapons")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Photon"];
            }
            //{ buttons += ["- Warp"];
            //}
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if(msg == "Photon")
        {
            llShout(1213, "Preload Expl1");
            llShout(1213, "Preload Photon");
            llSleep(1);
            llPlaySound("D_Photon Torp",2);
            llShout(18, "fire!");
            llSleep(3);
            llShout(1912151, "tractor die");
        }

        if (msg == "Power")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power on"];
            }
        { buttons += ["Power off"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Conditions")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Red Alert"];
            }
        { buttons += ["Green Alert"];
            }
        { buttons += ["Blue Alert"];
            }
        { buttons += ["Yellow Alert"];
            }
        { buttons += ["Stand Down"];
            }
        { buttons += ["Offline"];
            }
        { buttons += ["Online"];
            }
        { buttons += ["Abandon Ship"];
            }
        { buttons += ["Mute Alert"];
            }
        { buttons += ["Unmute Alert"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Viewscreen")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Space"];
            }
        { buttons += ["Species"];
            }
        { buttons += ["Ships"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Species")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Romulans"];
            }
        { buttons += ["Klingons"];
            }
        { buttons += ["The Borg"];
            }
        { buttons += ["Federation"];
            }
        { buttons += ["Ferengi"];
            }
        { buttons += ["Planets"];
            }
        { buttons += ["Vulcan"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Space")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Black Hole"];
            }
        { buttons += ["Deep Space"];
            }
        { buttons += ["Shock Wave"];
            }
        { buttons += ["Wave Anomaly"];
            }
        { buttons += ["Asteroids"];
            }
        { buttons += ["Space-Stars"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Romulans")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Romulan Captain"];
            }
        { buttons += ["Romulan ship"];
            }
        { buttons += ["Rom specs"];
            }
        { buttons += ["Rom damaged"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "The Borg")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Borg Battle"];
            }
        { buttons += ["Borg Cube"];
            }
        { buttons += ["Nanites"];
            }
        { buttons += ["Borg Queen"];
            }
        { buttons += ["Cube Debris"];
            }
        { buttons += ["Borg Space"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Klingons")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Bird of Prey"];
            }
        { buttons += ["BOP damaged"];
            }
        { buttons += ["BOP specs"];
            }
        { buttons += ["Wild Klingon"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Federation")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Admiral Strickler"];
            }
        { buttons += ["Fed Logo"];
            }
        { buttons += ["Starbase"];
            }
        { buttons += ["Starbase 12"];
            }
        { buttons += ["Warp Speed"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Ferengi")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Ferengi Captain"];
            }
        { buttons += ["FerengiMarauder"];
            }
        { buttons += ["Marauder Attacks"];
            }
        { buttons += ["Marauder damaged"];
            }
        { buttons += ["Quark"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Planets")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["DemonClass"];
            }
        { buttons += ["Klingon Homeworld"];
            }
        { buttons += ["M Class"];
            }
        { buttons += ["PlanetVulcan"];
            }
        { buttons += ["Utopia Shipyard"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Ships")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Alien Probe"];
            }
        { buttons += ["Breen Ship"];
            }
        { buttons += ["NCC1701"];
            }
        { buttons += ["Tellarite Ship"];
            }
        { buttons += ["Voyager damaged"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Vulcan")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["D Kur"];
            }
        { buttons += ["Sarek"];
            }
        { buttons += ["Vulcan Ruins"];
            }
        { buttons += ["VulcanCaptain"];
            }
        { buttons += ["VulcHighCom"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }
        else if (msg == "Black Hole") {
            llShout(881213, "Black Hole");
        }
        else if (msg == "Deep Space") {
            llShout(881213, "Deep Space");
        }
        else if (msg == "Shock Wave") {
            llShout(881213, "Shock Wave");
        }
        else if (msg == "Wave Anomaly") {
            llShout(881213, "Wave Anomaly");
        }
        else if (msg == "Romulan Captain") {
            llShout(881213, "Romulan Captain");
        }
        else if (msg == "Romulan ship") {
            llShout(881213, "Romulan ship");
        }
        else if (msg == "Rom specs") {
            llShout(881213, "Rom specs");
        }
        else if (msg == "3 Klingons") {
            llShout(881213, "3 Klingons");
        }
        else if (msg == "Bird of Prey") {
            llShout(881213, "Bird of Prey");
        }
        else if (msg == "BOP damaged") {
            llShout(881213, "BOP damaged");
        }
        else if (msg == "BOP specs") {
            llShout(881213, "BOP specs");
        }
        else if (msg == "Wild Klingon") {
            llShout(881213, "Wild Klingon");
        }
        else if (msg == "Borg Battle") {
            llShout(881213, "Borg Battle");
        }
        else if (msg == "Borg Cube") {
            llShout(881213, "Borg Cube");
        }
        else if (msg == "Nanites") {
            llShout(881213, "Nanites");
        }
        else if (msg == "Borg Queen") {
            llShout(881213, "Borg Queen");
        }
        else if (msg == "Cube Debris") {
            llShout(881213, "Cube Debris");
        }
        else if (msg == "Borg Space") {
            llShout(881213, "Borg Space");
        }
        else if (msg == "Asteroids") {
            llShout(881213, "Asteroids");
        }
        else if (msg == "Space-Stars") {
            llShout(881213, "Space-Stars");
        }
        else if (msg == "Rom damaged") {
            llShout(881213, "Rom damaged");
        }
        else if (msg == "Admiral Strickler") {
            llShout(881213, "Admiral Strickler");
        }
        else if (msg == "Fed Logo") {
            llShout(881213, "Fed Logo");
        }
        else if (msg == "Starbase") {
            llShout(881213, "Starbase");
        }
        else if (msg == "Starbase 12") {
            llShout(881213, "Starbase 12");
        }
        else if (msg == "Warp Speed") {
            llShout(881213, "Warp Speed");
        }
        else if (msg == "Ferengi Captain") {
            llShout(881213, "Ferengi Captain");
        }
        else if (msg == "FerengiMarauder") {
            llShout(881213, "FerengiMarauder");
        }
        else if (msg == "Marauder Attacks") {
            llShout(881213, "Marauder Attacks");
        }
        else if (msg == "Marauder damaged") {
            llShout(881213, "Marauder damaged");
        }
        else if (msg == "Quark") {
            llShout(881213, "Quark");
        }
        else if (msg == "DemonClass") {
            llShout(881213, "DemonClass");
        }
        else if (msg == "Earth") {
            llShout(881213, "Earth");
        }
        else if (msg == "Klingon Homeworld") {
            llShout(881213, "Klingon Homeworld");
        }
        else if (msg == "M Class") {
            llShout(881213, "M Class");
        }
        else if (msg == "PlanetVulcan") {
            llShout(881213, "PlanetVulcan");
        }
        else if (msg == "Utopia Shipyard") {
            llShout(881213, "Utopia Shipyard");
        }
        else if (msg == "Alien Probe") {
            llShout(881213, "Alien Probe");
        }
        else if (msg == "Breen Ship") {
            llShout(881213, "Breen Ship");
        }
        else if (msg == "NCC1701") {
            llShout(881213, "NCC1701");
        }
        else if (msg == "Tellarite Ship") {
            llShout(881213, "Tellarite Ship");
        }
        else if (msg == "Voyager damaged") {
            llShout(881213, "Voyager damaged");
        }
        else if (msg == "D Kur") {
            llShout(881213, "D Kur");
        }
        else if (msg == "Sarek") {
            llShout(881213, "Sarek");
        }
        else if (msg == "Vulcan Ruins") {
            llShout(881213, "Vulcan Ruins");
        }
        else if (msg == "VulcanCaptain") {
            llShout(881213, "VulcanCaptain");
        }
        else if (msg == "VulcHighCom") {
            llShout(881213, "VulcHighCom");
        }

        else if(msg == "Red Alert")
        {
            llShout(08, "red alert");
        }
        else if(msg == "Stand Down")
        {
            llShout(08, "stand down");
        }
        else if(msg == "Blue Alert")
        {
            llShout(08, "blue alert");
        }
        else if(msg == "Yellow Alert")
        {
            llShout(08, "yellow alert");
        }
        else if(msg == "Offline")
        {
            llShout(08, "offline");
        }
        else if(msg == "Online")
        {
            llShout(08, "online");
        }
        else if(msg == "Abandon Ship")
        {
            llShout(08, "abandon ship");
        }
        else if(msg == "Green Alert")
        {
            llShout(08, "condition green");
        }
        else if(msg == "Mute Alert")
        {
            llShout(08, "computer mute alert");
        }
        else if(msg == "Unmute Alert")
        {
            llShout(08, "computer mute alert");
        }

        if (msg == "Scenarios")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Borg"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Borg")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Power off"];
            }
        { buttons += ["Borg S1"];
            }
        { buttons += ["Borg S2"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Helm")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Report"];
            }
        { buttons += ["Hail"];
            }
        { buttons += ["Set Course"];
            }
        { buttons += ["Impulse"];
            }
        { buttons += ["Warp"];
            }
        { buttons += ["Orbit Planet"];
            }
        { buttons += ["Intercept"];
            }
        { buttons += ["All Stop"];
            }
        { buttons += ["Dock"];
            }
        { buttons += ["Power"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Warp")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["+ Warp"];
            }
        { buttons += ["- Warp"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        /////////////*************scenarios*************
        if (msg == "Borg S1")
        {
            
        }
        /////////////*************scenarios*************
        if (msg == "Borg S2")
        {
            llShout(881213, "NCC1701");
            llRegionSay(4050, "red alert");
            llRegionSay(4050, "computer mute alert");
            llShout(1213, "Borg Damage");
            llSleep(1);
            llPlaySound("borg torp",2);
            llShout(18, "fire!");
            llSleep(2);
            llPlaySound("explo1",2);
            llRegionSay(4052, "shake");
            llRegionSay(-25,"DAMAGE");
            llSleep(1);
            llShout(1213, "Borg Damage");
            llSleep(1);
            llPlaySound("borg torp",2);
            llShout(18, "fire!");
            llSleep(2);
            llPlaySound("explo1",2);
            llRegionSay(4052, "shake");
            llRegionSay(-25,"DAMAGE");
            llSleep(10);
            llRegionSay(-25,"REPAIR");
            //llShout(1213, "borg tractor");
        }
        /////////////***********************************

        if (msg == "Power on")
        {
            on();
            //llSay(0, "Online.");
        }

        if (msg == "Power off")
        {
            off();
            //llSay(0, "Offline.");
        }

        if (msg == "Report")
        {
            //llSay(0, "Operational.");
        }

        if (msg == "+ Warp")
        {
            llPlaySound("D_EWarp",1);
            llSay(0, "-preload");
            llSay(0, "+warp");
        }

        if (msg == "- Warp")
        {
            llPlaySound("D_exitwarp",1);
            llSay(0, "-warp");
            llSay(0, "-preload");
        }

        if (msg == "AV Sensor")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["Sensor Off"];
            }
        { buttons += ["Sensor On"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "FPS Sensor")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["FPS Off"];
            }
        { buttons += ["FPS On"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "Move Lock")
        {
            integer nTop = gPos + gStride;
            list  buttons=llList2List(gLMs, gPos, nTop);
        { buttons += ["ML On"];
            }
        { buttons += ["ML Off"];
            }
            llDialog(id,
                "Select the following settings:", buttons, gChann);
        }

        if (msg == "ML On")
        {
            llSay(03113, "ML On");
        }

        if (msg == "ML Off")
        {
            llSay(03113, "ML Off");
            llOwnerSay("Move Lock Off.");
        }

        if (msg == "Sensor Off")
        {
            llSay(03113, "Sensor Off");
        }

        if (msg == "Sensor On")
        {
            llSay(03113, "Sensor On");
        }

        if (msg == "FPS Off")
        {
            llSay(03113, "FPS Off");
        }

        if (msg == "FPS On")
        {
            llSay(03113, "FPS On");
        }

        if (msg == "2")
        {

        }

        if (msg == "3")
        {

        }

        if (msg == "4")
        {

        }

        if (msg == "5")
        {

        }

        if (msg == "6")
        {

        }

        if (msg == "7")
        {

        }

    }//end listen
}