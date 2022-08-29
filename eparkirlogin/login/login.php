<?php 

  //MySQL database Connection
  require "../conn.php";	
  
  //Received JSON into $json variable
  $json = file_get_contents('php://input');
  
  //Decoding the received JSON and store into $obj variable.
  $obj = json_decode($json,true);
  
  if(isset($obj["email"]) && isset($obj["password"])){
    
    $email = mysqli_real_escape_string($con,$obj['email']);
    $password = mysqli_real_escape_string($con,$obj['password']);
    
    //Declare array variable
    $result=[];
    
    //Select Query
    $sql="SELECT * FROM users WHERE email='{$email}' and password = md5('{$password}')";
    $res=$con->query($sql);
    
    if($res->num_rows>0){
      
      $row=$res->fetch_assoc();
      
      $result['loginStatus']=true;
      $result['message']="Login Successfully";
      
      $result["userInfo"]=$row;

      
    }else{
      
      $result['loginStatus']=false;
      $result['message']="Invalid Login Details";
    }
    
    // Converting the array into JSON format.
    $json_data=json_encode($result);
      
    // Echo the $json.
    echo $json_data;
  }
?>