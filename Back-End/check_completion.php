<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include database connection
require 'dbh.php';

// Check if patientId is provided as a GET parameter
if (!isset($_GET['patientId'])) {
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Missing patientId parameter."]);
    exit;
}

$patientId = $conn->real_escape_string($_GET['patientId']);

// Query to check if all questions have been answered by the patient
$sql = "SELECT COUNT(*) AS total_questions, COUNT(DISTINCT id) AS answered_questions 
        FROM medical_history_answ 
        WHERE patientId = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $patientId);
$stmt->execute();
$stmt->bind_result($totalQuestions, $answeredQuestions);
$stmt->fetch();
$stmt->close();

// Determine completion status
$completed = ($totalQuestions > 0 && $totalQuestions == $answeredQuestions);

// Prepare response
$response = ['completed' => $completed];

echo json_encode($response);

// Close MySQL connection
$conn->close();
?>
