<?php
	include("config.php");
	$uuid = $_POST['uuid'];
	echo "$uuid Clocked in/out\n\n";

	$sql = "INSERT INTO `ufgq`.`Time Clock` (`uuid`) VALUES ('$uuid')";
	if (mysqli_query($db, $sql))
	{
		echo "Time Clock was updated.";
		mysqli_commit();
	}
	else
	{
		echo "Error: " . $sql . "\n" . mysqli_error($db);
		die("\n\nFailed to Clock User in/out.\nContact Captain Morketh Sorex UFGQ IT Department with the provided Error Message\nFor bug Reports/Updates\nhttps://github.com/CollectiveIndustries/UFGQ/issues");
	}
	mysqli_close($db);
?>
