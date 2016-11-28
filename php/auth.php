<?php

	include("config.php");
	$uuid = $_POST['uuid'];
	$code = $_POST['code'];

	$ERROR = "\n\nPersonel Autherization Error\n\nnhttps://github.com/CollectiveIndustries/UFGQ/issues";


// SQL statments
	// Insert UUID Username and Email address (AvatarName@ufgq.co)
	$SelectAV = "SELECT r.rname, a.DisplayName, d.dname FROM `accounts` a INNER JOIN `divisions` d ON a.`DivID` = d.`did` INNER JOIN `Rank` r ON a.`RankID` = r.`RankID` WHERE a.`cCode` = '$code' AND a.`active`='1' AND a.`UUID` = '$uuid'";

	$result = mysqli_query($db,$SelectAV);
	$isRecord =  mysqli_num_rows($result);

	if ( $isRecord == 0 ) // Is there a record already?
	{
		echo "ERROR|Authentication lookup failed";
	}
	elseif($isRecord == 1)
	{
		$row = mysqli_fetch_array($result);
		echo "OK|".$row['rname']."|".$row['DisplayName']."|".$row['dname'];
	}
	else //Supper Broken should never get here unless database keys are scrwed up
	{
		echo "ERROR|/!\\ CRITICAL /!\\ isRecord returned more then ONE result. this should NEVER happen. MySQL Table structure has been comprimised.".$ERROR;
	}
?>
