<?php
header('Content-Type: application/json');

// Include the database connection file
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Check if patientId and status are set in the GET request
if (isset($_GET['patientId']) && isset($_GET['status'])) {
    // Escape input parameters to prevent SQL injection
    $patientId = $conn->real_escape_string($_GET['patientId']);
    $status = $conn->real_escape_string($_GET['status']);

    // SQL query to fetch appointments
    $sql = "SELECT id, appointmentId, doctorId, doctorname, specialization, experience, 
                   doctorImage, patientId, name, patientCase, patientImage, date, 
                   start_time, end_time, status, created_at
            FROM doctorappointments
            WHERE patientId = ? AND status = ?";

    // Prepare and execute the query
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("ss", $patientId, $status);
        $stmt->execute();
        $result = $stmt->get_result();

        // Check if any rows are returned
        if ($result->num_rows > 0) {
            $appointments = array();
            
            // Fetch each row and modify the image URLs
            while ($row = $result->fetch_assoc()) {
                $row['doctorImage'] = $base_url . $row['doctorImage'];
                $row['patientImage'] = $base_url . $row['patientImage'];
                $appointments[] = $row;
            }
            // Output the result as a JSON array
            echo json_encode($appointments);
        } else {
            // Output an empty JSON array if no records are found
            echo json_encode(array()); 
        }

        $stmt->close();
    } else {
        echo json_encode(array('error' => 'Failed to prepare SQL statement'));
    }
} else {
    // Output an error message if parameters are invalid
    echo json_encode(array('error' => 'Invalid parameters'));
}

// Close the database connection
$conn->close();
?>
