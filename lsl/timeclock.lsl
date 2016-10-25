integer running = FALSE;

//   Faces Selection   ///

// Profile display face
integer PROFILE_FACE = 1;
key DisplayFace = "edea3d68-df2e-96dc-75a3-b12ab9e02563";

// Light Face
integer LIGHT_FACE = 2;

// Console Face
integer CONSOLE_FACE = 3;


default
{
    state_entry()
    {

    }

    touch_start(integer total_number)
    {
        if(running)
        {
            running = FALSE;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0, 1.0, 1.0>, <0,0,0>, 0.0]);
        }
        else
        {
		running = TRUE;
		llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, PROFILE_FACE, DisplayFace, <1.0,1.0,1.0>, <0,0,0>, 0.0]);
        }
    }
}
