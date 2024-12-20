<?php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);

if (!isset($input['doctorId']) || !isset($input['patientId']) || !isset($input['selectedVideos']) || !is_array($input['selectedVideos'])) {
    echo json_encode(['success' => false, 'message' => 'Invalid input']);
    exit;
}

$doctorId = $input['doctorId'];
$patientId = $input['patientId'];
$selectedVideos = $input['selectedVideos'];

require "dbh.php";

$sql = "INSERT INTO selected_videos (doctorId, patientId, video_path, introduction, custom_file_name) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare statement']);
    exit;
}

$success = true;
$target_dir = "uploads/";

foreach ($selectedVideos as $video) {
    // Prepend the target directory to the video path
    $videoPath = $target_dir . basename($video['video_path']);
    $stmt->bind_param("sssss", $doctorId, $patientId, $videoPath, $video['introduction'], $video['custom_file_name']);
    if (!$stmt->execute()) {
        $success = false;
        break;
    }
}

$stmt->close();
$conn->close();

if ($success) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to save videos']);
}
?>
