<?php
header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: GET, POST"); 
header("Access-Control-Allow-Headers: Content-Type"); 

include("../connect.php");

$sql ="select * from schedule";
$result = $con->query($sql);

while($row = $result->fetch_assoc())
{
    $data[]=$row;
}
echo json_encode($data);

?>