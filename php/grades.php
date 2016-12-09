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
                                                                <th>Name</th>
                                                                <th>Course</th>
                                                                <th>Grade</th>
                                                                </tr>
                                                                <?php
                                                                $result = mysqli_query($db,"SELECT a.`DisplayName`, c.`Class Name`, g.`Grade` FROM `accounts` a INNER JOIN `gradebook` g ON g.`StudentID` = a.`ID` INNER JOIN `courses` c   ON c.`ClassID` = g.`CourseID` INNER JOIN `divisions` d ON c.`DivID` = d.`did` ORDER BY a.`DisplayName`");
while($row = mysqli_fetch_array($result))
{   //Creates a loop to loop through results
    echo "<tr><td>" . $row['DisplayName'] . "</td><td>" . $row['Class Name'] . "</td><td align='right'>" . $row['Grade'] . "</td></tr>";
}
mysqli_close($db);
?>
</tr>
</table>
</body>
</center>
</html>
