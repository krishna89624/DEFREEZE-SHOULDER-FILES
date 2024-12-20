<?php
header('Content-Type: application/json');

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
    exit;
}

// Check if patientId is provided
if (!isset($_GET['patientId'])) {
    echo json_encode(['success' => false, 'message' => 'Patient ID is required']);
    exit;
}

$patientId = $_GET['patientId'];

// Include the database connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$baseURL = $dbh['base_url']; // Extract the base URL

$sql = "SELECT id, doctorId, patientId, CONCAT(?, video_path) AS video_path, introduction, custom_file_name, selected_date FROM selected_videos WHERE patientId = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare statement']);
    exit;
}

// Bind parameters
$stmt->bind_param("ss", $baseURL, $patientId);
$stmt->execute();
$result = $stmt->get_result();

// Fetch the result and return as JSON
if ($result->num_rows > 0) {
    $videos = [];
    while ($row = $result->fetch_assoc()) {
        $videos[] = $row;
    }
    echo json_encode(['success' => true, 'videos' => $videos]);
} else {
    echo json_encode(['success' => false, 'message' => 'No videos found for the given patient ID']);
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
