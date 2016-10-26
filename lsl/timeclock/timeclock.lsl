/*
timeclock.lsl
Program designed to function as a timeclock to allow for avatars on SL/OSG to clock into and out of UFGQ
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
vector LogoScale = <1.05, 1.05, 0>; //Scale is only an X/Y value


// Variable Init
integer s1l; // calculated from profile_key_prefix in state_entry()
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
key USER = "";
key ClockReq = ""; // Clock request HTTP Key
integer PROFILE_FACE = 1; // Profile display face
key StandByLogo = "ef9fc11a-fc5e-bef6-2934-88ea97529ff8"; // Defualt texture when in standby mode
integer LIGHT_FACE = 2; // Light Face
integer CONSOLE_FACE = 3;// Console Face
list StandbyParams = [PRIM_TEXTURE, PROFILE_FACE, StandByLogo, LogoScale, <0,0,0>, 0.0];
string CLOCK_PAGE = "http://ci-main.no-ip.org/clock.php";

// Function declarations

key ProfilePicReq = "";
GetProfilePic(key id) //Run the HTTP Request then set the texture
{
    string URL_RESIDENT = "http://world.secondlife.com/resident/";
    ProfilePicReq = llHTTPRequest( URL_RESIDENT + (string)id,[HTTP_METHOD,"GET"],"");
}


//   Faces Selection   ///


default
{
	state_entry()
	{
		s1l = llStringLength(profile_key_prefix);
		llSay(0, "INIT: Systems starting");
		llSetLinkPrimitiveParamsFast(LINK_THIS, StandbyParams);
	}

	http_response(key req ,integer stat, list met, string body)
	{
		//llSay(0,"REQ: "+(string)req+"\nSTAT: "+(string)stat);
		if(req == ProfilePicReq) //response is from the Profile picture request
		{
			integer s1 = llSubStringIndex(body,profile_key_prefix);
			if(s1 == -1)
			{
				llSetLinkPrimitiveParamsFast(LINK_THIS, StandbyParams);
			}
			else
			{
				s1 += s1l;
				key UUID=llGetSubString(body, s1, s1 + 35);
				if (UUID == NULL_KEY) // UUID is NULL set defualt screen
				{
					llSetLinkPrimitiveParamsFast(LINK_THIS, StandbyParams);
				}
				else //UUID is valid set profile picture
				{
					llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, UUID, <1.0, 1.0, 0.0>, <0,0,0>, 0.0]);
					llSleep(5.0);  // Reset Display face after 5 seconds
					llSetLinkPrimitiveParamsFast(LINK_THIS, StandbyParams);
				}
			}
		}
		else if( req == ClockReq ) //Response was from the TimeClock
		{
			if(stat == 200)
			{
				llInstantMessage(USER,"You have been clocked into UFGQ. Please remmeber to clock out at the end of your shift. If for any reason you are offline for more then 5 minutes the system will automatically clock you out.");
				USER = "";
			}
			else
				llSay(0,"An unexpected error occured while attempting to clock user in/out. Please visit https://github.com/CollectiveIndustries/UFGQ/issues to submit bug reports or checkup on known issues.\nSTAT: "+(string)stat+"\nRES: "+(string)body);
		}
	}

	touch_start(integer total_number)
	{
		integer link = llDetectedLinkNumber(0);
		integer face = llDetectedTouchFace(0);
 
		if (face == TOUCH_INVALID_FACE)
			llSay(0, "Sorry, your viewer doesn't support touched faces.");
		else if(face == CONSOLE_FACE ) // Not invalid Log user in IF they touched the proper face
		{
			USER = llDetectedKey(0);
			GetProfilePic(USER);
			llInstantMessage(USER,"System is processing your request. Another IM will be sent once the system has registered you clocking in/out.");
			ClockReq = llHTTPRequest(CLOCK_PAGE, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "uuid="+(string)USER);
		}
	}
}
