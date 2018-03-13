//string object2 = "Warp Preloader"; // Name of object in inventory
string object = "Warp Animation"; // Name of object in inventory
vector relativePosOffset = <0.0, 0.0, -2.0>; // "Forward" and a little "above" this prim
vector relativeVel = <0.0, 0.0, 0.0>; // Traveling in this prim's "forward" direction at 1m/s
rotation relativeRot = <180.0, 180.0, 180.0, 180.0>; // Rotated 90 degrees on the x-axis compared to this prim
integer startParam = 10;

integer debug = FALSE;

init()
{
    llListen(-16, "", "", "");
{ 
    
  }
}

default
{
    changed(integer mask)
    {
      if (mask & CHANGED_OWNER)
    {
      llResetScript();
    }
}
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
        llResetScript();
    }
    attach(key attached)
    {
        init();
}  
    listen(integer channel, string name, key id, string message)
    {
        if (message == "+warp")
    {
        vector myPos = llGetPos();
        rotation myRot = llGetRot();
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
        //llRezObject(object2, rezPos, rezVel, rezRot, startParam);
        llRezObject(object, rezPos, rezVel, rezRot, startParam); 
        }
    }   
   
}