//////////////////////////////////////////// // CONFIGURATION // ////////////////////////////////////////////
// Test string to test regular expression on.
string stringInput = "rraaats";

//////////////////////////////////////////// // INTERNALS // ////////////////////////////////////////////
string mem = "";

//////////////////////////////////////////// //////////////// UNUSED ////////////////////
////////////////////////////////////////////
string kleene( string input, string c )
{

    if( llStringLength( input ) == 0 )
    {
        return "";
    }
    string d = llGetSubString( input, 0, 0 );
    input = llDeleteSubString( input, 0, 0 );
    if( c == d )
    {
        return c + kleene( input, c );
    }
    return kleene( input, c );

} ////////////////////////////////////////////

//////////////////////////////////////////// // Kleene Star: zero or more characters. // ////////////////////////////////////////////
star( string input, string c )
{

    if( llStringLength( input ) == 0 )
    {
        return;
    }
    string d = llGetSubString( input, 0, 0 );
    input = llDeleteSubString( input, 0, 0 );
    if ( c == d )
    {
        mem += c;
        star( input, c );
    }
    if( mem == "" )
    {
        star( input, c );
    }

}

//////////////////////////////////////////// // Alternation: either-or characters. // ////////////////////////////////////////////
alter( string input, string ei, string or )
{

    if( llStringLength( input ) == 0 )
    {
        return;
    }
    string d = llGetSubString( input, 0, 0 );
    input = llDeleteSubString( input, 0, 0 );
    if( ei == d || or == d )
    {
        mem += d;
        alter( input, ei, or );
    }
    if( ei != d && or != d )
    {
        alter( input, ei, or );
    }

}

//////////////////////////////////////////// /////// AUXILIARY : PRESERVES ORDER //////// ////////////////////////////////////////////
string order( string input, string refer )
{

    integer itra = llStringLength( refer )-1;
    do
    {
        string s = llGetSubString( refer, itra, itra );
        if( llSubStringIndex( input, s ) == -1 )
        {
            refer = llDeleteSubString( refer, itra, itra );
        }
    }
    while( --itra>=0 );
    return refer;


}

default
{

    state_entry()
    {
        llListen( 0, "", llGetOwner(), "" );
    }
    listen( integer channel, string name, key id, string message )
    {

        string prev;
        string match = stringInput;

        do
        {
            // Grab next character from input.
            string in = llGetSubString( message, 0, 0 );

            if( in == "*" )
            {
                star( match, prev );
            }

            if( in == "|" )
            {
                string next = llDeleteSubString( message, 0, 0 );
                alter( match, prev, next );
            }

            // Store current character for backtracking.
            prev = in;
        }
        while( message = llDeleteSubString( message, 0, 0 ) );

        llOwnerSay( order( mem, stringInput ) );
        llResetScript();
    }

}
