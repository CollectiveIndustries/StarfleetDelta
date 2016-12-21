<?php

// Configuration settings
header( 'Content-type: text/html; charset=utf-8' );
include( "config.php" );
include( "functions.php" );
mysqli_set_charset( $db,"utf8" );

$url = $_POST['url']; // this will effect what we do with the rest of the values and what info we pull to allow for multipost comunication to the db from SL
$ObjectUUID = $_POST['object_uuid']; //all the magic happens with the UUID number on file.
$OwnerUUID = $_POST['owner_uuid']; //all the magic happens with the UUID number on file.
$msg = $_POST['msg'];
$div_lookup = $_POST['div_lookup'];
$branch = $_POST['branch'];

$DEBUG = $_POST['debug'];


// SQL CommLink by Avatar UUID
$AddComm = "CALL `UpdateCommLink`('$OwnerUUID', '$ObjectUUID', '$url')";
$Comms = "SELECT IFNULL(a.DisplayName, a.username) AS `name`, com.url FROM `Comms` com JOIN `accounts` a ON a.ID = com.accountid ORDER BY `comid`";
$CommLock = "SELECT r.rname, IFNULL(a.DisplayName, a.username) AS `name`, com.url FROM `accounts` a INNER JOIN `divisions` d ON a.`DivID` = d.`did` INNER JOIN `Rank` r ON a.`RankID` = r.`RankID` INNER JOIN `Comms` com ON com.accountid=a.ID WHERE a.active = '1' AND IFNULL(d.alias,d.dname) = '$div_lookup'";
$SenderName = "SELECT `r`.`rname` AS `rname`, IFNULL(`a`.`DisplayName`,`a`.`username`) AS `name` FROM `accounts` `a` JOIN `Rank` `r` ON `a`.`RankID` = `r`.`RankID` WHERE a.UUID='$OwnerUUID'";
$IsComm = "SELECT `ID` FROM `accounts` WHERE `UUID`='$OwnerUUID'";
$RemoveCommLink = "DELETE FROM `Comms` WHERE `ObjectUUID`='$ObjectUUID'";

$CommitteeLocked = "SELECT IFNULL(a.DisplayName, a.username) AS `name`, com.url FROM `Comms` com JOIN `accounts` a ON a.ID = com.accountid JOIN `committee` c ON c.aid = a.ID ORDER BY `comid`";
$DHLocked = "SELECT IFNULL(a.DisplayName, a.username) AS `name`, com.url FROM `Comms` com JOIN `accounts` a ON a.ID = com.accountid WHERE a.dh='1' ORDER BY `comid`";
$AdminPerms = "SELECT IFNULL(a.DisplayName, a.username) AS `name`, com.url FROM `Comms` com JOIN `accounts` a ON a.ID = com.accountid WHERE a.db_privlage_level='10' ORDER BY `comid`";
$OnComm = "SELECT `r`.`rname` AS `rname`, IFNULL(a.DisplayName, a.username) AS `name`, com.url FROM `Comms` com JOIN `accounts` a ON a.ID = com.accountid JOIN `Rank` `r` ON `a`.`RankID` = `r`.`RankID` ORDER BY `comid`";

function UpdateCommLink( $db,$sql )
{
    global $DEBUG;

    if( $DEBUG )
    {
        echo "\nCommlink updated\n";
    }

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|UpdateCommLink: ".mysqli_error( $db ) );
    }
}

function SenderName( $db,$sql )
{
    global $DEBUG;

    if( $DEBUG )
    {
        echo "\nLooking up OwnerName.\n";
    }

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|SenderName(): ".mysqli_error( $db ) );
    }

    while( $row = mysqli_fetch_array( $result ) )
    {
        if( $DEBUG )
        {
            echo $row['rname']." ".$row['name'];
        }

        return $row['rname']." ".$row['name'];
    }
}

function RemoveCommLink( $db,$sql )
{
    if( $DEBUG )
    {
        echo "\nRemoving Commlink.\n";
    }

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|RemoveCommLink(): ".mysqli_error( $db ) );
    }

    if( $DEBUG )
    {
        echo "Commlinks unsynced.\n";
    }

    msqli_commit();
}

function SendMsg( $db,$sql,$msg )
{
    global $DEBUG;
    global $SenderName;
    $name = SenderName( $db,$SenderName );

    if( $DEBUG )
    {
        echo "\nSending - Message: '$msg'\nFrom: '$name'\n";
    }

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|SendMsg(): ".mysqli_error( $db ) );
    }

    if( $DEBUG )
    {
        echo "Number of Destinations found: ".mysqli_num_rows( $result )."\n";
    }

    if( !( mysqli_num_rows( $result ) > 0 ) )
    {
        die( "ERROR|SendMsg(): ResultSet was empty while attemting to lookup Destinations." );
    }

    while( $row = mysqli_fetch_array( $result ) )
    {
        if( $DEBUG )
        {
            echo "\n----------------------------------------\nDestination: ".$row['name']."\nURL: ".$row['url'];
        }

        Advanced_HTTP_Request( $row['url'], $name." : ".$msg );
    }
}

