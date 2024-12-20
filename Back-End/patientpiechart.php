<?php
header("Content-Type: application/json");

// Include the database connection file
require 'dbh.php'; // Ensure this path is correct and the file exists

$patientId = $_GET['patientId'] ?? null;

if (!$patientId) {
    echo json_encode(["error" => "patientId parameter is required"]);
    exit;
}

// Prepare SQL query to fetch the most recent submission date for the patient
$sql = "SELECT `created_at` FROM `patientscores` WHERE `patientId` = ? ORDER BY `created_at` DESC LIMIT 1";
$stmt = $conn->prepare($sql); // Use $conn here instead of $mysqli
$stmt->bind_param("s", $patientId);
$stmt->execute();
$stmt->bind_result($created_at);
$stmt->fetch();
$stmt->close();

// Check if there is a submission date found
if ($created_at) {
    // Calculate the days since the last submission
    $lastSubmissionDate = new DateTime($created_at);
    $currentDate = new DateTime();
    $interval = $lastSubmissionDate->diff($currentDate);
    $daysSinceLastSubmission = $interval->days;

    // If the last submission was within the last 7 days, calculate waiting time
    if ($daysSinceLastSubmission < 7) {
        $waitingTime = 7 - $daysSinceLastSubmission;
        echo json_encode(["submitted" => true, "waitingTime" => $waitingTime . " day(s)"]);
    } else {
        // If more than 7 days have passed, allow submission
        echo json_encode(["submitted" => false]);
    }
} else {
    // If no previous submissions found, allow submission
    echo json_encode(["submitted" => false]);
}

// Close database connection
$conn->close();
?>
