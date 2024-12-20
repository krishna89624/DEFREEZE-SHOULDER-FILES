<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

require "dbh.php"; // Include the database connection script

$json_data = file_get_contents("php://input"); // Get the raw POST data as a string
$request_data = json_decode($json_data, true); // Decode the JSON data into an associative array

$response = array(); // Initialize an array to store the response

// Check if 'adminId' and 'password' keys exist in $request_data
if (isset($request_data['adminId']) && isset($request_data['password'])) {
    $adminId = $request_data['adminId'];
    $password = $request_data['password'];

    // Prepare the SQL statement to prevent SQL injection
    $sql = "SELECT * FROM adminlogin WHERE adminId = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    if ($stmt) {
        // Bind parameters
        $stmt->bind_param("ss", $adminId, $password);
        // Execute the statement
        $stmt->execute();
        // Store the result
        $stmt->store_result();

        // Check if login credentials are valid
        if ($stmt->num_rows > 0) {
            $response['status'] = "success";
            $response['message'] = "Login successful!";
        } else {
            $response['status'] = "error";
            $response['message'] = "Invalid admin ID or password";
        }

        // Close the statement
        $stmt->close();
    } else {
        $response['status'] = "error";
        $response['message'] = "Failed to prepare the SQL statement";
    }
} else {
    $response['status'] = "error";
    $response['message'] = "Invalid request data";
}

$conn->close(); // Close the database connection

echo json_encode($response); // Respond with JSON
?>
