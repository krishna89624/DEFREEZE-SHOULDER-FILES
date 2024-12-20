<?php
require "dbh.php";

// Assuming you pass patientId as a GET parameter
$patientId = $_GET['patientId'];

// Query to fetch records based on patientId
$sql = "SELECT `id`,`questions`, `patientId`, `options`, `inp_data`, `created_at` 
        FROM `medical_history_answ` 
        WHERE `patientId` = ?";

$stmt = $conn->prepare($sql);

$stmt->bind_param("s", $patientId);

$stmt->execute();

// Get the result
$result = $stmt->get_result();

// Initialize an array to store the results
$response = [];

// Fetch rows and push them into the response array
while ($row = $result->fetch_assoc()) {
    $response[] = $row;
}

// Close prepared statement
$stmt->close();

// Close MySQL connection
$conn->close();

// Output the response as JSON
header('Content-Type: application/json');
echo json_encode($response);
?>
