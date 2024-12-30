<? php  
header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: GET, POST"); 
header("Access-Control-Allow-Headers: Content-Type"); 


include("../connect.php");

$email = $_POST["user_email"];
$pass = $_POST["user_psw"];

$sql = "select * from users where user_email = '$email' and user_psw = '$pass'";
$res = $con->query($sql);

$count = $res->num_rows;

if($count > 0){
    $sql = "select * from users where email = '$email'";
    $res = $con->query($sql);
    while($row = $res->fetch_assoc()){
        $data[] = $row;
    }
    echo json_encode(array("result"=>$data));

}else{
    echo json_encode(array("result"=>"not here"));
}

?>