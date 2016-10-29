<?php
	$NewAccount = false;
	include("config.php");
	$uuid = $_POST['uuid'];
	$name = $_POST['name'];

	$ERROR = "\n\nFailed to update Users Time Card.\nContact Captain Morketh Sorex UFGQ IT Department with the provided Error Message\nFor bug Reports/Updates\nhttps://github.com/CollectiveIndustries/UFGQ/issues"


// SQL statments
	$NEW_AVY_SQL = "INSERT INTO `ufgq`.`accounts` (`UUID`, `username`) VALUES ('$uuid', '$name')";
	$SelectAV = "SELECT ID FROM `ufgq`.`accounts` WHERE `UUID` = '$uuid'";
	$OnFileInsert = "INSERT INTO ufgq.`Time Clock` (user_id) SELECT id FROM accounts a WHERE a.`UUID` = '$uuid'";

	if (0 == mysqli_num_rows(mysqli_query($db,$SelectAV)) ) // Is there a record already?
	{
		if(!mysqli_query($db,$NEW_AVY_SQL)) // Create a new entry in the accoutns table
		{
			echo "ERROR: " . $NEW_AVY_SQL . "\n" . mysqli_error($db);
			die($ERROR);
		}
		mysqli_commit();
		$NewAccount = true;
	}
	else // Record exists NewAccount is false
	{
		$NewAccount = false;
	}

// Once the Account is on file we can just log the user right in
	if(mysqli_query($db,$OnFileInsert))
	{
		mysqli_commit();
	}
	else // If error kill the script and post the error.
	{
		echo "Error: " . $OnFileInsert . "\n\n" . mysqli_error($db);
		echo "\nNewAccount: " . $NewAccount;
		die($ERROR);
	}

	mysqli_close($db);
?>
