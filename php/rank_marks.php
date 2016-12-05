<?php
	header('Content-type: text/html; charset=utf-8');
        include("config.php");
        mysqli_set_charset($db,"utf8");

?>
<html>
	<meta charset="utf-8"/>
	<center>
		<head>
			<link rel="stylesheet" href="StarfleetDelta_Theme.css">
		</head>
		<body class="body">
			<table class="outline">
        			<tr class="box">
               				<th>Rank Name</th>
                        		<th>Rank Logo</th>
                		</tr>
<?php
        header('Content-type: text/html; charset=utf-8');

	$query = "SELECT rname, RankLogo FROM `Starfleet Delta`.`Rank`"; //You don't need a ; like you do in SQL
	$result = mysqli_query($db,$query);

//	echo "<table>"; // start a table tag in the HTML

	while($row = mysqli_fetch_array($result))
	{   //Creates a loop to loop through results
		echo "<tr><td>" . $row['rname'] . "</td><td>" . $row['RankLogo'] . "</td></tr>";  //$row['index'] the index here is a field name
	}

//	echo "</table>"; //Close the table in HTML

	mysqli_close(); //Make sure to close out the database connection
?>
</tr>
</table>
</body>
</center>
</html>
