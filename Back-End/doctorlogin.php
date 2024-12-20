<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Include the database connection file and get the connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

$json_data = file_get_contents("php://input");
$request_data = json_decode($json_data, true);

$response = array();
if (isset($request_data['doctorId']) && isset($request_data['password'])) {
    $doctorId = $request_data['doctorId'];
    $password = $request_data['password'];

    $sql_select = "SELECT doctorname, image, specialization FROM doctorlogin WHERE doctorId = ? AND password = ?";
    $stmt_select = $conn->prepare($sql_select);
    if ($stmt_select) {
        $stmt_select->bind_param("ss", $doctorId, $password);
        $stmt_select->execute();
        $stmt_select->store_result();

        if ($stmt_select->num_rows > 0) {
            $stmt_select->bind_result($doctorname, $image, $specialization);
            $stmt_select->fetch();

            $response['status'] = "success";
            $response['message'] = "Login successful!";
            $response['doctorname'] = $doctorname;
            $response['image'] = $image ? $base_url . $image : null; // Use the dynamic base URL
            $response['specialization'] = $specialization;
        } else {
            $response['status'] = "error";
            $response['message'] = "Invalid doctor ID or password";
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
