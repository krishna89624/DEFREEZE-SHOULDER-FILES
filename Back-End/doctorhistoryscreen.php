<?php
// Include the database connection file
require 'dbh.php';

// Check if patientId and status are provided in GET parameters
if (isset($_GET['patientId']) && isset($_GET['status'])) {
    // Sanitize inputs to prevent SQL injection
    $patientId = $conn->real_escape_string($_GET['patientId']);
    $status = $conn->real_escape_string($_GET['status']);

    // SQL query to retrieve appointments based on patientId and status
    $sql = "SELECT `id`, `appointmentId`, `doctorId`, `doctorname`, `specialization`, `experience`, 
                   `patientId`, `name`, `patientCase`, `date`, `start_time`, 
                   `end_time`, `status`, `created_at`
            FROM `doctorappointments`
            WHERE `patientId` = '$patientId' AND `status` = '$status'";

    // Execute the query
    $result = $conn->query($sql);

    // Check if any appointments were found
    if ($result->num_rows > 0) {
        // Fetch data and store in an array
        $appointments = array();
        while ($row = $result->fetch_assoc()) {
            $appointments[] = $row;
        }
        // Return appointments as JSON
        echo json_encode($appointments);
    } else {
        // No appointments found
        echo json_encode(array()); // Return an empty array
    }
} else {
    // Invalid parameters
    echo json_encode(array('error' => 'Invalid parameters'));
}

// Close database connection
$conn->close();
?>
