<?php
header( 'Content-type: text/html; charset=utf-8' );
include( "config.php" );
mysqli_set_charset( $db,"utf8" );
$DivHeaders = "SELECT `did`, `dname` FROM `divisions` WHERE NOT did='10' ORDER BY `dname`";
?>
<html>
<meta charset="utf-8"/>
              <center>
              <head>
              <link rel="stylesheet" href="StarfleetDelta_Theme.css">
                        </head>
                        <body class="body">
                                        <h1>Active Members By Division</h1>
                                        <?php
                                        $DivResult = mysqli_query( $db,$DivHeaders );
if( !$DivResult )
{
    echo "<h2>ERROR: " . mysqli_error( $db ) . "</h2>";
}

while( $DivHeaders = mysqli_fetch_array( $DivResult ) )
{
    $MembersByDivision = "SELECT r.RankLogo, r.rname, IFNULL(a.DisplayName, a.username) AS `name`, t.tag_name, a.`UUID` FROM `accounts` a INNER JOIN `divisions` d ON a.`DivID` = d.`did` INNER JOIN `Rank` r ON a.`RankID` = r.`RankID` INNER JOIN `Titles` t ON a.`TitleID` = t.`tid` WHERE a.active = '1' AND NOT d.did='10' AND d.did = '" . $DivHeaders['did'] . "' ORDER BY r.`RankID`";

    echo "<h3>" . $DivHeaders['dname'] . "</h3>";
    echo "<table class='outline'><tr class='box'><th>Rank</th><th>Name</th><th>Title</th></tr>";//Set up each table on the page

    $result = mysqli_query( $db,$MembersByDivision );
    if( !$result )
    {
        echo "<tr><td>ERROR</tr><tr>" . mysqli_error( $db ) . "</tr></td>";
    }

    while( $row = mysqli_fetch_array( $result ) )
    {
        //Creates a loop to loop through results
        echo "<tr><td align='center'>" . $row['rname'] . "<br>" . $row['RankLogo'] . "</td><td><a href='secondlife:///app/agent/" . $row['UUID'] . "/about' style='color:#FDD017'>" . $row['name'] . "</a></td><td align='left'>" . $row['tag_name'] . "</td></tr>";
    }
    echo "</table>";
}
mysqli_close( $db );
?>
</tr>
</table>
</body>
</center>
</html>
