<?php
// Include the database connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$baseUrl = $dbh['base_url']; // Extract the base URL

$sql = "SELECT * FROM doctorlogin";
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    $doctors = array();
    while ($row = $result->fetch_assoc()) {
        $row['image'] = $baseUrl . $row['image'];
        $doctors[] = $row;
    }

    $response['doctors'] = $doctors;
    $response['baseUrl'] = $baseUrl;
} else {
    $response = array("status" => "error", "message" => "No doctors found", "baseUrl" => $baseUrl);
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($response);
?>
