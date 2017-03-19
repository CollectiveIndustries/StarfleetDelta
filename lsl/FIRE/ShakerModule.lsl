integer mycontrolch = 670; // Set chat channel for sending/receiving ship commands
// Put this script in the root prim of the item to shake.
// Say "/670 shake"  in chat to shake it and to play random (but similar) explosion sounds
// Don't include the " in the chat command.
// One of the sounds plays about 3 our of 7 times. The other sounds play 1 out of 7 tims.
float DELAY = 0.0; // In practice, min delay is 0.2 since LSL forces the script to sleep 0.2 seconds. So a delay of 0 is actually 0.2 sec
vector startPos; //used to store original starting position
vector target;   // Contains the current target
integer numshakes = 8; // Number of times to shake the prim
integer counter;
list explo = ["explo1"];
//
// USEFUL FUNCTIONS ---------------------------------
float randBetween( float min, float max ) // chooses a random number between min and max
{
    return llFrand( max - min ) + min;
}

vector randVector()  // returns a random position around the original start position
{
    return <startPos.x + randBetween( -0.25, 0.25 ),startPos.y + randBetween( -0.25, 0.25 ), startPos.z + randBetween( -0.25,0.25 )>;
}
// END - USEFUL FUNCTIONS
//


default
{
    state_entry()
    {
        llListen( 4052, "", "", "" );


    }
    listen( integer number, string name, key id, string message )
    {
        message = llToLower( message );
        if( message == "shake" )
        {
            startPos = llGetPos( );     //Save original starting position
            counter = 0;

            llPlaySound( "explo1",1 );

//              llPlaySound("Bridge Ship Explosion",1.0);
            while ( counter < numshakes )
            {
                target = randVector();
                llSetPos( target );
                llSleep( DELAY );
                counter = counter +1;
            }
            llSetPos( startPos );
        }

    }
}