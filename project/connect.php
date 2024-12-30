<?php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "project";
$port = 3307; // Specify the correct port

$con = mysqli_connect($host, $user, $pass, $dbname, $port);

if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}
?>
