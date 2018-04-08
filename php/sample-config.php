<?php
$DB_SERVER = "";
$DB_USERNAME = "";
$DB_PASSWORD = "";
$DB_DATABASE = "";
$DB_PORT = "";
$db = mysqli_connect($DB_SERVER, $DB_USERNAME, $DB_PASSWORD,$DB_DATABASE, $DB_PORT);
if(mysqli_connect_errno()) { die('Databse Connection Error - ' . mysqli_connect_error())
?>

