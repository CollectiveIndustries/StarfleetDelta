<?php

	include("config.php");
	$uuid = $_POST['uuid'];

	$ERROR = "\n\nFailed to update Group Tag.\nContact Captain Morketh Sorex UFGQ IT Department with the provided Error Message\nFor bug Reports/Updates\nhttps://github.com/CollectiveIndustries/UFGQ/issues";


	$Tag = "SELECT a.`username`, a.DisplayName, a.active, d.dname, r.rname, t.`tag_name`, d.`colorX`, d.`colorY`, d.`ColorZ`, r.`RankID` FROM `accounts` a INNER JOIN `divisions` d ON a.`DivID` = d.`did` INNER JOIN `Rank` r ON a.`RankID` = r.`RankID` INNER JOIN `Titles` t ON a.`TitleID` = t.`tid` WHERE `UUID` = '$uuid' LIMIT 1";

	$query = mysqli_query($db,$Tag);
	$Rows = mysqli_num_rows($query);
	if ($Rows == 0 ) // Is there a record already?
	{
		echo "OOC Observer";
	}
	elseif ($Rows == 1)
	{
		$list = mysqli_fetch_array($query);

		$name = $list['DisplayName'];
		$division = $list['dname'];
		$rank = $list['rname'];
		$tag = $list['tag_name'];
		$rid = $list['RankID'];
		$colorX = $list['colorX'];
		$colorY = $list['colorY'];
		$colorZ = $list['ColorZ'];
		echo "<".$colorX.",".$colorY.",".$colorZ.">:".$rid.":\n".$rank."\n".$name."\n".$tag."\nUFGQ";
	}

