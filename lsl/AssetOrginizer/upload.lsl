// Loop through every Item in the inventory Grab names and UUID + types and push them to the Remote UUID Database for storage.
// A Simple Database Driven Multi Asset Orginizer

integer INDEX = 1;//Keeps track of the GLobal index number for the items in the inventory
integer TOTAL_INVENTORY;
string ASSET_PAGE = "http://ci-main.no-ip.org/asset.php";
list ASSET_PARAMS_POST = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded", HTTP_VERBOSE_THROTTLE, FALSE ];
string ASSET_POST_STRING = "";
key AssetReq = "";
list CHAR_SET = ["   ","▏","▎","▍","▌","▋","▊","▉","█"]; //UTF-8 Compatible string

// Function declarations

string Bars( float Cur, integer Bars, list Charset )
{
    // Input    = 0.0 to 1.0
    // Bars     = char length of progress bar
    // Charset  = [Blank,<Shades>,Solid];
    integer Shades = llGetListLength(Charset) - 1;
    Cur *= Bars;
    integer Solids  = llFloor( Cur );
    integer Shade   = llRound( (Cur-Solids)*Shades );
    integer Blanks  = Bars - Solids - 1;
    string str;
    while( Solids-- >0 ) str += llList2String( Charset, -1 );
    if( Blanks >= 0 ) str += llList2String( Charset, Shade );
    while( Blanks-- >0 ) str += llList2String( Charset, 0 );
    return str;
}

CountItems()
{
    TOTAL_INVENTORY = llGetInventoryNumber( INVENTORY_ALL );
    --TOTAL_INVENTORY; //minus 1, the script itself isn't counted, since its used with the INVENTORY_ALL flag
}

// Returns a type cast string of the INVENTORY_* type MySQL matches these values with out the INVENTORY_ part.
// Returning an asset lookup from a table inorder to insert the data.

string get_type_info(integer inputInteger)
{
    if (inputInteger == INVENTORY_TEXTURE)
        return "INVENTORY_TEXTURE";
    else if (inputInteger == INVENTORY_SOUND)
        return "INVENTORY_SOUND";
    else if (inputInteger == INVENTORY_LANDMARK)
        return "INVENTORY_LANDMARK";
    else if (inputInteger == INVENTORY_CLOTHING)
        return "INVENTORY_CLOTHING";
    else if (inputInteger == INVENTORY_OBJECT)
        return "INVENTORY_OBJECT";
    else if (inputInteger == INVENTORY_NOTECARD)
        return "INVENTORY_NOTECARD";
    else if (inputInteger == INVENTORY_SCRIPT)
        return "INVENTORY_SCRIPT";
    else if (inputInteger == INVENTORY_BODYPART)
        return "INVENTORY_BODYPART";
    else if (inputInteger == INVENTORY_ANIMATION)
        return "INVENTORY_ANIMATION";
    else if (inputInteger == INVENTORY_GESTURE)
        return "INVENTORY_GESTURE";
    else
        return "INVENTORY_UNKNOWN";//Catch all at the bottom to grab everything that falls through the switch
}

UploadRequest()
{
    ++INDEX;
    string name = llGetInventoryName(INVENTORY_ALL, INDEX);
    if (name)        // if a texture exists ...
    {
        key uuid = llGetInventoryKey(name);
        if (uuid)    // if the uuid is valid ...
        {
            ASSET_POST_STRING = "uuid="+(string)uuid+"&name="+(string)name+"&type="+(string)get_type_info(llGetInventoryType(name));
            llSetText("Uploading Assets\n"+Bars(((float)INDEX/TOTAL_INVENTORY),10,CHAR_SET),<0.0,1.0,0.0>,1.0);
            AssetReq = llHTTPRequest(ASSET_PAGE, ASSET_PARAMS_POST, ASSET_POST_STRING);
            llSay(0,"INDEX = "+(string)INDEX);
        }
    }
}


default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
        llSay(0,"Asset sorting system Init Level 1");
        llSetText("Touch To Upload Assets to the Asset Server",<0,1,0>,1.0);
    }
    changed(integer change)
    {
        llResetScript();
    }
    touch_start(integer index)
    {
        llSay(0," Activating Init level 5.");
        CountItems();
        llSay(0,"Invenntory Total = "+(string)TOTAL_INVENTORY);
        string name = llGetInventoryName(INVENTORY_ALL, INDEX);
        if (name)        // if a texture exists ...
        {
            key uuid = llGetInventoryKey(name);
            if (uuid)    // if the uuid is valid ...
            {
                ASSET_POST_STRING = "uuid="+(string)uuid+"&name="+(string)name+"&type="+(string)get_type_info(llGetInventoryType(name));
                AssetReq = llHTTPRequest(ASSET_PAGE, ASSET_PARAMS_POST, ASSET_POST_STRING);
            }
        }
    }

    http_response(key req ,integer stat, list met, string body)
    {
        if( req == AssetReq ) //Response was from the TimeClock
        {
            llSleep(1.0);
            if(stat == 200)
            {
                //Set up if statment to handle server Errors here
                if(llToLower(llGetSubString(body, 0, 5)) == "error|")
                {
                    llSay(0,"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
                    UploadRequest();
                }
                else
                {
                    //Handle upload response and then move to the next one on the list
                    list temp = llParseString2List(body,["|"],[]);
                    if(llToLower(llList2String(temp,0)) == "ok")
                    {
                        UploadRequest();
                    }
                }
            }
            else
                llSay(0,"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
        }
    }
}
