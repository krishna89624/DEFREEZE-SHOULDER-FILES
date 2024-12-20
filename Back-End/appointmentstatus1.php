<?php
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the JSON data from the request body
    $json = file_get_contents('php://input');
    
    // Decode the JSON data into an associative array
    $data = json_decode($json, true);
    
    // Log incoming data for debugging
    error_log(print_r($data, true));

    // Check if appointmentId and status are present in the decoded data
    if (isset($data['appointmentId']) && isset($data['status'])) {
        $appointmentId = $data['appointmentId'];
        $status = $data['status'];
        
        // Include the database connection file
        require 'dbh.php';

        try {
            // Prepare SQL statement to update appointment status
            $sql = "UPDATE doctorappointments SET status = ? WHERE appointmentId = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('ss', $status, $appointmentId);
            
            // Execute the statement
            $stmt->execute();
            
            // Check if any rows were affected (appointment updated successfully)
            if ($stmt->affected_rows > 0) {
                $response = [
                    "success" => true,
                    "message" => "Appointment status updated successfully"
                ];
            } else {
                $response = [
                    "success" => false,
                    "message" => "No appointment found with ID: $appointmentId"
                ];
            }

            // Close the prepared statement
            $stmt->close();
        } catch (Exception $e) {
            $response = [
                "success" => false,
                "message" => "Database error: " . $e->getMessage()
            ];
        } finally {
            // Close the database connection
            $conn->close();
        }
        
        // Send JSON response
        echo json_encode($response);
    } else {
        // If appointmentId or status is missing in the JSON data
        $response = [
            "success" => false,
            "message" => "AppointmentId or status not provided in the request"
        ];
        
        // Send JSON response
        echo json_encode($response);
    }
} else {
    // If the request method is not POST
    $response = [
        "success" => false,
        "message" => "Only POST requests are allowed"
    ];
    
    // Send JSON response
    echo json_encode($response);
}
?>
