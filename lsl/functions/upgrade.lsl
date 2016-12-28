// Self Upgrading Script by Cron Stardust based upon work by Markov Brodsky and Jippen Faddoul.
// If this code is used, these header lines MUST be kept.
upgrade()
{
    //Get the name of the script
    string self = llGetScriptName();

    string basename = self;

    // If there is a space in the name, find out if it's a copy number and correct the basename.
    if ( llSubStringIndex( self, " " ) >= 0 )
    {
        // Get the section of the string that would match this RegEx: /[ ][0-9]+$/
        integer start = 2; // If there IS a version tail it will have a minimum of 2 characters.
        string tail = llGetSubString( self, llStringLength( self ) - start, -1 );
        while ( llGetSubString( tail, 0, 0 ) != " " )
        {
            start++;
            tail = llGetSubString( self, llStringLength( self ) - start, -1 );
        }

        // If the tail is a positive, non-zero number then it's a version code to be removed from the basename.
        if ( ( integer )tail > 0 )
        {
            basename = llGetSubString( self, 0, -llStringLength( tail ) - 1 );
        }
    }

    // Remove all other like named scripts.
    integer n = llGetInventoryNumber( INVENTORY_SCRIPT );
    while ( n-- > 0 )
    {
        string item = llGetInventoryName( INVENTORY_SCRIPT, n );

        // Remove scripts with same name (except myself, of course)
        if ( item != self && 0 == llSubStringIndex( item, basename ) )
        {
            llRemoveInventory( item );
        }
    }
}
