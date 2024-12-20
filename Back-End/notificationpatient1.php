<?php
require "dbh.php";

$patientId = $_GET['patientId'];

$sql = "SELECT `id`, `appointmentId`, `doctorId`, `patientId`, `status`, `created_at`
        FROM `doctorappointments` 
        WHERE `patientId` = ? 
        AND `status` IN ('accepted', 'rejected')
        ORDER BY `created_at` DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $patientId);
$stmt->execute();
$result = $stmt->get_result();

$appointments = array();

while($row = $result->fetch_assoc()) {
    // Check if this appointment has already been shown
    // You can maintain a separate table or use session/cookie for this purpose
    $alreadyShown = false; // Assuming no tracking mechanism for now

    if (!$alreadyShown) {
        $message = "";
        if ($row['status'] == 'accepted') {
            $message = "Your appointment with appointment ID " . $row['appointmentId'] . " has been accepted.";
        } elseif ($row['status'] == 'rejected') {
            $message = "Your appointment with appointment ID " . $row['appointmentId'] . " has been rejected.";
        }

        $appointments[] = array(
            'id' => $row['id'],
            'appointmentId' => $row['appointmentId'],
            'doctorId' => $row['doctorId'],
            'patientId' => $row['patientId'],
            'status' => $row['status'],
            'created_at' => $row['created_at'],
            'message' => $message
        );

        // Mark this appointment as shown (store in session/cookie or another table)
        // Example using session (for orthocare_surgerynstration purposes)
        session_start();
        $_SESSION['shownAppointments'][] = $row['id'];
        session_write_close();
    }
}

echo json_encode($appointments);

$conn->close();
?>
