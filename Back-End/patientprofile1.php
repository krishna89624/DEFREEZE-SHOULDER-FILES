<?php
// Include the database connection file and get the connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Function to fetch patient details by ID
function fetchPatientDetails($conn, $patientId) {
    // Escape the patientId to prevent SQL injection
    $patientId = $conn->real_escape_string($patientId);

    $sql = "SELECT name, contactNo, gender, age, height, weight, painDuration, patientCase, admittedOn, rbs, password, confirmPassword, image, doctorId FROM patientlogin WHERE patientId = '$patientId'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        // Output data of the first row
        $row = $result->fetch_assoc();
        return $row;
    } else {
        return null;
    }
}

// Check if patientId is provided in the request
if (isset($_GET['patientId'])) {
    $patientId = $_GET['patientId'];
    $patientDetails = fetchPatientDetails($conn, $patientId);

    if ($patientDetails) {
        // Add image URI to patient details
        $patientDetails['imageUri'] = $base_url . $patientDetails['image'];

        // Output JSON response
        header('Content-Type: application/json');
        echo json_encode($patientDetails);
    } else {
        echo json_encode(["error" => "Patient not found"]);
    }
} else {
    echo json_encode(["error" => "Patient ID is not provided"]);
}

// Close connection
$conn->close();
?>
