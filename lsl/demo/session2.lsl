
// User configurable variable
integer debug = TRUE;

// Network API Variables
integer API_CHAN;
integer API_LISTEN;

// internal HTTP Variables
integer COURSE_ID;
integer TOTALQUESTIONS;
integer QUESTIONINDEX = 1;

// Menu variables
string QUESTION;
list ANSWERS = ["A", "B", "C", "D"];
string CHOSENANS;
integer MENU_HANDLE;
integer MENU_CHANNEL;


key USER;

list POST_PARAMS = [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];
//list GET_PARAMS = [HTTP_METHOD, "GET", HTTP_MIMETYPE, "application/x-www-form-urlencoded"];

key EXAM; // For sending COURSE_ID
key EXAM_ANSWER; // Deals primarily with the answers
string COURSE_PAGE = "http://ci-main.no-ip.org/exams.php";
integer INIT = FALSE;


// Function Declerations

integer ID2Chan(string id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

// Shortcut ^_^
setText(string text)
{
    llSetText(text, <1,1,1>, 1.0);
}


// Main

default
{
    state_entry()
    {
        setText("");
        llSetTexture("61320ebe-48bb-8b93-cea9-d1036ab26507", 1);
        API_CHAN = ID2Chan(llMD5String(llGetObjectDesc(),0));
        API_LISTEN = llListen(API_CHAN, "", "", "");
    }

    listen(integer channel, string name, key id, string msg)
    {

        list message = llParseString2List(msg, [":"], []);
        if (llList2String(message, 0) == "Texture")
        {
            llSetTexture((key)llList2String(message, 1), 1);
        }
        else if (llList2String(message, 0) == "COURSE_ID")
        {
            COURSE_ID = llList2Integer(message, 1);
            if(debug) llSay(0, "Course ID is now set to " + (string)COURSE_ID);
        }
        else if (msg == "START_EXAM:TRUE")
        {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        if(debug) llSay(0, "I'm now in use!");
        llSetText("Exam Ready!\nTouch me to begin!", <1,1,1>, 1.0);
    }

    touch_start(integer num)
    {
        USER = llDetectedKey(0);
        MENU_CHANNEL = ID2Chan((string)USER);
        MENU_HANDLE = llListen(MENU_CHANNEL, "", "", "");
        setText("Exam in progress!\nThis terminal in use by\n" + llGetDisplayName(USER));
        if(debug) llSay(0, "I have been touched by " + llGetDisplayName(USER));
        EXAM = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=init&course_id=" + (string)COURSE_ID);
    }

    http_response(key reqid, integer stat, list metadata, string body)
    {
        if(debug) llSay(0, body);
        list parsedBody = llParseString2List(body, ["|"], []);
        if (reqid == EXAM && stat == 200)
        {
            if (!INIT)
            {
                if (llList2String(parsedBody, 0) == "TOTAL")
                {                    TOTALQUESTIONS = llList2Integer(parsedBody, 1);
                    INIT = TRUE;
                    EXAM = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=line&course_id=" + (string)COURSE_ID+"&qindex="+(string)QUESTIONINDEX);
                    if(debug) llSay(0, "Total questions set to " + (string)TOTALQUESTIONS);
                }
            }
            else if (INIT && QUESTIONINDEX <= TOTALQUESTIONS) //INIT == TRUE
            {
                QUESTION = llList2String(parsedBody, 1);
                
                llDialog(USER, QUESTION, ANSWERS, MENU_CHANNEL);
                // 1) Question Dialog here (parse dialog menu here)
            }
            else if (INIT && QUESTIONINDEX > TOTALQUESTIONS)
            {
                // 6) Greater the Question Index so we need to pull the grades
            }
        }
        else if( reqid == EXAM_ANSWER && stat == 200 )
	{
	            // 4) DEAL with Answer here
	            // 5) Fire http request with next question While Index < Total else goto 6)
		llSay(0,"RESPONSE: "+(string)body);
	}
	else
        {
            llSay(0, "There was an error. Error details as follows: \nERROR CODE: " + (string)stat + "\nERROR INFO: " + body);
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        llSay(0, (string)msg);
        QUESTIONINDEX = QUESTIONINDEX + 1;
        EXAM_ANSWER = llHTTPRequest(COURSE_PAGE, POST_PARAMS, "branch=answer&qindex=" + (string)QUESTIONINDEX + "&uuid=" + (string)USER + "&answer=" + msg);
        // 2) GUI Response from USER
        // 3) HTTP Request with answer
    }
}

