<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

require "dbh.php"; 

$json_data = file_get_contents("php://input");

$request_data = json_decode($json_data, true);

$response = array(); 

if (isset($request_data['patientId']) && isset($request_data['password'])) {
    $patientId = $request_data['patientId'];
    $password = $request_data['password'];

    $sql_select = "SELECT name, image, patientCase, contactNo FROM patientlogin WHERE patientId = ? AND password = ?";
    $stmt_select = $conn->prepare($sql_select);
    if ($stmt_select) {
        $stmt_select->bind_param("ss", $patientId, $password);
        $stmt_select->execute();
        $stmt_select->store_result();

        if ($stmt_select->num_rows > 0) {
            $stmt_select->bind_result($name, $image, $patientCase, $contactNo);
            $stmt_select->fetch();

            $response['status'] = "success";
            $response['message'] = "Login successful!";
            $response['name'] = $name; 
            $response['image'] = $image; 
            $response['patientCase'] = $patientCase; 
            $response['contactNo'] = $contactNo; 
        } else {
            $response['status'] = "error";
            $response['message'] = "Invalid patient ID or password";
        }

        $stmt_select->close();
    } else {
        $response['status'] = "error";
        $response['message'] = "Failed to prepare the SQL statement";
    }
} else {
    $response['status'] = "error";
    $response['message'] = "Invalid request data";
}

$conn->close();

echo json_encode($response);
?>
