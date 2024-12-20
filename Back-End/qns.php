<?php
// Include database connection
require 'dbh.php';

// Add this line at the beginning of the PHP script
error_log("Request Data: " . print_r($_REQUEST, true));

// Check if it's a GET request
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    // Handle GET request to fetch data
    $sql = "SELECT id, questions FROM medical_history";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Fetch data and store in an array
        $questions = array();
        while ($row = $result->fetch_assoc()) {
            $questions[] = $row;
        }
        // Return data as JSON
        echo json_encode($questions);
    } else {
        // No data found
        echo json_encode(array()); // Return an empty array
    }

    exit;
} else {
    // Return error message for unsupported request method
    http_response_code(405);
    echo json_encode(["error" => "Unsupported request method."]);
    exit;
}
?>
