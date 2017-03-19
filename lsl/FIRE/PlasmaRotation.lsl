default
{
    
    
    state_entry()
    {   
        
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,1.0, 1,0.05);
                            
    }
    link_message(integer link_num,integer num,string msg,key id)
    {
        if(msg == "WARP")
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,1.0, 1,1.05);
        }
        else if(msg == "IMPULSE")
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,1.0, 1,0.05);
        }
    }
 
    
}