string gName;
integer gLine = 0;
key gQueryID;
key gNLQueryID;
integer gLoad;
list gRankName;
list gRankText;
list gColorName;
list gColorVal;
list gTitleName;
list gTitleColor;
list gTitleText;

string conf_line_name(string fData)
{
    if (llGetSubString(fData,0,4) == "Rank.") {fData = llGetSubString(fData,5,-1);}
    else if (llGetSubString(fData,0,5) == "Color.") {fData = llGetSubString(fData,6,-1);}
    integer i;
    integer cut=-1;
    for (i=0;i<llStringLength(fData);i++) {
        if (llGetSubString(fData,i,i) == "=") {
            cut = i;
            i=llStringLength(fData);
        }
    }
    return llGetSubString(fData,0,cut-1);
}

string conf_line_val(string fData)
{
    if (llGetSubString(fData,0,4) == "Rank.") {fData = llGetSubString(fData,5,-1);}
    else if (llGetSubString(fData,0,5) == "Color.") {fData = llGetSubString(fData,6,-1);}
    integer i;
    integer cut=-1;
    for (i=0;i<llStringLength(fData);i++) {
        if (llGetSubString(fData,i,i) == "=") {
            cut = i;
            i=llStringLength(fData);
        }
    }
    return llGetSubString(fData,cut+1,-1);
}

string title_val(string fData)
{
    if (llGetSubString(fData,0,5) == "Title.") {fData = llGetSubString(fData,6,-1);}
    else if (llGetSubString(fData,0,10) == "TitleColor.") {fData = llGetSubString(fData,11,-1);}
    integer i;
    integer cut=-1;
    for (i=0;i<llStringLength(fData);i++) {
        if (llGetSubString(fData,i,i) == "=") {
            cut = i;
            i=llStringLength(fData);
        }
    }
    return llGetSubString(fData,cut+1,-1);
}

string title_name(string fData)
{
    if (llGetSubString(fData,0,5) == "Title.") {fData = llGetSubString(fData,6,-1);}
    else if (llGetSubString(fData,0,10) == "TitleColor.") {fData = llGetSubString(fData,11,-1);}
    integer i;
    integer cut=-1;
    for (i=0;i<llStringLength(fData);i++) {
        if (llGetSubString(fData,i,i) == "=" && cut == -1) {
            cut = i;
            i=llStringLength(fData);
        } else if (llGetSubString(fData,i,i) == "." && cut == -1) {
            cut = i;
            i=llStringLength(fData);
        }
    }
    return llGetSubString(fData,0,cut-1);
}

vector assign_color(string fData1)
{
    string cName = title_val(fData1);
    integer fSel = llListFindList(gColorName,[cName]);
    if (fSel > -1) {
        return (vector)llList2String(gColorVal,fSel);
    } else {
        return <1.0,1.0,1.0>;
    }
}

integer gHear;
integer gChan = 10;

string subs(string src, string dest, string test)
{
    integer i;
    integer s = llStringLength(dest);
    integer tSrcLen = llStringLength(src)-1;
    integer tTestLen = llStringLength(test);
    string output = dest;
    for (i=0;i<s;i++) {
        string tTemp = llGetSubString(dest,i,i+tSrcLen);
        if (tTemp==src) {
            output = llInsertString(dest,i,test);
            output = llDeleteSubString(output,i+tTestLen,i+tTestLen+tSrcLen);
        }
    }
    return output;
}

string parse()
{
    integer n;
    integer m;
    string tTitle = llGetObjectDesc();
    tTitle = subs("<name>",tTitle,llKey2Name(llGetOwner()));
    m=llGetListLength(gRankName);
    gMaxVal = m;
    for (n=0;n<m;n++) {
        tTitle = subs("<"+llList2String(gRankName,n)+">",tTitle,llList2String(gRankText,n));
        string tText = "# New Arts Titler #";
        tText += "\nParsing Title "+(string)(n*100/m)+"%";
        tText += "\n"+scroll(n);
        llSetText(tText,<1,1,1>,1.0);
    }
    if (llGetSubString(tTitle,0,1) == "/n") {
        tTitle=llGetSubString(tTitle,2,-1);
    }
    list tTempList = llParseString2List(tTitle,["/n"],[]);
    tTitle = "";
    m = llGetListLength(tTempList);
    gMaxVal = m;
    for (n=0;n<m;n++) {
        tTitle += llList2String(tTempList,n)+"\n";
        string tText = "# New Arts Titler #";
        tText += "\nRemoving Spaces from Title "+(string)(n*100/m)+"%";
        tText += "\n"+scroll(n);
        llSetText(tText,<1,1,1>,1.0);
    }
    return tTitle;
}
init()
{
    llListenRemove(gHear);
    gHear = llListen(gChan,"",llGetOwner(),"");
    string old_title = llGetObjectDesc();
    if (old_title != "" && old_title != "(No Description)") {
        llSetText(parse(),llGetColor(1),1.0);
    } else {
        llSetText("# New Arts Titler #\nPrevious Title not Found",<1,1,1>,1.0);
    }
}

