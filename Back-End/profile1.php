<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');
require "dbh.php"; // Connect to the database

// Get the raw POST data as a string
$json_data = file_get_contents("php://input");

// Decode the JSON data into an associative array
$request_data = json_decode($json_data, true); 

// Check if required keys exist in $request_data
if (isset($request_data['patient_id']) && isset($request_data['name']) && isset($request_data['contactNo']) && isset($request_data['age']) && isset($request_data['gender']) && isset($request_data['height']) && isset($request_data['weight']) && isset($request_data['patientCase']) && isset($request_data['painDuration']) && isset($request_data['admittedOn']) && isset($request_data['rbs']) && isset($request_data['password']) && isset($request_data['confirmPassword']) && isset($_FILES['image'])) {
    // Get patient details
    $patientId = $request_data['patient_id'];
    $name = $request_data['name'];
    $contactNo = $request_data['contactNo'];
    $age = $request_data['age'];
    $gender = $request_data['gender'];
    $height = $request_data['height'];
    $weight = $request_data['weight'];
    $patientCase = $request_data['patientCase'];
    $painDuration = $request_data['painDuration'];
    $admittedOn = $request_data['admittedOn'];
    $rbs = $request_data['rbs'];
    $password = $request_data['password'];
    $confirmPassword = $request_data['confirmPassword'];

    // Check if passwords match
    if ($password !== $confirmPassword) {
        $response['status'] = "error";
        $response['message'] = "Passwords do not match";
    } else {
        // Image file details
        $image_name = $_FILES['image']['name'];
        $image_tmp_name = $_FILES['image']['tmp_name'];
        $image_size = $_FILES['image']['size'];
        $image_error = $_FILES['image']['error'];

        // Check if image is uploaded without errors
        if ($image_error === 0) {
            $image_destination = 'uploads/' . $image_name;
            move_uploaded_file($image_tmp_name, $image_destination);

            // Registration
            $sql = "INSERT INTO patientlogin (patient_id, name, contactNo, age, gender, height, weight, patientCase, painDuration, admittedOn, rbs, password, confirmPassword, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$patientId, $name, $contactNo, $age, $gender, $height, $weight, $patientCase, $painDuration, $admittedOn, $rbs, $password, $confirmPassword, $image_destination]);

            // Check if the insertion was successful
            if ($stmt->rowCount() > 0) {
                $response['status'] = "success";
                $response['message'] = "Patient registration successful!";
            } else {
                $response['status'] = "error";
                $response['message'] = "Failed to register patient";
            }

            // Close the prepared statement
            $stmt->closeCursor();
        } else {
            $response['status'] = "error";
            $response['message'] = "Error uploading image";
        }
    }
} else {
    // Handle the case where required data is missing
    $response['status'] = "error";
    $response['message'] = "Invalid request data";
}

// Close the database connection
$conn = null;

// Respond with JSON
echo json_encode($response);
?>
