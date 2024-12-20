<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include database connection
require "dbh.php";

// Function to determine difficulty category
function getDifficultyCategory($score) {
    if ($score >= 0 && $score <= 20) {
        return "Little to no difficulty: The individual experiences minimal to no issues with daily activities.";
    } elseif ($score > 20 && $score <= 40) {
        return "Mild difficulty: The individual has some difficulty but can still perform most activities with mild limitations.";
    } elseif ($score > 40 && $score <= 60) {
        return "Moderate difficulty: The individual faces moderate challenges and may need to adapt how they perform certain tasks.";
    } elseif ($score > 60 && $score <= 80) {
        return "Severe difficulty: The individual has significant difficulty performing many activities and may need substantial assistance.";
    } elseif ($score > 80 && $score <= 100) {
        return "Extreme difficulty: The individual is unable to perform most activities and experiences severe limitations.";
    } else {
        return "Invalid score.";
    }
}

// Get POST data
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['patientId']) && isset($data['dashScore']) && isset($data['numberOfAnsweredItems']) && isset($data['sumOfScores'])) {
    $patientId = $data['patientId'];
    $dashScore = $data['dashScore'];
    $numberOfAnsweredItems = $data['numberOfAnsweredItems'];
    $sumOfScores = $data['sumOfScores'];

    // Determine the difficulty category
    $difficultyCategory = getDifficultyCategory($dashScore);

    // Prepare the SQL statement
    $stmt = $conn->prepare("INSERT INTO patientscores (patientId, numberOfAnsweredItems, sumOfScores, dashScore, difficultyCategory, created_at) VALUES (?, ?, ?, ?, ?, NOW())");

    // Bind the parameters
    $stmt->bind_param('siiis', $patientId, $numberOfAnsweredItems, $sumOfScores, $dashScore, $difficultyCategory);

    // Execute the statement
    if ($stmt->execute()) {
        // Return a success message with the difficulty category
        echo json_encode(["message" => "New record created successfully", "difficultyCategory" => $difficultyCategory]);
    } else {
        // Return an error message if the execution fails
        http_response_code(500); // Internal Server Error
        echo json_encode(["error" => "Failed to create new record."]);
    }

    // Close the prepared statement
    $stmt->close();
} else {
    // Return an error message if POST data is missing
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Required parameters are missing."]);
}

// Close the database connection
$conn->close();
?>
