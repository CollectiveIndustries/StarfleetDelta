/*
HTTP_menu.lsl
Program designed to function as an http menu to allow for avatars on SL/OSG to interact with the Acedemic classroom for UFGQ
    Copyright (C) 2016  Andrew Malone

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// User configurable variables.
float MEMU_TIMEOUT = 30.0; //Time in Seconds for Menu System to time out and reset
string DISPLAY_NAME = "Course List";

// Variable Init
string COURSE_PAGE = "http://ci-main.no-ip.org/class.php";
list POST_PARAMS = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
key CLASS = "";
key USER = ""; //Global variable for the USER Key we will need this for other sections of the script
string HTTP_ERROR = "An unexpected error occured while attempting to read Academy Courses. Please visit https://github.com/CollectiveIndustries/UFGQ/issues to submit bug reports or checkup on known issues.\n\n";

integer CourseNumber = 0; //Sets the CourseNumber for table lookups later on in the script
integer LINE_TOTAL = 0;
integer COURSE_INDEX = 1;

integer MenuChan;
integer MenuListen;
integer menuindex = 0;
list TopLevelMenu = [];
string FormSection = "menu";

// API For additional objects (Texture board, Lights, Particle Effects, Sounds)
integer API_CHANNEL;

// Function declarations

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

DialogPlus(key avatar, string message, list buttons, integer channel, integer CurMenu)
{
    if (12 < llGetListLength(buttons))
    {
        list lbut = buttons;
        list Nbuttons = [];
        if(CurMenu == -1)
        {
            CurMenu = 0;
            menuindex = 0;
        }

        if((Nbuttons = (llList2List(buttons, (CurMenu * 10), ((CurMenu * 10) + 9)) + ["Back", "Next"])) == ["Back", "Next"])
            DialogPlus(avatar, message, lbut, channel, menuindex = 0);
        else
            llDialog(avatar, message,  order_buttons(Nbuttons), channel);
    }
    else
        llDialog(avatar, message,  order_buttons(buttons), channel);
}

// Return Text to reflect the button names with there discriptions
string StridedMenuText(list items)
{
    integer index = 0;
    string ReturnString = "";
    integer total = llGetListLength(items);
    while(index < total)
    {
        ReturnString = ReturnString + llList2String(items,index)+": "+llList2String(items,index+1)+"\n";
        index = index + 2;
    }
    return ReturnString;
}

//Md5Checksum Encrypted channel hash
integer ID2Chan(string id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

ParseMenu(string text)
{
    if(llToLower(llList2String(llParseString2List(text,["|"],[""]),0)) == "div_menu")
    {
        if(llToLower(llList2String(llParseString2List(text,["|"],[""]),1)) == "error")
        {
            llSay(0,llList2String(llParseString2List(text,["|"],[""]),2));
            llResetScript();
        }
        TopLevelMenu = llParseString2List(text,["|"],[""]);
        TopLevelMenu = llDeleteSubList(TopLevelMenu, 0, 0); //remove the first entry [MENU]
        TopLevelMenu = llDeleteSubList(TopLevelMenu, -1, -1); //remove the Last entry [-EOF-]
        // Dialog menu goes here with the TopLevelMenu list for buttons Dialog channel will be User UUID Specific
        MenuChan = ID2Chan(USER);
        MenuListen = llListen(ID2Chan(USER), "", USER, "");
        DialogPlus(USER, "UFGQ Courses\n\n"+StridedMenuText(TopLevelMenu), llList2ListStrided(TopLevelMenu,0,-1,2), MenuChan, menuindex);//Returns only the DivIDs for the classes on the menu buttons
    }
    else if(llToLower(llList2String(llParseString2List(text,["|"],[""]),0)) == "class_menu")
    {
        if(llToLower(llList2String(llParseString2List(text,["|"],[""]),1)) == "error")
        {
            llSay(0,llList2String(llParseString2List(text,["|"],[""]),2));
            llResetScript();
        }
        TopLevelMenu = llParseString2List(text,["|"],[""]);
        TopLevelMenu = llDeleteSubList(TopLevelMenu, 0, 0); //remove the first entry [MENU]
        TopLevelMenu = llDeleteSubList(TopLevelMenu, -1, -1); //remove the Last entry [-EOF-]
        // Dialog menu goes here with the TopLevelMenu list for buttons Dialog channel will be User UUID Specific
        MenuChan = ID2Chan(USER);
        MenuListen = llListen(ID2Chan(USER), "", USER, "");
        TopLevelMenu = ["Return", "Main Menu"] + TopLevelMenu; //Add the main menu button to return
        DialogPlus(USER, "UFGQ Courses\n\n"+StridedMenuText(TopLevelMenu), llList2ListStrided(TopLevelMenu,0,-1,2), MenuChan, menuindex);//Returns only the DivIDs for the classes on the menu buttons
    }
    else if(llToLower(llList2String(llParseString2List(text,["|"],[""]),1)) == "error")
    {
        llSay(0,llList2String(llParseString2List(text,["|"],[""]),1));

    }
}

string SearchAndReplace(string input, string old, string new)
{
    return llDumpList2String(llParseStringKeepNulls((input = "") + input, [old], []), new);
}

// ParseText will Parse any <TEXT> tags and replace with proper values.

string ParseText(string txt)
{
    string returnTxt;
    returnTxt = SearchAndReplace(txt, "<INSTRUCTOR_NAME>", DISPLAY_NAME);
    if(returnTxt == "<LIGHTS_OFF>")
    {
        llRegionSay(ID2Chan(llMD5String(llGetObjectDesc(),0)),"Lights:Dim");
        returnTxt = SearchAndReplace(txt, "<LIGHTS_OFF>", "*"+DISPLAY_NAME+" dims the lights*");
    }
    else if (returnTxt == "<LIGHTS_ON>")
    {
        llRegionSay(ID2Chan(llMD5String(llGetObjectDesc(),0)),"Lights:Bright");
        returnTxt = SearchAndReplace(txt, "<LIGHTS_ON>", "*"+DISPLAY_NAME+" turns the lights on*");
    }
    return returnTxt;
}

// Main entry Point //
default
{
    timer()
    {
        llListenRemove(MenuListen);
        llSetTimerEvent(0.0);
    }

    state_entry()
    {
        // Reset the Texture to display correctly accros the academic network and then send the All Clear status
        // to the inworld class room handler
        llRegionSay(ID2Chan(llMD5String(llGetObjectDesc(),0)),"Texture:4b45fb27-cf2e-1914-f513-bffddb952d46");
        llRegionSay(ID2Chan(llMD5String(llGetObjectDesc(),0)),"Status:Available");
        llSetObjectName("Course List");
        llSetText("",<0,1,0>,1.0);
        llSay(0, "INIT: Systems starting");
    }

    http_response(key req ,integer stat, list met, string body)
    {
        if( req == CLASS ) //Response was from the TimeClock
        {
            //llSay(0,body);
            if(stat == 200 && FormSection == "menu")
            {
                llSetTimerEvent(MEMU_TIMEOUT);
                ParseMenu(body);
            }
            else if(stat == 200 && FormSection == "div")
            {
                llSetTimerEvent(MEMU_TIMEOUT);
                ParseMenu(body);
            }
            else if(stat == 200 && FormSection == "class")
            {
                state class;
            }
            else
                llSay(0,"Defualt State Error:\n\n"+HTTP_ERROR+"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        //llSay(0,msg);
        // If they clicked Next it will go to the next dialog window
        if(msg == "Next")
        {
            // ++menuindex will turn menuindex plus 1, making it give the next page.
            DialogPlus(USER, "UFGQ Class Listing\n\n"+StridedMenuText(TopLevelMenu), llList2ListStrided(TopLevelMenu,0,-1,2), MenuChan, ++menuindex);//Returns only the DivIDs for the classes on the menu buttons
        }
        // if they clicked back it will go to the last dialog window.
        else if(msg == "Back")
        {
            DialogPlus(USER, "UFGQ Class Listing\n\n"+StridedMenuText(TopLevelMenu), llList2ListStrided(TopLevelMenu,0,-1,2), MenuChan, --menuindex);//Returns only the DivIDs for the classes on the menu buttons
            // --menuindex will turn menuindex minus 1, making it give the previous page.
        }
        else if (msg == "Return")
        {
            FormSection = "menu";
            CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=menu&uuid="+(string)USER);//Ask for the main menu again
            jump end;
        }
        // If they choose anything besides Back/Next it will be in this section
        else if(FormSection == "menu")
        {
            // Be Safe
            FormSection = "div";
            llListenRemove(MenuListen);
            menuindex=0; //Reset the Menu Index Value to 0 to start at the begining again
            CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch="+FormSection+"&class_id="+msg);//Respond back to the website with the ClassID so we can get the class listing
            jump end;
        }
        else if(FormSection == "div")
        {
            CourseNumber = (integer)msg;
            FormSection = "class";
            llListenRemove(MenuListen);
            menuindex=0; //Reset the Menu Index Value to 0 to start at the begining again
            CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch="+FormSection+"&course_id="+msg);//Respond back to the website with the CourseID so we can get the class listing
            jump end;
        }
        @end;
    }

    touch_start(integer total_number)
    {
        integer face = llDetectedTouchFace(0);
        USER = llDetectedKey(0);
        if (face == TOUCH_INVALID_FACE)
            llInstantMessage(USER, "Sorry, your viewer doesn't support touched faces. In order to clock in you may need to upgrade your browser or contact your Department head to keep track of your hours.");
        else
        {
            USER = llDetectedKey(0);
            CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch="+FormSection+"&uuid="+(string)USER);//grab the menu then we will parse the results offer to the user then branch to the div classes menu
        }
    }
}


state class
{
    state_entry()
    {
        llListenRemove(MenuListen);
        API_CHANNEL = ID2Chan(llMD5String(llGetObjectDesc(),0)); //Init the API Channel
        llRegionSay(ID2Chan(llMD5String(llGetObjectDesc(),0)),"Status:In_Use");
        llSetText("Class In Progress",<0,1,0>,1.0);
        FormSection = "class_init";
        CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=class_init&course_id="+(string)CourseNumber+"&uuid="+(string)USER);//Respond back to the website with the class_init key to tell MySQL we need the total lines for the class
    }

    http_response(key req ,integer stat, list met, string body)
    {
        //llSay(0,body);
        if( req == CLASS ) //Response was from the WebPage
        {
            list temp = llParseString2List(body,["|"],[""]);
            if(stat == 200 && FormSection == "class_init")
            {
                if(llToLower(llList2String(temp,0)) == "rank_name")
                {
                    DISPLAY_NAME = llList2String(temp,1)+" "+llList2String(temp,2);
                    llSetObjectName(":");
                    FormSection = "class_running";
                    LINE_TOTAL = llList2Integer(temp,4);
                    CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=class_running&course_id="+(string)CourseNumber+"&course_line="+(string)COURSE_INDEX);
                }
                else if(llToLower(llList2String(temp,0)) == "error")
                {
                    llSay(0,llList2String(temp,1));
                    llResetScript();
                }
                //Respond back to the website with the class_init key to tell MySQL we need the total lines for the class
            }
            else if(stat == 200 && FormSection == "class_running" && COURSE_INDEX < (LINE_TOTAL+1))
            {
                if(llToLower(llList2String(temp,0)) == "line")
                {
                    if(llToLower(llList2String(temp,1)) == "asset") //Asset found, Transfer to the Asset Handlers
                    {
                        //llSay(0,"API_CHANNEL = "+(string)API_CHANNEL+" MESSAGE = "+(string)llList2String(temp,2));
                        llRegionSay(API_CHANNEL,llList2String(temp,2));
                    }
                    else //Normal Non Asset Line, place in local channel
                    {
                        llSay(0,ParseText(llList2String(temp,1)));
                    }
                    COURSE_INDEX = COURSE_INDEX + 1;
                    llSleep(10.0);
                    CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=class_running&course_id="+(string)CourseNumber+"&course_line="+(string)COURSE_INDEX);
                }
                else if(llToLower(llList2String(temp,0)) == "error")
                {
                    llSay(0,llList2String(temp,1));
                    llResetScript();
                }
            }
            else if(stat == 200 && llToLower(llList2String(temp,0)) == "error")
            {
                llSay(0,llList2String(temp,1));
                llResetScript();
            }
            else
            {
                llSay(0,"Class State Error:\n\n"+HTTP_ERROR+"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
                llResetScript();
            }
        }
    }
}
