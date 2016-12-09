<?php

// Configuration settings
header( 'Content-type: text/html; charset=utf-8' );
include( "config.php" );
include( "functions.php" );
mysqli_set_charset( $db,"utf8" );

$DEBUG = $_POST['debug'];
$BRANCH = $_POST['branch'];
$uuid = $_POST['uuid'];

// SQL CommLink by Avatar UUID
$Members = "SELECT a.UUID FROM accounts a WHERE a.active='1'";
$RemoveComm = "DELETE FROM `Comms` WHERE (SELECT a.ID FROM `accounts` a WHERE a.UUID='$uuid')=`Comms`.accountid";

function GetMembers( $db,$sql )
{
    global $DEBUG;
    if( $DEBUG )
    {
        echo "\nGetting Members\n";
    }

    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|UpdateCommLink: ".mysqli_error( $db ) );
    }
    echo "ACCOUNTS|";
    while( $row = mysqli_fetch_array( $result ) )
    {
        echo $row['UUID']."|";
    }
}

function RemoveComms( $db,$sql )
{
    global $DEBUG;
    if( $DEBUG )
    {
        echo "\nGetting Members\n";
    }
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|UpdateCommLink: ".mysqli_error( $db ) );
    }
    msqli_commit();
}

switch($BRANCH)
{
case "lookup":
    GetMembers($db,$Members);
    die("-EOF-");
case "remove":
    RemoveComms($db,$RemoveComm);
    die("-EOF-");
}

?>
