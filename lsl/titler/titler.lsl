/*
timeclock.lsl
Program designed to function as a timeclock to allow for avatars on SL/OSG to clock into and out of UFGQ
    Copyright (C) 2016  Andrew Malone

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// User configurable variables.
string TAG_PAGE = "http://ci-main.no-ip.org/tag.php";
string HTTP_ERROR = "An unexpected error occured while attempting to clock user in/out. Please visit https://github.com/CollectiveIndustries/UFGQ/issues to submit bug reports or checkup on known issues.\n\n";

// Variable Init
key USER = "";
key TagReq = ""; // Clock request HTTP Key
list TAG_PARAMS_POST = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
list TAG_PARAMS_GET = [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
/*
Rank.viceadm=[■■■]
Rank.rearadm=[■■]
Rank.comdr=[■]
Rank.fltcpt=⚫⚫⚫⚫⚫
Rank.cpt=⚫⚫⚫⚫
Rank.cmdr=⚫⚫⚫
Rank.ltcmdr=⚪⚫⚫
Rank.lt=⚫⚫
Rank.ltjg=⚪⚫
Rank.ens=⚫
Rank.cdt4y=[ | | | | ]
Rank.cdt3y=[ | | | ]
Rank.cdt2y=[ | | ]
Rank.cdt1y=[ | ]
Rank.adm=[■■■■]
Rank.fltadm[■■■■■]
*/

// Function declarations

// Main entry Point //
default
{
    state_entry()
    {
        llOwnerSay("INIT: Systems starting");
        TagReq = llHTTPRequest(TAG_PAGE, TAG_PARAMS, "uuid="+(string)llGetOwner());
	//TagReq = llHTTPRequest(TAG_PAGE+"?uuid="+(string)llGetOwner(), TAG_PARAMS, "");
    }
    
    changed(integer change)
    {
        if(change & CHANGED_OWNER) llResetScript();
    }

    http_response(key req ,integer stat, list met, string body)
    {
        if( req == TagReq ) //Response was from the TimeClock
        {
            if(stat == 200)
            {
                //Set up if statment to handle server Errors here
                if(llToLower(llGetSubString(body, 0, 5)) == "error:")
                {
                    llOwnerSay(HTTP_ERROR+"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
                }
                else
                {
                    llSetText(body, <1,1,1>, 1.0);
                }
                USER = "";
            }
            else
                llOwnerSay(HTTP_ERROR+"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
        }
    }
}
