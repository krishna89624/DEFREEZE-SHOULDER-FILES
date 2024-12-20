<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include database connection
require 'dbh.php';

try {
    // Prepare SELECT statement
    $sql = "SELECT * FROM weaklyquestions";
    $stmt = $conn->prepare($sql);
    
    // Execute query
    $stmt->execute();
    
    // Get the result
    $result = $stmt->get_result();

    // Fetch all rows as associative array
    $rows = [];
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }

    // Output the result as JSON
    echo json_encode($rows);
} catch (Exception $e) {
    // Handle database errors
    echo json_encode(["error" => $e->getMessage()]);
}
?>
