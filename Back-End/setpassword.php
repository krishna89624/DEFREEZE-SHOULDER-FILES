<?php
require 'dbh.php'; // Include database connection

// Get raw POST data
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Extract values from JSON
$doctorId = isset($data['doctorId']) ? $data['doctorId'] : '';
$password = isset($data['password']) ? $data['password'] : '';
$confirmPassword = isset($data['confirmPassword']) ? $data['confirmPassword'] : '';
$phoneNo = isset($data['phoneNo']) ? $data['phoneNo'] : ''; // Extract phone number

// Initialize variables
$error = '';
$message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($doctorId && $phoneNo) {
        // Check if doctorId and phoneNo exist
        $stmt = $conn->prepare("SELECT doctorId, phoneno FROM doctorlogin WHERE doctorId = ? AND phoneno = ?");
        $stmt->bind_param("ss", $doctorId, $phoneNo);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $stmt->bind_result($fetchedDoctorId, $fetchedPhoneNo); // Fetch columns
            $stmt->fetch();
            $stmt->close();

            // Handle password update
            if ($password === $confirmPassword) {
                // Update the password in the database without hashing
                $updateStmt = $conn->prepare("UPDATE doctorlogin SET password = ? WHERE doctorId = ?");
                $updateStmt->bind_param("ss", $password, $doctorId);
                if ($updateStmt->execute()) {
                    $message = "Password updated successfully!";
                } else {
                    $error = "Error updating password.";
                }
                $updateStmt->close();
            } else {
                $error = "Passwords do not match.";
            }
        } else {
            $stmt->close();
            $error = "Doctor ID or phone number not found. Please enter a correct Doctor ID and phone number.";
        }
    } else {
        $error = "Doctor ID and phone number are required.";
    }
}

$conn->close();

// Output response
header('Content-Type: application/json');
$response = [
    'success' => empty($error),
    'message' => $message,
    'error' => $error
];
echo json_encode($response);
?>
