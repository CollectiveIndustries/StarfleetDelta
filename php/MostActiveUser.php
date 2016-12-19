<?php
header('Content-type: text/html; charset=utf-8');
include("config.php");
mysqli_set_charset($db,"utf8");

// Grab the top 5 most active members from the Time clock
$ActiveMembers = "SELECT IFNULL(a.DisplayName,a.username) AS `name`, SEC_TO_TIME(SUM(`time_out` - `time_in`)) AS `total` FROM `Time Clock` as t JOIN `accounts` a ON t.user_id = a.ID GROUP BY t.`user_id` ORDER BY total DESC LIMIT 5";


function MembersByTime($db,$sql)
{
    if(!$result = mysqli_query($db,$sql))
    {
        die("ERROR-MembersByTime-".mysqli_error($db));
    }
    echo "CLOCK?";
    while($row = mysqli_fetch_array($result))
    {
        $str = $row['name'].$row['total'];
        echo "  ".$row['name'].str_pad(" ", 36 - strlen($str)).$row['total']."|";
    }
}

MembersByTime($db,$ActiveMembers);
?>
