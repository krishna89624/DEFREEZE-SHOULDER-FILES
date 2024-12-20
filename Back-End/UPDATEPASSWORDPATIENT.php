<?php
require 'dbh.php'; // Include database connection

// Get the raw POST data
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Extract values from JSON
$patientId = isset($data['patientId']) ? $data['patientId'] : '';
$doctorId = isset($data['doctorId']) ? $data['doctorId'] : '';

// Initialize variables
$patientExists = false;
$error = '';
$message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check if the patientId and doctorId match in the database
    $stmt = $conn->prepare("SELECT id FROM patientlogin WHERE patientId = ? AND doctorId = ?");
    $stmt->bind_param("ss", $patientId, $doctorId);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $patientExists = true;

        // Handle JSON input for password update
        if (isset($data['updatePassword'])) {
            $password = isset($data['password']) ? $data['password'] : '';
            $confirmPassword = isset($data['confirmPassword']) ? $data['confirmPassword'] : '';

            if ($password === $confirmPassword) {
                // Update the password in the database
                $updateStmt = $conn->prepare("UPDATE patientlogin SET password = ? WHERE patientId = ? AND doctorId = ?");
                $updateStmt->bind_param("sss", $password, $patientId, $doctorId);
                if ($updateStmt->execute()) {
                    $message = "Password updated successfully!";
                } else {
                    $error = "Error updating password.";
                }
                $updateStmt->close();
            } else {
                $error = "Passwords do not match.";
            }
        }
    } else {
        $error = "Patient ID or Doctor ID not found.";
    }

    $stmt->close();
}

$conn->close();

// Output response
header('Content-Type: application/json');
$response = [
    'success' => $patientExists,
    'message' => $message,
    'error' => $error
];
echo json_encode($response);
?>
