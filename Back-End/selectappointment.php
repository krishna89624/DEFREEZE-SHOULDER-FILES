<?php
header('Content-Type: application/json');

// Include the database connection file and get the connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Check if patientId is set in the query parameters
if (isset($_GET['patientId'])) {
    $patientId = $_GET['patientId'];

    // SQL query to fetch patient and doctor details for the specified patientId
    $sql = "
        SELECT 
            p.patientId, 
            p.name,
            p.patientCase,
            p.image AS patientImage,
            p.doctorId, 
            d.doctorname, 
            d.experience, 
            d.specialization, 
            d.image AS doctorImage
        FROM 
            patientlogin p
        JOIN 
            doctorlogin d ON p.doctorId = d.doctorId
        WHERE 
            p.patientId = ?
    ";

    // Prepare and execute the query
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param('s', $patientId);
        $stmt->execute();
        $result = $stmt->get_result();

        // Fetch the result
        if ($result->num_rows > 0) {
            $result_data = $result->fetch_assoc();
            $result_data['patientImage'] = $base_url . $result_data['patientImage'];
            $result_data['doctorImage'] = $base_url . $result_data['doctorImage'];
            echo json_encode($result_data);
        } else {
            echo json_encode(["error" => "No data found for patient ID: $patientId"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "Failed to prepare SQL statement"]);
    }
} else {
    echo json_encode(["error" => "No patientId specified"]);
}

// Close the connection
$conn->close();
?>
