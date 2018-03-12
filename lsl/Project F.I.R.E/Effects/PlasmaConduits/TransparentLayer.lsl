default
{
    // state_entry() is an event handler, it executes
    // whenever a state is entered.
    state_entry()
    {   
        // llSetTextureAnim() is a function that animates a texture on a face.
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,1,1,1.0, 1,0.05);
                            // animate the script to scroll across all the faces.
    }
    link_message(integer link_num,integer num,string msg,key id)
    {
        if(msg == "WARP")
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,1,1,1.0, 1,1.05);
        }
        else if(msg == "IMPULSE")
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,1,1,1.0, 1,0.05);
        }
    }
 
    
}
 