<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
    exit;
}

if (!isset($_POST['patientId']) || !isset($_POST['date'])) {
    echo json_encode(['success' => false, 'message' => 'patientId or date is not provided']);
    exit;
}

$patientId = $_POST['patientId'];
$date = $_POST['date'];

require "dbh.php";

$stmt = $conn->prepare("SELECT id, patientId, flexion, extension, adduction, abduction, pain_scale, doing_exercises, date, time FROM daily_task WHERE patientId = ? AND date = ?");
if (!$stmt) {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare statement']);
    exit;
}

$stmt->bind_param("ss", $patientId, $date);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => true, 'message' => 'No records found for patientId: ' . $patientId . ' on date: ' . $date, 'report' => []]);
    exit;
}

$report = [];
while ($row = $result->fetch_assoc()) {
    $report[] = $row;
}

$stmt->close();
$conn->close();

echo json_encode(['success' => true, 'report' => $report]);
?>
