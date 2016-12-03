<?php
	header('Content-type: text/html; charset=utf-8');
	include("config.php");
	mysqli_set_charset($db,"utf8");
//	$uuid = "81c65d80-2e5c-42e2-b6f2-0e541368ca1a";

	$branch = $_POST['branch']; // this will effect what we do with the rest of the values and what info we pull to allow for multipost comunication to the db from SL
	$uuid = $_POST['uuid']; //all the magic happens with the UUID number on file.
	$classID = $_POST['class_id'];
	$CourseID = $_POST['course_id'];
	$course_line = $_POST['course_line'];

//Select All Classes,  DH Classes, and BASIC classes from the database
	$BasicMenu = "SELECT d.`did`, d.`dname` FROM `divisions` d WHERE d.`did` = '8'";
	$ALLClassMenu = "SELECT `did`, `dname` FROM `divisions`";

	$ClassByDivId = "SELECT c.`ClassID`, c.`Class Name`, c.`Class Description` FROM `courses` c INNER JOIN `divisions` d ON d.`did` = c.`DivID` WHERE c.`DivID` = '$classID' ORDER BY c.`Class Name`";
	$DHmenu = "SELECT d.`did`, d.`dname` FROM `divisions` d INNER JOIN `accounts` a ON a.`DivID` = d.`did` WHERE a.`dh` = '1' AND a.`UUID` = '$uuid'";

//Authentication lookups This determines level of access for the user
	$NameByUUID = "SELECT r.`rname`, IFNULL(a.`DisplayName`, a.`username`) AS `name` FROM `accounts` a INNER JOIN `Rank` r ON a.`RankID` = r.`RankID` WHERE a.UUID = '$uuid'";
	$CommitteeLookup = "SELECT a.`UUID` FROM `committee` c INNER JOIN `accounts` a ON c.`aid` = a.`ID` WHERE a.`UUID` = '$uuid'";
	$DH = "SELECT `ID`, `username` FROM `accounts` WHERE `UUID` = '$uuid' AND `dh`='1'";
	$AcedemyLookup = "SELECT a.`ID`, IFNULL(a.`DisplayName`, a.`username`) AS `name` FROM `accounts` a WHERE a.`UUID`='$uuid' AND a.`DivID`='1'";

//Course Stats for the Course Selected
	$TotalLines = "SELECT COUNT(*) AS `total` FROM `curriculum` c WHERE c.`classID` = '$CourseID'";

// Grab a line from the Course on file and return it if the DisplayText is NULL grab the ASSET type and UUID number TYPE|UUID
	$CourseLine = "SELECT IFNULL(c.`displayText`, CONCAT('ASSET|',CONCAT(aa.`type`,CONCAT(':',a.`uuid`)))) as `line` FROM `curriculum` c LEFT JOIN assets a ON  c.`asset_id` = a.`aid` LEFT JOIN asset_types aa ON a.`type`=aa.`atid` WHERE c.`classID` = '$CourseID' AND c.`lineNumber` = '$course_line'";

//Function defines to keep code clean in this script
	function class_menu($db,$sql)
        {
                if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|class_menu|".mysqli_error($db));
                }
                while($row = mysqli_fetch_array($result))
                {
                        echo $row['did']."|".$row['dname']."|";
                }
        }

	function class_menu2($db,$sql)
        {
                if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|class_menu2|".mysqli_error($db));
                }
		if(mysqli_num_rows($result) > 0)
		{
			while($row = mysqli_fetch_array($result))
			{
                        	echo $row['ClassID']."|".$row['Class Name']."|";
			}
                }
		else
		{
			die("ERROR|MySQL returned an empty result set for the chosen class group.");
		}
        }

	function CountLines($db,$sql)
	{
		if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|CountLines|".mysqli_error($db));
                }
		if(mysqli_num_rows($result) > 0)
                {
                        while($row = mysqli_fetch_array($result))
                        {
                                echo "TOTAL|".$row['total']."|";
                        }
                }
                else
                {
                        die("ERROR|MySQL Returned ZERO results when counting lines in the selected course.");
                }
	}

	function PullLine($db,$sql)
	{
		if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|PullLine|".mysqli_error($db));
                }
                if(mysqli_num_rows($result) > 0)
                {
                        while($row = mysqli_fetch_array($result))
                        {
                                echo "LINE|".$row['line']."|";
                        }
                }
                else
                {
                        die("ERROR|MySQL Returned ZERO results when pulling the line from the selected course.");
                }
	}

	function GetRankName($db,$sql)
        {
                if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|GetRankName|".mysqli_error($db));
                }
                if(mysqli_num_rows($result) > 0)
                {
                        while($row = mysqli_fetch_array($result))
                        {
                                echo "RANK_NAME|".$row['rname']."|".$row['name']."|";
                        }
                }
                else
                {
                        die("ERROR|MySQL Returned ZERO results when pulling the Avatar's Rank and Name.");
                }
        }

	function IsCommittee($db,$sql)
	{
		if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|IsCommittee|".mysqli_error($db));
                }
                if(mysqli_num_rows($result) > 0)
                {
			return TRUE;
                }
                else
                {
			return FALSE;
                }
	}

	function IsAcademy($db,$sql)
	{
                if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|IsAcademy|".mysqli_error($db));
                }
                if(mysqli_num_rows($result) > 0)
                {
                        return TRUE;
                }
                else
                {
			return FALSE;
                }
	}
	function IsDepartmentHead($db,$sql)
	{
                if(!$result = mysqli_query($db,$sql))
                {
                        die("ERROR|IsDepartmentHead|".mysqli_error($db));
                }
                if(mysqli_num_rows($result) > 0)
                {
                        return TRUE;
                }
                else
                {
			return FALSE;
                }
	}

	function OtherStaff($db,$sql)
	{
		if(!$result = mysqli_query($db,$sql))
		{
			die("ERROR|OtherStaff|".mysqli_error($db));
		}
		while($row = mysqli_fetch_array($result))
		{
			// User is unauthorized so kill the script we dont really care anymore
			die("ERROR|".$row['rname']." ".$row['name'].", Unauthorized Access Detected");
		}
	}

	function AuthLevel($db)
	{
		//Grab our authentication lookups and set them up here as a global value
		global $NameByUUID;
		global $CommitteeLookup;
		global $DH;
		global $AcedemyLookup;
		if(IsCommittee($db,$CommitteeLookup))
		{
			return "full";
		}
		else if(IsAcademy($db,$AcedemyLookup))
		{
			return "full";
		}
		else if(IsDepartmentHead($db, $DH))
		{
			return "dh";
		}
		else if(IsOtherStaff($db,$NameByUUID))
		{
			return "none";
		}
	}

// all the Magic happens in this section here multi-post comunication from SL to the DB
switch ($branch) {
	case "menu": // Grab a list of divisions provide them to SL as a | seperated list for the menu
		echo "DIV_MENU|";
		switch (AuthLevel($db)) {
			case "full": //Full menu
				class_menu($db,$ALLClassMenu);
				break;
			case "dh": //DH Menu
				class_menu($db,$DHmenu);
				class_menu($db,$BasicMenu);
				break;
			case "none":
				break;
			}
		die("-EOF-");
	case "div":
		echo "CLASS_MENU|";
		class_menu2($db,$ClassByDivId);
		die("-EOF-");
		break;
	case "class_init":
		GetRankName($db,$NameByUUID);
		CountLines($db,$TotalLines);
		die("-EOF-");
		break;
	case "class_running":
		PullLine($db,$CourseLine);
		die("-EOF-");
		break;
}

die(" -EOF- ");
?>
