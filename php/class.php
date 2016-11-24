<?php
	header('Content-type: text/html; charset=utf-8');
	include("config.php");
	mysqli_set_charset($db,"utf8");

	$asset = $_POST['id'];

	$query = "SELECT `uuid` FROM assets WHERE aid='$asset'";
        if(!$result = mysqli_query($db,$query))
	{
		echo "0|89d996f7-c69b-2efe-475e-1531edbd9be1|0";
	}

	while($row = mysqli_fetch_array($result))
	{
		echo "0|".$row['uuid']."|0";
	}
?>

