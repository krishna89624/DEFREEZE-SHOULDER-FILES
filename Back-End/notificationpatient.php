<?php
header('Content-Type: application/json');
require "dbh.php";

// Check if patientId is provided in the query string
$patientId = isset($_GET['patientId']) ? $_GET['patientId'] : '';

if ($patientId) {
    $sql = "SELECT id, appointmentId, doctorId, doctorname, specialization, experience, doctorImage, patientId, name, patientCase, patientImage, date, status, created_at 
            FROM doctorappointments 
            WHERE patientId = ?";
} else {
    $sql = "SELECT id, appointmentId, doctorId, doctorname, specialization, experience, doctorImage, patientId, name, patientCase, patientImage, date, status, created_at 
            FROM doctorappointments";
}

// Prepare the statement
$stmt = $conn->prepare($sql);

// Check if prepare() was successful
if ($stmt === false) {
    // Output error and stop execution
    echo json_encode(["error" => "SQL Error: " . $conn->error]);
    exit;
}

// Bind parameter if patientId is provided
if ($patientId) {
    $stmt->bind_param("s", $patientId);
}

// Execute the query
$stmt->execute();
$result = $stmt->get_result();

$appointments = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $row['message'] = ($row["status"] == "pending") 
            ? "You got a request for appointment ID " . $row["appointmentId"] . " from doctor ID: " . $row["doctorId"]
            : "Your appointment status is: " . $row["status"];
        $appointments[] = $row;
    }
} else {
    $appointments[] = ["message" => "No appointments found."];
}

// Close connection
$stmt->close();
$conn->close();

// Output result as JSON
echo json_encode($appointments);
?>
