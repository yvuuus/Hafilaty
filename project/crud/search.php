<?php
header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: GET, POST"); 
header("Access-Control-Allow-Headers: Content-Type"); 

include("../connect.php");

$depart = $_POST['depart'];
$destination = $_POST['destination'];

$sql = "SELECT * FROM schedule WHERE depart LIKE '%$depart%' AND destination LIKE '%$destination%'";
$result = $con->query($sql);

$data = [];
while($row = $result->fetch_assoc()) {
    $data[] = $row;
}
echo json_encode($data);
?>
