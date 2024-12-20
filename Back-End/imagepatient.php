<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Include the database connection file and get the connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Function to fetch patient image URI by ID
function fetchPatientImage($conn, $patientId, $base_url) {
    // Escape the patientId to prevent SQL injection
    $patientId = $conn->real_escape_string($patientId);

    $sql = "SELECT image FROM patientlogin WHERE patientId = '$patientId'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        // Output data of the first row
        $row = $result->fetch_assoc();

        // Return the complete image URI
        return $row['image'] ? $base_url . $row['image'] : null;
    } else {
        return null;
    }
}

// Check if patientId is provided in the request
if (isset($_GET['patientId'])) {
    $patientId = $_GET['patientId'];
    $imageUri = fetchPatientImage($conn, $patientId, $base_url);

    if ($imageUri) {
        // Output image URI
        echo json_encode(array('image' => $imageUri));
    } else {
        echo json_encode(array('error' => 'Image not found for the patient'));
    }
} else {
    echo json_encode(array('error' => 'Patient ID is not provided'));
}

// Close connection
$conn->close();
?>
