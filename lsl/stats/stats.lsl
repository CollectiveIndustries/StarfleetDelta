/*
stats.lsl
Script is for displaying status for Divisions and Ranks for UFGQ
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
string STAT_PAGE = "http://ci-main.no-ip.org/stats.php";
string HTTP_ERROR = "An unexpected error occured while attempting to get Group Statistics. Please visit https://github.com/CollectiveIndustries/UFGQ/issues to submit bug reports or checkup on known issues.\n\n";

// Variable Init
key USER = "";
key StatReq = ""; // Clock request HTTP Key
list STAT_PARAMS_POST = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
list STAT_PARAMS_GET = [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];

// Function declarations

// Main entry Point //
default
{
    state_entry()
    {
        llOwnerSay("INIT: Systems starting");
        llSetTimerEvent(5.0);//5 Second refresh
        StatReq = llHTTPRequest(STAT_PAGE, STAT_PARAMS_POST, "stat="+ llToLower(llGetObjectDesc()));
    }
    
    timer()
    {
        StatReq = llHTTPRequest(STAT_PAGE, STAT_PARAMS_POST, "stat="+ llToLower(llGetObjectDesc()));
    }
    
    changed(integer change)
    {
        if(change & CHANGED_OWNER) llResetScript();
    }

    http_response(key req ,integer stat, list met, string body)
    {
        if( req == StatReq ) //Response was from the StatPage
        {
            if(stat == 200)//HTTP was Sent correctly
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
            {
                llSetText("Error "+(string)stat, <1,0,0>, 1.0);
            }
                //llOwnerSay(HTTP_ERROR+"\nSTAT: "+(string)stat+"\nRES: "+(string)body);
        }
    }
}