integer gMaxVal;

string scroll(integer n)
{
    string full = "████████████████████";
    string empty = "░░░░░░░░░░░░░░░░░░░░";
    integer perc = llRound((n*20)/gMaxVal);
    string text;
    if (perc < 20) {
        text += llGetSubString(full,0,perc);
        text += llGetSubString(empty,perc+1,-1);
    } else if (perc >= 20) {
        text = full;
    }
    return llGetSubString(text,0,19);
}
load_text(integer step)
{
    string tText = "# New Arts Titler #";
    if (gLoad == 1) {
        tText += "\nLoading Configuration "+(string)(step*100/gMaxVal)+"%";
    } else if (gLoad == 2) {
        tText += "\nLoading Titles "+(string)(step*100/gMaxVal)+"%";
    }
    tText += "\n"+scroll(step);
    llSetText(tText,<1,1,1>,1.0);
}


default
{
    state_entry()
    {
        gName = "Shortcuts";
        gLine = 0;
        gLoad = 1;
        gNLQueryID = llGetNumberOfNotecardLines(gName);
    }

    dataserver(key query_id, string data) {
        if (query_id == gQueryID && gLoad == 1) {
            if (data != EOF) {
                if (llGetSubString(data,0,4) == "Rank.") {
                    gRankName += conf_line_name(data);
                    gRankText += conf_line_val(data);
                }
                if (llGetSubString(data,0,5) == "Color.") {
                    gColorName += conf_line_name(data);
                    gColorVal += conf_line_val(data);
                }
                load_text(gLine);
                ++gLine;
                gQueryID = llGetNotecardLine(gName, gLine);
            } else {
                gName = "Titles";
                gLine = 0;
                gLoad = 2;
                gNLQueryID = llGetNumberOfNotecardLines(gName);
            }
        } else if (query_id == gNLQueryID && gLoad == 1) {
            gMaxVal = (integer)data;
            gName = "Shortcuts";
            gLine = 0;
            gLoad = 1;
            gQueryID = llGetNotecardLine(gName, gLine);
        }
        if (query_id == gQueryID && gLoad == 2) {
            if (data != EOF) {
                if (llGetSubString(data,0,10) == "TitleColor.") {
                    string tTitleName = title_name(data);
                    integer tSel = llListFindList(gTitleName,[tTitleName]);
                    if (tSel == -1) {
                        gTitleName += tTitleName;
                        gTitleColor += assign_color(data);
                        gTitleText += "";
                    } else if (tSel > -1) {
                        gTitleColor = llListInsertList(gTitleColor,[title_val(data)],tSel);
                        gTitleColor = llDeleteSubList(gTitleColor,tSel+1,tSel+1);
                    }
                }
                if (llGetSubString(data,0,5) == "Title.") {
                    string tTitleName = title_name(data);
                    integer tSel = llListFindList(gTitleName,[tTitleName]);
                    if (tSel == -1) {
                        gTitleName += tTitleName;
                        gTitleColor += <1,1,1>;
                        gTitleText += title_val(data);
                    } else if (tSel > -1) {
                        string insert = llList2String(gTitleText,tSel)+"/n"+title_val(data);
                        gTitleText = llListInsertList(gTitleText,[insert],tSel);
                        gTitleText = llDeleteSubList(gTitleText,tSel+1,tSel+1);
                    }
                }
                load_text(gLine);
                ++gLine;
                gQueryID = llGetNotecardLine(gName, gLine);
            } else if (data == EOF) {
                init();
            }
        } else if (query_id == gNLQueryID && gLoad == 2) {
            gMaxVal = (integer)data;
            gName = "Titles";
            gLine = 0;
            gLoad = 2;
            gQueryID = llGetNotecardLine(gName, gLine);
        }
    }
// Reset after inventory or owner change
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY) llResetScript();
        else if(change & CHANGED_OWNER) llResetScript();
    }


    listen(integer chan, string name, key id, string m)
    {
        integer sel = llListFindList(gTitleName,[m]);
        if (m=="reset") {
            llResetScript();
        } else if (sel > -1) {
            llSetObjectDesc(llList2String(gTitleText,sel));
            llSetColor((vector)llList2String(gTitleColor,sel),1);
            init();
        }
    }
}
