integer on;
integer running = FALSE;

//Faces Selection
key DisplayFace = "edea3d68-df2e-96dc-75a3-b12ab9e02563";



default
{
    state_entry()
    {
        //  llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        if(running)
        {
            llSetTimerEvent(0.0);
            running = FALSE;
            on = FALSE;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_COLOR, 2, <0,1,0>, 1, PRIM_TEXTURE, 1, DisplayFace, <1.05, 1.05, 0>, <0,0,0>, 0.0]);
        }
        else
        {
            llSetTimerEvent(0.5);
            running = TRUE;
            on = TRUE;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEXTURE, 1, "34661b45-fcea-9900-34de-06ac5678b252", <1,1,0>, <0,0,0>, 0.0]);
        }
    }
    timer()
    {
        if(on)
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_COLOR, 2, <0,0,0>, 1]);
            on = FALSE;
        }
        else
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [
                PRIM_COLOR, 2, <1,0,0>, 1]);
            on = TRUE;
        }
    }
}
