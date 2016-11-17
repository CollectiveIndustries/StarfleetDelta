<?php
   include("config.php");
   include("functions.php");
   session_start();

   if($_SERVER["REQUEST_METHOD"] == "POST") {
      // username and password sent from form

      $myusername = mysqli_real_escape_string($db,$_POST['username']);
      $mypassword = mysqli_real_escape_string($db,$_POST['password']);

      $sql = "SELECT ID FROM accounts WHERE username = '$myusername' and password = SHA2('$mypassword', 512)";
      $result = mysqli_query($db,$sql);
      $row = mysqli_fetch_array($result);
      $active = $row['active'];

      $count = mysqli_num_rows($result);

      // If result matched $myusername and $mypassword, table row must be 1 row

      if($count == 1)
      {
         session_register("myusername");
         $_SESSION['login_user'] = $myusername;

         redirect("welcome.php");
	 exit();
      }else{
         $error = "ERROR: Your Login Name or Password is invalid<br>POST USER: ".$_POST['username']."<br>POST PASSWORD: ".$_POST['password']."<br>myusername: ".$myusername."<br>mypassword: ".$mypassword."<br> Result Count: ".$count;
      }
   }
?>

<html>
   <head>
      <title>UFGQ Login Portal</title>

      <style type = "text/css">
         body {
            font-family:Arial, Helvetica, sans-serif;
            font-size:14px;
         }

         label {
            font-weight:bold;
            width:100px;
            font-size:14px;
         }

         .box {
		border:#666666 solid 1px;
         }
	.middleDiv {
               position : absolute;
               width    : 300px;
               height   : 500px;
               left     : 50%;
               top      : 50%;
               margin-left : -150px; /* half of the width  */
               margin-top  : -250px; /* half of the height */
        }
      </style>

   </head>

   <body class="middleDiv" bgcolor = "#000000">

      <div align = "center">
         <div style = "width:300px; border: solid 1px #0000A0;" align = "center">
            <div style = "background-color:#0000A0; color:#FDD017; padding:3px;"><b>UFGQ Login Portal</b></div>

            <div style = "color:#FDD017; margin:30px">

               <form action = "" method = "post">
                  <label>User Name  :</label><input style = "background-color:#6D6968;" type = "text" name = "username" class = "box"/><br/><br/>
                  <label>Password   :</label><input style = "background-color:#6D6968;" type = "password" name = "password" class = "box"/><br/><br/>
                  <input type = "submit" value = " Engage! "/><br />
               </form>

               <div style = "font-size:13px; font-weight: 600; color:#cc0000; margin-top:10px"><?php echo $error; ?></div>

            </div>

         </div>

      </div>

   </body>
</html>
