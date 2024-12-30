<?php
header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: GET, POST"); 
header("Access-Control-Allow-Headers: Content-Type"); 

error_reporting(0);

include("../connect.php");

$name = $_POST['user_name'];
$email = $_POST['user_email'];
$psw = $_POST['user_psw'];

$sql = "insert into users (user_name, user_email, user_psw) values ('$name','$email','$psw')";
$result = $con->query($sql);

if($result)
{
    echo json_encode("success");
}

?>