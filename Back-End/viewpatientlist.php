<?php
// Include the database connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$baseUrl = $dbh['base_url']; // Extract the base URL

// Prepare SQL query to fetch all patients
$sql = "SELECT * FROM patientlogin";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $patients = array();
    
    // Loop through each patient
    while ($row = $result->fetch_assoc()) {
        // Check if the image field exists and append the base URL to the image path to form the complete image URL
        if (isset($row['image'])) {
            $row['image'] = $baseUrl . $row['image']; // Use the base URL
        }
        $patients[] = $row;
    }
    
    // Close connection
    $conn->close();
    
    // Return patients array as JSON response
    header('Content-Type: application/json');
    echo json_encode($patients);
} else {
    // No patients found
    $response = array("status" => "error", "message" => "No patients found");
    echo json_encode($response);
}
?>
