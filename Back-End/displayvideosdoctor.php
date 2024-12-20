<?php

function transcodeVideo($filePath) {
    $supportedFormat = 'mp4';
    $outputPath = pathinfo($filePath, PATHINFO_DIRNAME) . '/' . pathinfo($filePath, PATHINFO_FILENAME) . '.' . $supportedFormat;

    if (pathinfo($filePath, PATHINFO_EXTENSION) !== $supportedFormat) {
        $command = "ffmpeg -i $filePath -c:v libx264 -c:a aac -strict experimental $outputPath";
        shell_exec($command);
        return $outputPath;
    }
    return $filePath;
}

// Include the database connection file and extract the connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

$doctorId = isset($_GET['doctorId']) ? $_GET['doctorId'] : '';

if (empty($doctorId)) {
    $response = array("status" => "error", "message" => "Invalid doctor ID");
    header('Content-Type: application/json');
    echo json_encode($response);
    exit();
}

$sql = "SELECT * FROM adddoctorvideos WHERE doctorId = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    $response = array("status" => "error", "message" => "Failed to prepare SQL statement");
    header('Content-Type: application/json');
    echo json_encode($response);
    exit();
}

$stmt->bind_param("s", $doctorId);

if (!$stmt->execute()) {
    $response = array("status" => "error", "message" => "Failed to execute SQL statement");
    header('Content-Type: application/json');
    echo json_encode($response);
    exit();
}

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $videos = array();
    while ($row = $result->fetch_assoc()) {
        // Append the base URL to the video path
        $videoPath = $base_url . $row['video_path']; 

        // Transcode the video if necessary
        $transcodedVideoPath = transcodeVideo($videoPath);

        // Update the video path with the transcoded version
        $row['video_path'] = $transcodedVideoPath;

        $videos[] = $row;
    }

    header('Content-Type: application/json');
    echo json_encode($videos);
} else {
    $response = array("status" => "error", "message" => "No videos found for the specified doctor");
    header('Content-Type: application/json');
    echo json_encode($response);
}

$stmt->close();
$conn->close();
?>
