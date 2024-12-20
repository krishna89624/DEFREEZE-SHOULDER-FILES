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
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $patientId);
$stmt->execute();
$stmt->bind_result($created_at);
$stmt->fetch();
$stmt->close();

$currentDate = new DateTime();

if ($created_at) {
    // Calculate the days since the last submission
    $lastSubmissionDate = new DateTime($created_at);
    $interval = $lastSubmissionDate->diff($currentDate);
    $daysSinceLastSubmission = $interval->days;

    // If the last submission was within the last 7 days
    if ($daysSinceLastSubmission < 7) {
        $waitingTime = 7 - $daysSinceLastSubmission;
        if ($daysSinceLastSubmission == 0) {
            // Submission on the same day
            echo json_encode(["status" => "info", "message" => "You have already submitted the weekly question today."]);
        } else {
            // Within 1 to 6 days after last submission
            echo json_encode(["status" => "info", "message" => "You have completed $daysSinceLastSubmission day(s). You can submit the weekly question in $waitingTime day(s)."]);
        }
    } else {
        // More than 7 days have passed since last submission
        // Check if there's a new submission to ensure they haven't submitted in between
        $sql = "SELECT COUNT(*) FROM `patientscores` WHERE `patientId` = ? AND `created_at` > ?";
        $stmt = $conn->prepare($sql);
        $lastSubmissionDate->modify('+7 days'); // Set the threshold date
        $thresholdDate = $lastSubmissionDate->format('Y-m-d H:i:s');
        $stmt->bind_param("ss", $patientId, $thresholdDate);
        $stmt->execute();
        $stmt->bind_result($newSubmissionCount);
        $stmt->fetch();
        $stmt->close();

        if ($newSubmissionCount > 0) {
            // New submission found after the threshold date
            echo json_encode(["status" => "info", "message" => "You have submitted the weekly question again after missing the deadline."]);
        } else {
            // No new submission found
            echo json_encode(["status" => "warning", "message" => "You have missed the weekly question submission for more than 7 days. Please submit it now."]);
        }
    }
} else {
    // If no previous submissions found, prompt to submit
    echo json_encode(["status" => "success", "message" => "You can submit the weekly question today."]);
}

// Close database connection
$conn->close();
?>
