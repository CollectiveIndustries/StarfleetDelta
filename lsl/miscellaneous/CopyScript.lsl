string NewScript;
rotation myrot;

string RuleList2String(string main, list param)
{
    string slist = "["+main+",";
    integer i=0;
    while( i<llGetListLength(param) )
    {
        slist = slist + llList2String(param,i);
        i++;
        if( i<llGetListLength(param) )
        {
            slist = slist + ",";
        }
    }
    slist = slist + "]";
    return slist;
}

default
{   
    on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        llRequestURL();
        
        llSay(0,"Creating Script");
        NewScript = "default{\nstate_entry(){\nllSay(0,\"Building\");\n";
        integer total = 63;
        integer i = 1; // skip root 1
        list Temp;
        
        myrot = llGetRootRotation();
        
        Temp = llGetPrimitiveParams([PRIM_FLEXIBLE]);
        NewScript = NewScript + "llSetPrimitiveParams("+RuleList2String( "PRIM_FLEXIBLE", Temp ) + ");\n";
            
        Temp = llGetPrimitiveParams([PRIM_TYPE]);
        NewScript = NewScript + "llSetPrimitiveParams("+RuleList2String( "PRIM_TYPE", Temp ) + ");\n";
            
        Temp = llGetPrimitiveParams([PRIM_SIZE]);
        NewScript = NewScript + "llSetPrimitiveParams("+RuleList2String( "PRIM_SIZE", Temp ) + ");\n";
            
        Temp = llGetPrimitiveParams([PRIM_ROTATION]);
        NewScript = NewScript + "llSetPrimitiveParams("+RuleList2String( "PRIM_ROTATION", Temp ) + ");\n";

        
        while( i<=llGetNumberOfPrims() )
        {
            Temp = llGetLinkPrimitiveParams(i,[PRIM_FLEXIBLE]);
            NewScript = NewScript + "llSetLinkPrimitiveParams("+(string)i+","+RuleList2String( "PRIM_FLEXIBLE", Temp ) + ");\n";
            
            Temp = llGetLinkPrimitiveParams(i,[PRIM_TYPE]);
            NewScript = NewScript + "llSetLinkPrimitiveParams("+(string)i+","+RuleList2String( "PRIM_TYPE", Temp ) + ");\n";
            
            Temp = llGetLinkPrimitiveParams(i,[PRIM_SIZE]);
            NewScript = NewScript + "llSetLinkPrimitiveParams("+(string)i+","+RuleList2String( "PRIM_SIZE", Temp ) + ");\n";
            
            

            if( i!=1 )
            {
                Temp = llGetLinkPrimitiveParams(i,[PRIM_ROTATION]);
                rotation rt = llList2Rot(Temp,0);
                rt = rt/myrot;
                //Temp = [rt];
                NewScript = NewScript + "llSetLinkPrimitiveParams("+(string)i+",[PRIM_ROTATION,"+ (string)(rt)+"/llGetRootRotation()] );\n";
            
                Temp = llGetLinkPrimitiveParams(i,[PRIM_POSITION]);
                vector vt = llList2Vector( Temp , 0 );
                vt = vt-llGetPos();
                vt = vt/myrot;
                Temp = [vt];
                NewScript = NewScript + "llSetLinkPrimitiveParams("+(string)i+","+RuleList2String( "PRIM_POSITION", Temp ) + ");\n";
            }
            i++;
        }

        
        NewScript = NewScript + "llSay(0,\"done\");\n";

        NewScript = NewScript+"}\n}\n";        
        llSay(0,"Script is ready");
    }
    
    http_request(key id, string method, string body)
    {
        if(method == URL_REQUEST_GRANTED)
        {
            llSay(0,"URL: " + body);
        }
        else if(method == URL_REQUEST_DENIED)
        {
            llOwnerSay("Request denied");
        }
        else if(method == "GET")
        {
            llHTTPResponse(id,200,NewScript);
        }
    }
}
