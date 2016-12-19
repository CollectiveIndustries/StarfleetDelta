<?php
header( 'Content-type: text/html; charset=utf-8' );
include( "config.php" );
mysqli_set_charset( $db,"utf8" );

// Get POST Values from LSL Scripts
$CourseID = $_POST['course_id'];
$branch = $_POST['branch'];

$QuestionNumber = $_POST['qindex'];
$StudentUUID = $_POST['uuid'];
$Answer = $_POST['answer'];

// SQL Statments
$TOTAL = "SELECT COUNT(*) `total` FROM `exams` e WHERE e.`course_id`='$CourseID' GROUP BY e.`course_id`";

$QUESTION = "SELECT `question_number`,`question`,`a`,`b`,`c`,`d` FROM `exams` e WHERE e.`course_id`='$CourseID' AND e.`question_number`='$QuestionNumber'";

$StudentID = "SELECT a.`ID` AS `id` FROM `accounts` a WHERE a.`UUID`='$StudentUUID'";
$QuestionID = "SELECT e.`eid` AS `id` FROM `exams` e WHERE e.`question_number`='$QuestionNumber' AND e.`course_id`='$CourseID'";

$GET_GRADE = "";

function GetSID( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|GetSID|".mysqli_error( $db ) );
    }
    if( mysqli_num_rows( $result ) > 0 )
    {
        while( $row = mysqli_fetch_array( $result ) )
        {
            echo "OK|Returning GetSID() ".$row['id'];
            return $row['id'];
        }
    }
    else
    {
        echo "ERROR|GetSID(): MySQL returned zero results while looking up Student ID. ".$sql;
    }
}

function GetQID( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|GetQID|".mysqli_error( $db ) );
    }
    if( mysqli_num_rows( $result ) > 0 )
    {
        while( $row = mysqli_fetch_array( $result ) )
        {
            echo "OK|Returning GetQID() ".$row['id'];
            return $row['id'];
        }
    }
    else
    {
        echo "ERROR|GetQID(): MySQL returned zero results while looking up Question ID. ".$sql;
    }
}

function total( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|total|".mysqli_error( $db ) );
    }
    while( $row = mysqli_fetch_array( $result ) )
    {
        echo "TOTAL|".$row['total']."|";
    }
}

function GetLine( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|GetLine|".mysqli_error( $db ) );
    }
    while( $row = mysqli_fetch_array( $result ) )
    {
        echo "LINE|".$row['question_number'].". ".$row['question']."\nA: ".$row['a']."\nB: ".$row['b']."\nC: ".$row['c']."\nD: ".$row['d']."|";
    }
}

function SetAnswer( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|SetAnswer|".mysqli_error( $db ) );
    }
}

function GetGrade( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|GetGrade|".mysqli_error( $db ) );
    }
    while( $row = mysqli_fetch_array( $result ) )
    {
        echo $row['score'];
    }
}

switch( $branch )
{
case "init":
    total( $db,$TOTAL );
    die( "-EOF-" );
case "line":
    GetLine( $db,$QUESTION );
    die( "-EOF-" );
case "answer":
    echo "ANSWER|";
    $questid = GetQID( $db,$QuestionID );
    $sid = GetSID( $db,$StudentID );

    $INSERT_ANSWER = "INSERT INTO `scores` (`StudentID`, `QuestionID`, `answer`) VALUES( '$sid', '$questid', '$Answer')";

    SetAnswer( $db,$INSERT_ANSWER );
    die( "OK|-EOF-" );
case "grade":
    echo "GRADE|";
    GetGrade( $db,$GET_GRADE );
    die( "-EOF-" );
default:
    echo "ITS BROKEN!!!!!!!";

}

?>