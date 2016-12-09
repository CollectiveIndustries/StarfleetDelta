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
                                                                <th>Department Name</th>
                                                                <th>Class Name</th>
                                                                <th>Class Description</th>
                                                                <th>Passing Score</th>
                                                                </tr>
                                                                <?php
                                                                $result = mysqli_query($db,"SELECT d.`dname`, c.`Class Name`, c.`Class Description`, c.`Required Score` FROM `courses` c INNER JOIN `divisions` d ON c.DivID=d.did ORDER BY c.`Class Name`");
while($row = mysqli_fetch_array($result))
{   //Creates a loop to loop through results
    echo "<tr><td>" . $row['dname'] . "</td><td>" . $row['Class Name'] . "</td><td>" . $row['Class Description'] . "</td><td align='right'>" . $row['Required Score'] . "</td></tr>";
}
mysqli_close($db);
?>
</tr>
</table>
</body>
</center>
</html>
