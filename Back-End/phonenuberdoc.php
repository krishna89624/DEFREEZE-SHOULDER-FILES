<?php
require 'dbh.php'; // Include database connection

// Get raw POST data
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Extract values from JSON
$doctorId = isset($data['doctorId']) ? $data['doctorId'] : '';
$phoneNo = isset($data['phoneNo']) ? $data['phoneNo'] : '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($doctorId && $phoneNo) {
        // Check if doctorId and phoneNo exist in the database
        $stmt = $conn->prepare("SELECT 1 FROM doctorlogin WHERE doctorId = ? AND phoneno = ?");
        $stmt->bind_param("ss", $doctorId, $phoneNo);
        $stmt->execute();
        $stmt->store_result();

        $exists = $stmt->num_rows > 0;
        $stmt->close();
        
        // Output response
        header('Content-Type: application/json');
        echo json_encode(['exists' => $exists]);
    } else {
        header('Content-Type: application/json');
        echo json_encode(['exists' => false]);
    }
}

$conn->close();
?>
