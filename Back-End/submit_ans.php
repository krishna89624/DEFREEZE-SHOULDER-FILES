<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include database connection
require "dbh.php";

// Get POST data
$data = json_decode(file_get_contents("php://input"), true);

if (empty($data['patientId']) || empty($data['questions']) || empty($data['answers'])) {
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Patient ID, questions, or answers data missing."]);
    exit;
}

$patientId = $conn->real_escape_string($data['patientId']);
$questions = $data['questions'];
$answers = $data['answers'];

try {
    // Prepare INSERT statement
    $stmt = $conn->prepare("INSERT INTO medical_history_answ(patientId, questions, options, inp_data, created_at) VALUES (?, ?, ?, ?, NOW())");

    foreach ($answers as $index => $answer) {
        $question = $conn->real_escape_string($questions[$index]); // Get corresponding question
        $option = $conn->real_escape_string($answer['option']);
        $inp_data = $conn->real_escape_string($answer['inp_data']);

        // Bind parameters
        $stmt->bind_param("ssss", $patientId, $question, $option, $inp_data);

        // Execute the query
        $stmt->execute();
    }

    http_response_code(200); // OK
    echo json_encode(["message" => "Answers submitted successfully."]);
} catch (Exception $e) {
    http_response_code(500); // Internal Server Error
    echo json_encode(["error" => "Failed to insert answers: " . $e->getMessage()]);
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
