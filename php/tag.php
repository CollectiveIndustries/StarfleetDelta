<?php

	include("config.php");
//	ini_set('default_charset', 'UTF-8');
	$uuid = $_POST['uuid'];

	$ERROR = "\n\nFailed to update Group Tag.\nContact Captain Morketh Sorex UFGQ IT Department with the provided Error Message\nFor bug Reports/Updates\nhttps://github.com/CollectiveIndustries/UFGQ/issues";


	$Tag = "SELECT a.`username`, a.`DisplayName`, a.`active`, r.`rname`, t.`tag_name`, d.`colorX`, d.`colorY`, d.`ColorZ`, r.`RankLogo` FROM `accounts` a INNER JOIN `divisions` d ON a.`DivID` = d.`did` INNER JOIN `Rank` r ON a.`RankID` = r.`RankID` INNER JOIN `Titles` t ON a.`TitleID` = t.`tid` WHERE `UUID` = '$uuid' LIMIT 1";


	$query = mysqli_query($db,$Tag);
	$Rows = mysqli_num_rows($query);
	if ($Rows == 0 ) // Is there a record already?
	{
		//No record on file they must be a civilian\observer
		echo "<255,255,255>:═══════\nCivilian\nUFGQ\nBUG ".$Rows. "\nuuid = ".$uuid;
		//echo "<255,255,255>:".$Tag;
	}
	elseif ($Rows == 1)
	{
		$list = mysqli_fetch_array($query);

		$name = $list['DisplayName'];
		$rank = $list['rname'];
		$tag = $list['tag_name'];
		$colorX = $list['colorX'];
		$colorY = $list['colorY'];
		$colorZ = $list['ColorZ'];
		$logo = $list['RankLogo'];

		if (0 == $list['active'])
		{
			echo "<255,255,255>:".$logo."\nCivilian\nUFGQ";
		}
		else
		{
			echo "<".$colorX.",".$colorY.",".$colorZ.">:".$logo."\n".$rank."\n".$name."\n".$tag."\nUFGQ";
		}

	}

