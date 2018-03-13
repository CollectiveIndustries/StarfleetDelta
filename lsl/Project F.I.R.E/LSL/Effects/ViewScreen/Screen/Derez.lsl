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
        llListen(19121,"",NULL_KEY, "");
    }

    listen(integer channel, string name, key id, string message) {
        if (message == "Delete")
    {
        llDie();
    }
}}