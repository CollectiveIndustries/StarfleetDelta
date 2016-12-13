/*
timeclock.lsl
Script will pull stats for the Most active mebers by amount of time clocked in
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

string TOP_CLOCK_PAGE = "http://ci-main.no-ip.org/MostActiveUser.php";
list POST_PARAMS = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
key TOP_CLOCK_REQ;

default
{
    state_entry()
    {
        llSay(0, "Grabbing Top 5 active members. Please wait......");
        TOP_CLOCK_REQ = llHTTPRequest(TOP_CLOCK_PAGE, POST_PARAMS, "");
        llSetTimerEvent(300.0);
    }

    timer()
    {
        TOP_CLOCK_REQ = llHTTPRequest(TOP_CLOCK_PAGE, POST_PARAMS, "");
    }

    http_response(key req, integer stat, list met, string body)
    {
        if(TOP_CLOCK_REQ == req && stat == 200)
        {
            //llSay(0,body);
            llSay(4711, llList2String(llParseString2List(body, ["?"], []), 1));

        }
        else if (TOP_CLOCK_REQ == req && stat != 200)
        {
            llSay(0, body + "\n" + (string)stat);
        }
    }
}
