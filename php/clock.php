<?php
	include("config.php");
	$uuid = $_POST['uuid'];
	$name = $_POST['name'];

// SQL statments
	$NEW_AVY_SQL = "INSERT INTO `ufgq`.`accounts` (`UUID`, `username`) VALUES ('$uuid', '$name')";
	$SelectAV = "SELECT ID FROM `ufgq`.`accounts` WHERE `UUID` = '$uuid'";
	$OnFileInsert = "INSERT INTO ufgq.`Time Clock` (user_id) SELECT id FROM accounts a WHERE a.`UUID` = '$uuid'";

//Grab the number of Results from the query
	if (0 ==  mysqli_num_rows(mysqli_query($db,$SelectAV)))
	{
		if(!mysqli_query($db,$NEW_AVY_SQL))
		{
			echo "ERROR: " . $sql . "\n" . mysqli_error($db);
			die("\n\nFailed to update Users Time Card.\nContact Captain Morketh Sorex UFGQ IT Department with the provided Error Message\nFor bug Reports/Updates\nhttps://github.com/CollectiveIndustries/UFGQ/issues");
		}
		mysqli_commit();
		echo "New Account created. User now logged in.";
	}
	else
	{
		echo "Account on file. Time Clock updated.";
	}
// Once the Account is on file we can just log the user right in
	mysqli_query($db,$OnFileInsert);
	mysqli_commit();

//	else
//	{
//		echo "Error: " . $sql . "\n" . mysqli_error($db);
//		die("\n\nFailed to Clock User in/out.\nContact Captain Morketh Sorex UFGQ IT Department with the provided Error Message\nFor bug Reports/Updates\nhttps://github.com/CollectiveIndustries/UFGQ/issues");
//	}

	mysqli_close($db);
?>
