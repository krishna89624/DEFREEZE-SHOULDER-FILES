<?php
require 'dbh.php'; // Include database connection

// Get raw POST data
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Extract values from JSON
$patientId = isset($data['patientId']) ? $data['patientId'] : '';
$contactNo = isset($data['contactNo']) ? $data['contactNo'] : '';

// Initialize variables
$doctorDetails = [];
$error = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($patientId && $contactNo) {
        // Check if the contactNo is valid for the given patientId
        $stmt = $conn->prepare("SELECT contactNo FROM patientlogin WHERE patientId = ?");
        $stmt->bind_param("s", $patientId);
        $stmt->execute();
        $stmt->store_result();
        
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($existingContactNo);
            $stmt->fetch();
            if ($existingContactNo === $contactNo) {
                // Fetch associated doctor IDs and contact numbers
                $stmt = $conn->prepare("SELECT doctorId, contactNo FROM patientlogin WHERE patientId = ?");
                $stmt->bind_param("s", $patientId);
                $stmt->execute();
                $stmt->store_result();
                
                if ($stmt->num_rows > 0) {
                    $stmt->bind_result($doctorId, $doctorContactNo);
                    while ($stmt->fetch()) {
                        $doctorDetails[] = [
                            'doctorId' => $doctorId,
                            'contactNo' => $doctorContactNo
                        ];
                    }
                } else {
                    $error = "No doctor details found for the given patient ID.";
                }
                $stmt->close();
            } else {
                $error = "Invalid contact number.";
            }
        } else {
            $error = "Patient ID not found.";
        }
    } else {
        $error = "Patient ID and Contact Number are required.";
    }
}

$conn->close();

// Output response
header('Content-Type: application/json');
$response = [
    'doctorDetails' => $doctorDetails,
    'error' => $error
];
echo json_encode($response);
?>
