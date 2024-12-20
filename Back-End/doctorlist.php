<?php
// Include the database connection file and get the connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Get the doctor ID from the request
$doctorId = isset($_GET['doctorId']) ? $_GET['doctorId'] : '';

if (empty($doctorId)) {
    // Invalid doctor ID
    $response = array("status" => "error", "message" => "Invalid doctor ID");
    header('Content-Type: application/json');
    echo json_encode($response);
    exit();
}

// Prepare SQL query to fetch all patients for the specified doctor in reverse order of creation date
$sql = "SELECT * FROM patientlogin WHERE doctorId = ? ORDER BY created_at DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $doctorId); // 's' for string
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $patients = array();
    // Loop through each patient
    while ($row = $result->fetch_assoc()) {
        // Check if the image field exists and append the base URL to the image path to form the complete image URL
        if (isset($row['image'])) {
            $row['image'] = $base_url . $row['image'];
        }
        $patients[] = $row;
    }

    // Close connection
    $stmt->close();
    $conn->close();

    // Return patients array as JSON response
    header('Content-Type: application/json');
    echo json_encode($patients);
} else {
    // No patients found
    $response = array("status" => "error", "message" => "No patients found");
    header('Content-Type: application/json');
    echo json_encode($response);

    // Close connection
    $stmt->close();
    $conn->close();
}
?>
