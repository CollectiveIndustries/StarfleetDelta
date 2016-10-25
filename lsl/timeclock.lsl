
// Variable Init
integer s1l; // calculated from profile_key_prefix in state_entry()
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
key USER = "";

	// Clock request HTTP Key
key ClockReq = "";

// Function declerations

key ProfilePicReq = "";
GetProfilePic(key id) //Run the HTTP Request then set the texture
{
    string URL_RESIDENT = "http://world.secondlife.com/resident/";
    ProfilePicReq = llHTTPRequest( URL_RESIDENT + (string)id,[HTTP_METHOD,"GET"],"");
}


//   Faces Selection   ///

// Profile display face
integer PROFILE_FACE = 1;
key DisplayFace = "edea3d68-df2e-96dc-75a3-b12ab9e02563"; // UUID of Avatar that logged in

// Light Face
integer LIGHT_FACE = 2;

// Console Face
integer CONSOLE_FACE = 3;

default
{
	state_entry()
	{
		s1l = llStringLength(profile_key_prefix);
		llSay(0, "INIT: Systems starting");
		llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
	}

	http_response(key req ,integer stat, list met, string body)
	{
		if(req == ProfilePicReq) //response is from the Profile picture request
		{
			integer s1 = llSubStringIndex(body,profile_key_prefix);
			if(s1 == -1)
			{
				llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
			}
			else
			{
				s1 += s1l;
				key UUID=llGetSubString(body, s1, s1 + 35);
				if (UUID == NULL_KEY) // UUID is NULL set defualt screen
				{
					llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
				}
				else //UUID is valid set profile picture
				{
					llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, UUID, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
					llSleep(5.0);  // Reset Display face after 5 seconds
					llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
				}
			}
		}
		else if( req == ClockReq ) //Response was from the TimeClock
		{
			llSay(0,"Login request");
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
			// Set up PHP post here for Database time log
			USER = "";
		}
	}
}