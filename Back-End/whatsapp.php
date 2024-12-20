<?php
header('Content-Type: application/json');

// Include the database connection file
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Check if patientId is set in the query parameters
if (isset($_GET['patientId'])) {
    $patientId = $_GET['patientId'];

    $sql = "
        SELECT 
            p.patientId, 
            p.name AS patient_name, 
            p.contactNo AS patient_contactNo, 
            p.age AS patient_age, 
            p.gender AS patient_gender, 
            p.height AS patient_height, 
            p.weight AS patient_weight, 
            p.patientCase AS patient_case, 
            p.painDuration AS patient_painDuration, 
            p.admittedOn AS patient_admittedOn, 
            p.rbs AS patient_rbs, 
            p.password AS patient_password, 
            p.confirmPassword AS patient_confirmPassword, 
            p.image AS patient_image, 
            p.doctorId, 
            d.doctorname, 
            d.phoneno AS doctor_phone, 
            d.experience, 
            d.specialization, 
            d.image AS doctor_image
        FROM 
            patientlogin p
        JOIN 
            doctorlogin d ON p.doctorId = d.doctorId
        WHERE 
            p.patientId = ?
    ";

    // Prepare and execute the query
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('s', $patientId);
    $stmt->execute();
    $result = $stmt->get_result();

    // Fetch the result and output in JSON format with the full image URL
    if ($row = $result->fetch_assoc()) {
        $row['patient_image'] = $base_url . $row['patient_image'];
        $row['doctor_image'] = $base_url . $row['doctor_image'];
        echo json_encode($row);
    } else {
        echo json_encode(["error" => "No data found for patient ID: $patientId"]);
    }

    // Close the prepared statement
    $stmt->close();
} else {
    echo json_encode(["error" => "No patientId specified"]);
}

// Close the connection
$conn->close();
?>
