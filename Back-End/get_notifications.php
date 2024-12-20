<?php
require "dbh.php";
// Check if doctorId is set in the GET parameters
if (isset($_GET['doctorId'])) {
    $doctorId = $_GET['doctorId'];

    // SQL query to count pending notifications for the given doctorId
    $countSql = "SELECT COUNT(*) AS notification_count
                 FROM `patientappointments`
                 WHERE `doctorId` = ? AND `status` = 'pending'";

    // Prepare statement for counting pending notifications
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param("s", $doctorId); // 's' denotes the type is string

    // Execute query
    if ($countStmt->execute()) {
        // Bind result variables
        $countStmt->bind_result($notificationCount);

        // Fetch result
        $countStmt->fetch();

        // Close count statement
        $countStmt->close();

        // SQL query to retrieve detailed information about pending notifications
        $detailSql = "SELECT appointmentId, patientId
                      FROM `patientappointments`
                      WHERE `doctorId` = ? AND `status` = 'pending'";

        // Prepare statement for retrieving detailed information
        $detailStmt = $conn->prepare($detailSql);
        $detailStmt->bind_param("s", $doctorId); // 's' denotes the type is string

        // Execute query
        if ($detailStmt->execute()) {
            // Get result
            $result = $detailStmt->get_result();

            // Fetch all pending notifications
            $pendingNotifications = $result->fetch_all(MYSQLI_ASSOC);

            // Prepare messages for each pending notification
            $messages = [];
            foreach ($pendingNotifications as $notification) {
                $messages[] = "You have a pending appointment request with patient ID:" . $notification['patientId'] . ", Appointment ID: " . $notification['appointmentId'];
            }

            // Prepare JSON response
            $response = array(
                'notification_count' => $notificationCount,
                'messages' => $messages
            );

            // Send JSON response
            header('Content-Type: application/json');
            echo json_encode($response);
        } else {
            // Error executing detail query
            $error = array('error' => 'Error executing detail query');
            header('Content-Type: application/json');
            echo json_encode($error);
        }

        // Close detail statement
        $detailStmt->close();
    } else {
        // Error executing count query
        $error = array('error' => 'Error executing count query');
        header('Content-Type: application/json');
        echo json_encode($error);
    }
} else {
    // Doctor ID not specified
    $error = array('error' => 'Doctor ID not specified');
    header('Content-Type: application/json');
    echo json_encode($error);
}

// Close connection
$conn->close();
?>
