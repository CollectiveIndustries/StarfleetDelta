<?php
header('Content-type: text/html; charset=utf-8');
include("config.php");
mysqli_set_charset($db,"utf8");

$type = $_POST['stat'];

if($type == "rank")
{
    echo "Rank | Numer of People\n";
    $query = "SELECT r.rname AS `name`, COUNT(*) AS `people` FROM `Rank` r INNER JOIN `accounts` a ON a.RankID=r.RankID GROUP BY r.RankID ORDER BY r.RankID";
}
elseif( $type == "division")
{
    echo "Division | Numer of People\n";
    $query = "SELECT d.dname AS `name`, COUNT(*) AS `people` FROM `divisions` d INNER JOIN `accounts` a ON a.DivID=d.did GROUP BY d.did ORDER BY name";
}

$result = mysqli_query($db,$query);

while($row = mysqli_fetch_array($result))
{   //Creates a loop to loop through results
    echo $row['name'] . " | " . $row['people'] . "\n";  //$row['index'] the index here is a field name
}
?>
