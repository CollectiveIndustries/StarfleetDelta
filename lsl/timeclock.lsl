integer on;
integer running = FALSE;

//Faces Selection
key DisplayFace = "edea3d68-df2e-96dc-75a3-b12ab9e02563";



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
            on = FALSE;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, 1, DisplayFace, <1.05, 1.05, 0>, <0,0,0>, 0.0]);
        }
        else
        {
			running = TRUE;
            on = TRUE;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, 1, DisplayFace, <1,1,0>, <0,0,0>, 0.0]);
        }
    }
}
