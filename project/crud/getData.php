<?php

include("../connect.php");

$sql ="select * from users";
$result = $con->query($sql);

while($row = $result->fetch_assoc())
{
    $data[]=$row;
}
echo json_encode($data);

?>