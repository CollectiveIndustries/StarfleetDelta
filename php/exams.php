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

$GET_GRADE = "SELECT((SELECT 1.0*COUNT(*) FROM scores s	JOIN accounts a ON a.ID=s.StudentID JOIN exams e ON e.eid=s.QuestionID WHERE s.answer=e.answer AND a.UUID='$StudentUUID' GROUP BY a.ID) / (SELECT COUNT(*) AS total FROM exams e WHERE e.course_id = '$CourseID' GROUP BY e.course_id)*100) AS `percentage`";

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
//          echo "OK|Returning GetSID() ".$row['id'];
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
//          echo "OK|Returning GetQID() ".$row['id'];
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

function GetGrade( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|GetGrade|".mysqli_error( $db ) );
    }
    if( mysqli_num_rows( $result ) > 0 )
    {

        while( $row = mysqli_fetch_array( $result ) )
        {
            echo $row['percentage']."|";
            // return the grade score so we can push that to the gradebook
            return $row['percentage'];
        }
    }
    else
    {
        echo "ERROR|GetGrade(): MySQL returned ZERO results while Calculating Final Grade.\n".$sql."\nMySQL ERROR: ".mysqli_error( $db );
    }
}

function CommitDB( $db,$sql )
{
    if( !$result = mysqli_query( $db,$sql ) )
    {
        die( "ERROR|CommitDB|".mysqli_error( $db )."\n".$sql );
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

    $INSERT_ANSWER = "REPLACE INTO `scores` (`StudentID`, `QuestionID`, `answer`) VALUES( '$sid', '$questid', '$Answer')";

    CommitDB( $db,$INSERT_ANSWER );
    die( "OK|-EOF-" );
case "grade":
    echo "GRADE|";
    $sid = GetSID( $db,$StudentID );
    $grade = GetGrade( $db,$GET_GRADE );

    $PUSH_GRADEBOOK = "INSERT INTO `gradebook` (`StudentID`, `CourseID`, `Grade`) VALUES ('$sid', '$CourseID', '$grade')";

    CommitDB( $db,$PUSH_GRADEBOOK );
    die( "-EOF-" );
default:
    echo "ITS BROKEN!!!!!!!";

}

?>
