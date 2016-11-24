<?php
	header('Content-type: text/html; charset=utf-8');
	include("config.php");
	include("functions.php");
	mysqli_set_charset($db,"utf8");

	$uuid = $_POST['uuid'];
	$name = $_POST['name'];
	$type = GetAssetName($_POST['type']);

	$AssetUpload = "INSERT INTO `assets` (`uuid`,`type`,`name`) VALUES('$uuid',(SELECT `atid` FROM `asset_types` WHERE `type` LIKE '%$type%'), '$name')";
        if(!$result = mysqli_query($db,$AssetUpload))
	{
		echo "ERROR|".mysqli_error($db)."\nINSERT INTO `assets` (`uuid`,`type`,`name`) VALUES('$uuid',(SELECT `atid` FROM `asset_types` WHERE `type` LIKE '%$type%'), '$name')";
	}
	else
	{
		echo "OK|Data Inserted";
	}
	mysqli_close($db);
?>

