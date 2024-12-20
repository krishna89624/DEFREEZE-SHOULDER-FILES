<?php
// Establish database connection (replace these values with your actual database credentials)
require "dbh.php";

// Get the raw POST data
$json = file_get_contents('php://input');

// Decode the JSON into an associative array
$data = json_decode($json, true);

// Process the data as needed
if ($data) {
    try {
        // Prepare the SQL statement
        $stmt = $conn->prepare("INSERT INTO medical_history (patientId, questions, answer, input_value) 
                                VALUES (:patientId, :questions, :answer, :input_value)");

        // Bind parameters
        $stmt->bindParam(':patientId', $data['patientId']);
        $stmt->bindParam(':questions', $data['questions']);
        $stmt->bindParam(':answer', $data['answer']);
        
        // Determine the input value based on the answer
        $input_value = '';
        if ($data['answer'] === 'Yes') {
            $input_value = $data['input_value'];
        }
        $stmt->bindParam(':input_value', $input_value);

        // Execute the statement
        if ($stmt->execute()) {
            echo "Data inserted successfully";
        } else {
            echo "Error executing statement";
        }
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }

    // Close the connection
    $conn = null;
} else {
    echo "No data received";
}
?>
