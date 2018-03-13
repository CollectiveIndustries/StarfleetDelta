string object = "Impulse Screen"; // Name of object in inventory
vector relativePosOffset = <-0.1, 0.0, -2.0>; // "Forward" and a little "above" this prim
vector relativeVel = <16.0, 0.0, 0.0>; // Traveling in this prim's "forward" direction at 1m/s
rotation relativeRot = <5.0, 0.0, 5.0, 0.0>; // Rotated 90 degrees on the x-axis compared to this prim
integer startParam = 10;

integer debug = FALSE;

default
{
changed(integer mask)
    {
      if (mask & CHANGED_OWNER)
    {
      llResetScript();
    }
}
   state_entry() {
        llListen(12139,"","", "");
    }

    listen(integer channel, string name, key id, string message) {
        if (message == "Computer Impulse")
    {
        vector myPos = llGetPos();
        rotation myRot = llGetRot();
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
        llRezObject(object, rezPos, rezVel, rezRot, startParam);
    }
}}