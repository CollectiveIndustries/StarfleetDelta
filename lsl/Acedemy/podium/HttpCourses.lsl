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
string COURSE_PAGE = "http://ci-main.no-ip.org/class.php";


// Variable Init
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

//UUID Based Channel
integer ID2Chan(key id)
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
		DialogPlus(USER, "UFGQ Courses\n\n"+StridedMenuText(TopLevelMenu), llList2ListStrided(TopLevelMenu,0,-1,2), MenuChan, menuindex);//Returns only the DivIDs for the classes on the menu buttons
	}
	else if(llToLower(llList2String(llParseString2List(text,["|"],[""]),1)) == "error")
	{
		llSay(0,llList2String(llParseString2List(text,["|"],[""]),1));
		
	}
}


// Main entry Point //
default
{
    state_entry()
    {
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
                ParseMenu(body);
            }
            else if(stat == 200 && FormSection == "div")
			{
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
		llSetText("Class In Progress",<0,1,0>,1.0);
		FormSection = "class_init";
		CLASS = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=class_init&course_id="+(string)CourseNumber+"&uuid="+(string)USER);//Respond back to the website with the class_init key to tell MySQL we need the total lines for the class
	}
	http_response(key req ,integer stat, list met, string body)
    {
        if( req == CLASS ) //Response was from the TimeClock
        {
			list temp = llParseString2List(body,["|"],[""]);
            if(stat == 200 && FormSection == "class_init")
            {
				if(llToLower(llList2String(temp,0)) == "rank_name")
				{
					llSetObjectName(llList2String(temp,1)+" "+llList2String(temp,2));
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
					llSay(0,llList2String(temp,1));
					COURSE_INDEX = COURSE_INDEX + 1;
					llSleep(3.0);
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
                llSay(0,"Class State Error:\n\n"+HTTP_ERROR+"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
        }
    }
}