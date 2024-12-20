<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include database connection
require "dbh.php";

// Get POST data
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['patientId']) || !isset($data['answers'])) {
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Patient ID or answers data missing."]);
    exit;
}

$patientId = $data['patientId'];
$answers = $data['answers'];

if (empty($patientId) || !is_array($answers)) {
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Invalid Patient ID or answers data format."]);
    exit;
}

try {
    // Prepare INSERT statement
    $sql = "INSERT INTO dash_score (patientId, questions, options, score, created_at) VALUES (?, ?, ?, ?, NOW())";
    $stmt = $conn->prepare($sql);

    foreach ($answers as $answer) {
        if (!isset($answer['question']) || !isset($answer['option']) || !isset($answer['score'])) {
            continue; // Skip invalid entries
        }

        $question = $answer['question'];
        $option = $answer['option'];
        $score = $answer['score'];

        // Bind parameters
        $stmt->bind_param('sssi', $patientId, $question, $option, $score);

        // Execute the query
        $stmt->execute();
    }

    http_response_code(200); // OK
    echo json_encode(["message" => "Answers submitted successfully."]);
} catch (mysqli_sql_exception $e) {
    http_response_code(500); // Internal Server Error
    echo json_encode(["error" => "Failed to insert answers: " . $e->getMessage()]);
}

$stmt->close();
$conn->close();
?>
