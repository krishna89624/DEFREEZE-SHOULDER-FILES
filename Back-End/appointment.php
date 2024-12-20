<?php
// Include the database connection and base URL
$dbh = include 'dbh.php';
$conn = $dbh['conn'];
$base_url = $dbh['base_url'];

if (isset($_GET['doctorId']) && isset($_GET['status'])) {
    $doctorId = $conn->real_escape_string($_GET['doctorId']);
    $status = $conn->real_escape_string($_GET['status']);

    $sql = "SELECT `id`, `appointmentId`, `doctorId`, `doctorname`, `specialization`, `experience`, 
                   `doctorImage`, `patientId`, `name`, `patientCase`, `patientImage`, `date`, `time`, 
                   `status`, `created_at`, `start_time`, `end_time`
            FROM `patientappointments`
            WHERE `doctorId` = ? AND `status` = ?";

    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("ss", $doctorId, $status);
        $stmt->execute();
        $result = $stmt->get_result();

        // Check if any appointments were found
        if ($result->num_rows > 0) {
            // Fetch data and store in an array
            $appointments = array();
            while ($row = $result->fetch_assoc()) {
                // Prepend base URL to image paths
                $row['doctorImage'] = $base_url . $row['doctorImage'];
                $row['patientImage'] = $base_url . $row['patientImage'];

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
        echo json_encode(array('error' => 'Failed to prepare SQL statement'));
    }
} else {
    // Invalid parameters
    echo json_encode(array('error' => 'Invalid parameters'));
}

// Close database connection
$conn->close();
?>
