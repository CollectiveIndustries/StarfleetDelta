string msgDest;



string parsedMessage(string msg)
{
	list exploded = llParseString2List(msg, ["|"], []);
	msgDest = llList2String(exploded, 0);
	llDeleteSubList(exploded, 0);
	return llDumpList2String(exploded, "|");
}