function SendMsgLocked( $db, $sql, $msg )
{
    global $DEBUG;
    global $SenderName;
    global $div_lookup;
    $name = SenderName( $db,$SenderName );

    if( $DEBUG )
    {
        echo "Send - Locked Comm: Message: '$msg'\nFrom: '$name'\n";
    }

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|SendMsg(): ".mysqli_error( $db ) );
    }

    if( $DEBUG )
    {
        echo "Number of Destinations found: ".mysqli_num_rows( $result )."\n";
    }

    if( !( mysqli_num_rows( $result ) > 0 ) )
    {
        die( "ERROR|SendMsg(): ResultSet was empty while attemting to lookup Destinations by '$div_lookup'." );
    }

    while( $row = mysqli_fetch_array( $result ) )
    {
        if( $DEBUG )
        {
            echo "\n\n----------------------------------------\nDestination: ".$row['name']."\nURL: ".$row['url'];
        }

        //Send NAME: message to every one on the returned result set;
        Advanced_HTTP_Request( $row['url'], $name." : ".$msg );
    }
}

function ValidComm( $db,$sql )
{
    global $DEBUG;

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|IsValidComm(): ".mysqli_error( $db ) );
    }

    if( mysqli_num_rows( $result ) > 0 )
    {
        if( $DEBUG )
        {
            echo "\nValid Commlink Detected";
        }

        return TRUE;
    }
    else
    {
        if( $DEBUG )
        {
            echo "\nInvalid Commlink Detected.";
        }

        return FALSE;
    }
}

function IsOnComm( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|IsOnComm(): ".mysqli_error( $db ) );
    }
    if( mysqli_num_rows( $result ) > 0 )
    {
        if( $DEBUG )
        {
            echo "Running Comm Check\n";
        }
        echo "PONG|";
        while( $row = mysqli_fetch_array( $result ) )
        {
            echo $row['rname']." ".$row['name']."|";
        }
    }
}

if( $DEBUG )
{
    echo "Variable INIT: \n\nURL: '$url'\nObject: '$ObjectUUID'\nOwner '$OwnerUUID'\nMSG: '$msg'\nDiv Lookup: '$div_lookup'\nBranch: '$branch'\nDEBUG = '$DEBUG'\n";
}

if( !ValidComm( $db,$IsComm ) )
{
    die( "ERROR|Invalid Commlink: You are not authorized for this com system." );
}

switch ( $branch )
{
case "div_lock":
    switch ( $div_lookup )
    {
        case "titler":
            if( $DEBUG )
            {
                echo "\nTitler\n";
            }

            //some message for the titler
            SendMsg( $db, $Comms, "$ADMIN|TITLE|RESET" );
            die( "-EOF-\n" );

        case "dh":
            if( $DEBUG )
            {
                echo "\nDivision Head Locked\n";
            }
            SendMsgLocked( $db,$DHLocked, $msg );
            // initilize DH Locking
            die( "-EOF-\n" );

        case "committee":
            if( $DEBUG )
            {
                echo "\nCommittee Member Locked\n";
            }
            SendMsgLocked( $db,$CommitteeLocked,$msg );
            // Init Committee Locking
            die( "-EOF-\n" );

        case "ping":

            if( $DEBUG )
            {
                echo "\nPing Test\n";
            }
            echo "INFO|";
            IsOnComm( $db,$OnComm );
            //SendMsg( $db, $Comms, "ADMIN|PING" );
            // Init Ping request
            die( "-EOF-\n" );
    }

    SendMsgLocked( $db, $CommLock, $msg );
    die( "\n\n-EOF-\n" );

default:
    switch ( $msg )
    {
        case "UPDATE": // UPDATE the Comm table with the comm that just connected
            if( $DEBUG )
            {
                echo "\nUpdateCommLink('$OwnerUUID', '$ObjectUUID', '$url')\n";
            }

            UpdateCommLink( $db,$AddComm );
            SendMsg( $db, $Comms, "Commlink Now Activated." );
            die( "\n\n-EOF\n" );

        case "REMOVE":
            SendMsg( $db, $Comms, "Commlink Deactivated." );
            RemoveCommLink( $db,$RemoveCommLink );
            die( "\n\n-EOF-\n" );

        //REMOVE from DB
        default:
            if( $DEBUG )
            {
                echo "\nswitch: defualt:\nMessege: '$msg'";
            }

            SendMsg( $db, $Comms, $msg );
            die( "\n\n-EOF-\n" );
    }
}

?>
