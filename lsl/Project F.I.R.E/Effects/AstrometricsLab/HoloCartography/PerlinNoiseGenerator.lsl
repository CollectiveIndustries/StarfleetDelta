//GLOBALS FOR vector Lat_long2Vec(integer lat,integer long)
integer R = 10000;//RADIUS
integer TEST = FALSE;
vector Lat_long2Vec(integer lat,integer long)
{
        vector pos;
        float x = R * llCos( lat ) * llCos( long );
        float y = R * llCos( lat ) * llSin( long );
        float z = R * llSin( lat );
        pos.x = x;
        pos.y = y;
        pos.z = z;
        llSay(0,"Vector = "+(string)pos);
        return pos;
    }
integer hash( integer a)
{
    DEBUG = FALSE;
    a = (a+0x7ed55d16) + (a<<12);
    Debug("(a+0x7ed55d16) + (a<<12)",(string)a);
    
    a = (a^0xc761c23c) ^ (a>>19);
    Debug("(a^0xc761c23c) ^ (a>>19)",(string)a);
    
    a = (a+0x165667b1) + (a<<5);
    Debug("(a+0x165667b1) + (a<<5)",(string)a);
    
    a = (a+0xd3a2646c) ^ (a<<9);
    Debug("(a+0xd3a2646c) ^ (a<<9)",(string)a);
    
    a = (a+0xfd7046c5) + (a<<3);
    Debug("(a+0xfd7046c5) + (a<<3)",(string)a);
    
    a = (a^0xb55a4f09) ^ (a>>16);
    Debug("(a^0xb55a4f09) ^ (a>>16)",(string)a);
    
    return a;
}

float findnoise2(integer x,integer y,integer seed)
{

    integer n=x+y*57;
    n=(n<<13)^n;
    integer nn=(n*(n*n*60493+19990303)+1376312589+hash(seed))&0x7fffffff;
    //printf("Seed: %d \nHash: %d",seed,hash(seed));//VC++ 2008 Express
    return 1.0-((float)nn/1073741824.0);
}

_scan(vector GV)
{
    integer res = 7400;//scanner resalution
    vector start=<0,0,0>;
    integer END = 12400;//this is the ending value
    float x = 0.0;
    float y = 0.0;
    float z = 0.0;
    float noise;
    vector tmp;
    vector size;
    vector local_vec;
    start.x -= (float)END;
    start.y -= (float)END;
    start.z -= (float)END; 
    Debug("start",(string)start);
    Debug("res",(string)res);
    
    Debug("END",(string)END);
    Debug("GV",(string)GV);
    for(x = (GV.x+start.x);x < (GV.x+(float)END); x += res)
        for(y = (GV.x+start.x);y < (GV.y+(float)END); y += res)
            for(z = (GV.x+start.x);z < (GV.z+(float)END); z += res)
            {
                DEBUG = TRUE;
//                llSay(0,"NOISE = "+(string)findnoise2((integer)x,(integer)y,(integer)z) );
                tmp.x = (x/15000);
                tmp.y = (y/15000);
                tmp.z = (z/15000);
                //Debug("tmp=(xyz/15000)",(string)tmp);
                //llSay(0,"LOCAL VECTOR: "+(string) (tmp));
                size = llGetScale();
                //Debug("size = llGetScale();",(string)size);
                size.x = size.x / 2;
                size.y = size.y / 2;
                size.z = size.z / 2;
                //Debug("size / 2",(string)size);
                
                noise = findnoise2((integer)tmp.x,(integer)tmp.y,(integer)tmp.z);
                
                local_vec = llGetPos();
                
                //Debug("local_vec = llGetPos();",(string)local_vec);
                //local_vec.x -= size.x;
                //local_vec.y += (size.y / 2);
                //local_vec.z += (size.z / 2);
                //Debug("local_vec -= size ",(string)local_vec);
                
                tmp.x += local_vec.x;
                tmp.y += local_vec.y;
                tmp.z += local_vec.z;
                
                //Debug("REZZER tmp += local_vec;",(string)tmp);
                llSetText("REZZING: ",<0,0,0>,1.0);
                
                //llSay(0,"Noise Value is: "+(string)noise);
                //llSay(0,"if(noise > -0.2 && noise < -0.4)"+(string)(noise > -0.2 && noise < -0.4) );
                if(noise < -0.3 && noise > -0.35)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Red Dwarf",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.35 && noise > -0.45)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("White Dwarf",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.45 && noise > -0.52)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Yellow Sun",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.53 && noise > -0.56)
                {
                    llRezObject("WormHole",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.56 && noise > -0.63)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Pulsar",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.6327 && noise > -0.66)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Binary System",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.67 && noise > -0.75)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Pulsar",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < -0.76 && noise > -0.9)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Unknown Anomoly",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < 0.2 && noise > -0.9)
                {
                    if(SS == FALSE)
                    {
                        if(TEST == TRUE)
                            llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                        else
                            llRezObject("SpaceStation",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                        SS = TRUE;
                    }
                    else
                    {
                        if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Spacial Anomoly",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    }
                }
                else if(noise < 0.6 && noise > 0.5)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("White Hole",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < 0.4 && noise > 0.3)
                {
                    if(TEST == TRUE)
                        llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    else
                        llRezObject("Black Hole",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
                else if(noise < 0.7 && noise > 0.4)
                {
                    if(SB == FALSE)
                    {
                        if(TEST == TRUE)
                            llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                        else
                            llRezObject("Starbase",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                        SB = TRUE;
                    }
                    else
                    {
                        if(TEST == TRUE)
                            llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                        else
                            llRezObject("SF Ship",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                    }
                    
                }
                else
                {
                    //llRezObject("TEST",tmp,ZERO_VECTOR,ZERO_ROTATION,(integer)(noise*1000000.0));
                }
            }
            llSetText("",<1,1,1>,1.0);
            SB = FALSE;
            SS = FALSE;
}
    
integer DEBUG = FALSE;   
Debug(string msg, string var)
{
    
    if(DEBUG == TRUE)
    {
        llSay(0, "DEBUG: " + msg + ":" + var);
    }
}    

integer SB = FALSE;
integer SS = FALSE;

default
{
    state_entry()
    {
        llSetText("",<0,0,0>,1.0);
        llListen(-85,"",NULL_KEY,"");
    }
    
    listen(integer chan,string name,key id,string msg)
    {
        //plot X mark Y
        list parse = llParseString2List(msg,[" "],[]);
        if(llToLower(llList2String(parse,0)) == "plot" )
        {
            integer lat = llList2Integer(parse,1);
            integer lon = llList2Integer(parse,3);
            float x;
            float y;
            float z;
            vector POS;
            float NOISE;
            llSay(1,"llDIE()");
            POS=Lat_long2Vec(lat,lon);
            x=POS.x;
            y=POS.y;
            z=POS.z;
            NOISE = findnoise2((integer)x,(integer)y,(integer)z);
            llSay(0, "course: "+(string)msg+"\nDensity = "+(string)NOISE);
            _scan(POS);
        }
    }
}