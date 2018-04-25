<?php
$error = $_GET["error"];


if($error == "404"){
$error_num = "404";
$error_text = "Error 404 : The resource you are requesting can not be found";
}
else{
$error_num = "500";
$error_text = "Error 500 : Application Error";
}

?>
<!DOCTYPE html>
<html lang=en>
    <head>
  <meta charset=utf-8>
  <meta name=viewport content="initial-scale=1, minimum-scale=1, width=device-width">
  <link rel="stylesheet" href="style.css">
  <title>Error <?php echo $error_num; ?></title>
  </style>
  </head>
  <a href=//www.starfleetdelta.com/><span id=logo aria-label=Omega-Grid></span></a>
  <p><b><?php echo $error_num; ?>.</b> <ins>That's an error.</ins>
<p><?php echo $error_text; ?></p>
  <p>A Error Has Occured, It Might Be Because/Caused By:<br>  
      <ins>
<?php
$myArray = file('excuses.txt');

$input = array_combine($myArray, $myArray); 
$rand_keys = array_rand($input, 2);
echo $input[$rand_keys[0]] . "\n";
?>
      
      
      
      </ins>
