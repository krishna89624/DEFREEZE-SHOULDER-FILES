<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

if (!isset($_GET['patientId'])) {
    echo json_encode(['success' => false, 'message' => 'patientId is not provided']);
    exit;
}

$patientId = $_GET['patientId'];
require "dbh.php";

$stmt = $conn->prepare("SELECT numberOfAnsweredItems, sumOfScores, dashScore, difficultyCategory, created_at FROM patientscores WHERE patientId = ?");
if (!$stmt) {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare statement']);
    exit;
}

$stmt->bind_param("s", $patientId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => true, 'message' => 'No records found for patientId: ' . $patientId, 'scores' => []]);
    exit;
}

$scores = [];
while ($row = $result->fetch_assoc()) {
    $scores[] = $row;
}

$stmt->close();
$conn->close();

echo json_encode(['success' => true, 'scores' => $scores]);
?>
