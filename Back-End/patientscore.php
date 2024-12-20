<?php
header('Content-Type: application/json');

// Include the database connection
require 'dbh.php';

// Check if patientId is set in the URL parameters
if (isset($_GET['patientId'])) {
    $patientId = trim($_GET['patientId']); // Remove any extra whitespace
    error_log("patientId received: $patientId"); // Debug log

    // Query to select data for specific patientId
    try {
        $stmt = $conn->prepare("SELECT * FROM `dash_score` WHERE patientId = ?");
        $stmt->bind_param("s", $patientId);
        $stmt->execute();
        $result = $stmt->get_result();

        // Fetch all rows as associative array
        $results = $result->fetch_all(MYSQLI_ASSOC);

        // Check if any results are returned
        if ($results) {
            echo json_encode($results);
        } else {
            echo json_encode(["error" => "No data found for patientId: $patientId"]);
        }
    } catch (Exception $e) {
        die(json_encode(["error" => "Query failed: " . $e->getMessage()]));
    }
} else {
    echo json_encode(["error" => "Invalid or missing patientId parameter."]);
}

// Close the connection
$conn->close();
?>
