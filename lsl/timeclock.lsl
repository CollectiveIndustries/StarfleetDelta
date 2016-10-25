// Function declerations

GetProfilePic(key id) //Run the HTTP Request then set the texture
{
    string URL_RESIDENT = "http://world.secondlife.com/resident/";
    llHTTPRequest( URL_RESIDENT + (string)id,[HTTP_METHOD,"GET"],"");
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
		llSay(PUBLIC_CHANNEL, "INIT: Systems starting");
	}

	http_response(key req,integer stat, list met, string body)
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
		}
		if (UUID == NULL_KEY)
		{
			llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
		}
		else
		{
			llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, UUID, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
		}
	}

	touch_start(integer total_number)
	{
		integer link = llDetectedLinkNumber(0);
		integer face = llDetectedTouchFace(0);
 
		if (face == TOUCH_INVALID_FACE)
			llSay(PUBLIC_CHANNEL, "Sorry, your viewer doesn't support touched faces.");
		else if(face == CONSOLE_FACE ) // Not invalid Log user in IF they touched the proper face
		{
			GetProfilePic(llDetectedKey(0));
		}
	}
}
