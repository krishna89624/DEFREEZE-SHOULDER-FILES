<?php
// Include database connection
require 'dbh.php';

// Add this line at the beginning of the PHP script
error_log("Request Data: " . print_r($_REQUEST, true));

// Check if it's a GET request
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    // Prepare the SQL statement
    $stmt = $conn->prepare("SELECT id, patientId, options, created_at FROM medical_history_answ");
    
    if ($stmt) {
        // Execute the statement
        $stmt->execute();
        
        // Bind result variables
        $stmt->bind_result($id, $patientId, $options, $created_at);
        
        // Fetch the results
        $results = array();
        while ($stmt->fetch()) {
            $results[] = array(
                'id' => $id,
                'patientId' => $patientId,
                'options' => $options,
                'created_at' => $created_at
            );
        }
        
        // Output the results as JSON
        echo json_encode($results);
        
        // Close the statement
        $stmt->close();
    } else {
        // Handle SQL preparation error
        http_response_code(500);
        echo json_encode(["error" => "Failed to prepare SQL statement."]);
    }
} else {
    // Return error message for unsupported request method
    http_response_code(405);
    echo json_encode(["error" => "Unsupported request method."]);
}

// Close the database connection
$conn->close();
?>
