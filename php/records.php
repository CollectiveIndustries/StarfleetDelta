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
                                        <div class="middlediv">
                                                    <div class="outline">
                                                                <div style = "color:#FDD017; margin:30px">
                                                                        <form action="updategradebook.php" method = "post">Legacy Name:<br>
                                                                                <input style = "background-color:#6D6968;" type="text" name="name" value="YourName Resident"><br><br>
                                                                                        <select style = "background-color:#6D6968;">
                                                                                                <?php
                                                                                                $result = mysqli_query($db,"SELECT `ClassID`,`Class Name`  FROM `courses`");
while($row = mysqli_fetch_array($result))
{   //Creates a loop to loop through results
    echo "<option>" . $row['ClassID'] . " ". $row['Class Name'] . "</option>";
}
mysqli_close($db);
?>
</select>
<br><br>Score:<br>
<input style = "background-color:#6D6968;" type="text" name="score"><br><br>
               <input type="submit" value=" Engage! ">
                           </form>
