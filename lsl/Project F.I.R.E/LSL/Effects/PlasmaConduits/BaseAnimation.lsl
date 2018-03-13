default 
{ 
    state_entry() 
    { 
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,0.0, 90,0.40);
    } 
    link_message(integer link_num,integer num,string msg,key id)
    {
        if(msg == "WARP")
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,0.0, 90,1.40);
        }
        else if(msg == "IMPULSE")
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,0.0, 90,0.40);
        }
    }
} 
