<?php
// Include the database connection file
require 'dbh.php'; // Ensure this file sets up $conn as a mysqli connection

// Check if patientId and status are provided in GET parameters
if (isset($_GET['patientId']) && isset($_GET['status'])) {
    // Sanitize inputs to prevent SQL injection
    $patientId = $conn->real_escape_string($_GET['patientId']);
    $status = $conn->real_escape_string($_GET['status']);

    // SQL query to retrieve appointments based on patientId and status
    $sql = "SELECT `id`, `appointmentId`, `doctorId`, `doctorname`, `specialization`, `experience`, 
                   `doctorImage`, `patientId`, `name`, `patientCase`, `patientImage`, `date`, `time`, 
                   `status`, `created_at`, `start_time`, `end_time`
            FROM `patientappointments`
            WHERE `patientId` = ? AND `status` = ?";

    // Prepare and execute the query
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ss', $patientId, $status);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if any appointments were found
    if ($result->num_rows > 0) {
        // Fetch data and store in an array
        $appointments = array();
        while ($row = $result->fetch_assoc()) {
            // No need to prepend the base URL to image paths
            $appointments[] = $row;
        }
        // Return appointments as JSON
        echo json_encode($appointments);
    } else {
        // No appointments found
        echo json_encode(array()); // Return an empty array
    }

    $stmt->close();
} else {
    // Invalid parameters
    echo json_encode(array('error' => 'Invalid parameters'));
}

// Close database connection
$conn->close();
?>
