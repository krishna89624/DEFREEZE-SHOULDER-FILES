<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
    exit;
}

// Retrieve POST data
$patientId = $_POST['patientId'];
$flexion = $_POST['flexion'];
$extension = $_POST['extension'];
$adduction = $_POST['adduction'];
$abduction = $_POST['abduction'];
$painScale = $_POST['pain_scale'];
$doingExercises = $_POST['doing_exercises'];
$date = date('Y-m-d'); // Current date
$time = date('H:i:s'); // Current time

// Validate required fields
if (!isset($patientId, $flexion, $extension, $adduction, $abduction, $painScale, $doingExercises)) {
    echo json_encode(['success' => false, 'message' => 'All fields are required']);
    exit;
}

require "dbh.php";

// Check if there's already an entry for the patient on the current date
$checkStmt = $conn->prepare("SELECT * FROM daily_task WHERE patientId = ? AND date = ?");
if (!$checkStmt) {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare check statement']);
    exit;
}

$checkStmt->bind_param("ss", $patientId, $date);
$checkStmt->execute();
$result = $checkStmt->get_result();

if ($result->num_rows > 0) {
    // Update the existing entry
    $stmt = $conn->prepare("UPDATE daily_task SET flexion = ?, extension = ?, adduction = ?, abduction = ?, pain_scale = ?, doing_exercises = ?, time = ? WHERE patientId = ? AND date = ?");
    if (!$stmt) {
        echo json_encode(['success' => false, 'message' => 'Failed to prepare update statement']);
        exit;
    }

    $stmt->bind_param("sssssssss", $flexion, $extension, $adduction, $abduction, $painScale, $doingExercises, $time, $patientId, $date);
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Task updated successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to update task']);
    }
} else {
    // Insert a new entry
    $stmt = $conn->prepare("INSERT INTO daily_task (patientId, flexion, extension, adduction, abduction, pain_scale, doing_exercises, date, time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
    if (!$stmt) {
        echo json_encode(['success' => false, 'message' => 'Failed to prepare insert statement']);
        exit;
    }

    $stmt->bind_param("sssssssss", $patientId, $flexion, $extension, $adduction, $abduction, $painScale, $doingExercises, $date, $time);
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Task submitted successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to submit task']);
    }
}

// Close connections
$checkStmt->close();
$stmt->close();
$conn->close();
?>
