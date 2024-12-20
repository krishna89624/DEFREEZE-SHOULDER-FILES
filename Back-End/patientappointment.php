<?php
require "dbh.php";

// Function to generate a sequential appointment ID
function generateAppointmentId($conn) {
    $stmt = $conn->prepare("SELECT appointmentId FROM patientappointments ORDER BY id DESC LIMIT 1");
    $stmt->execute();
    $stmt->bind_result($lastId);
    $stmt->fetch();
    $stmt->close();

    if ($lastId) {
        $number = (int)substr($lastId, 7) + 1;
        $newId = 'appoin_' . str_pad($number, 4, '0', STR_PAD_LEFT);
    } else {
        $newId = 'appoin_0001';
    }

    return $newId;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    if (
        isset($data['doctorId']) && isset($data['doctorname']) &&
        isset($data['specialization']) && isset($data['experience']) &&
        isset($data['patientId']) && isset($data['name']) && isset($data['patientCase']) &&
        isset($data['patientImage']) && isset($data['date']) && isset($data['time']) &&
        isset($data['status']) && isset($data['start_time']) && isset($data['end_time'])
    ) {
        // Handle file uploads
        $uploadDir = 'uploads/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        $doctorImage = '';
        if (isset($data['doctorImage']) && !empty($data['doctorImage'])) {
            $doctorImagePath = $uploadDir . basename($data['doctorImage']);
            if (!file_exists($doctorImagePath)) {
                if (file_put_contents($doctorImagePath, base64_decode($data['doctorImage'])) === false) {
                    echo json_encode(["error" => "Failed to save doctor image"]);
                    exit;
                }
            }
            $doctorImage = $doctorImagePath;
        }

        $patientImage = '';
        if (isset($data['patientImage']) && !empty($data['patientImage'])) {
            $patientImagePath = $uploadDir . basename($data['patientImage']);
            if (!file_exists($patientImagePath)) {
                if (file_put_contents($patientImagePath, base64_decode($data['patientImage'])) === false) {
                    echo json_encode(["error" => "Failed to save patient image"]);
                    exit;
                }
            }
            $patientImage = $patientImagePath;
        }

        $appointmentId = generateAppointmentId($conn);

        // Prepare SQL statement
        $sql = "
            INSERT INTO patientappointments (
                appointmentId, doctorId, doctorname, specialization, experience, doctorImage, 
                patientId, name, patientCase, patientImage, date, time, status, start_time, end_time, created_at
            ) VALUES (
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW()
            )
        ";

        $stmt = $conn->prepare($sql);
        $stmt->bind_param(
            'sssssssssssssss',
            $appointmentId,
            $data['doctorId'],
            $data['doctorname'],
            $data['specialization'],
            $data['experience'],
            $doctorImage,
            $data['patientId'],
            $data['name'],
            $data['patientCase'],
            $patientImage,
            $data['date'],
            $data['time'],
            $data['status'],
            $data['start_time'],
            $data['end_time']
        );

        // Execute the SQL statement
        if ($stmt->execute()) {
            echo json_encode(["message" => "Appointment successfully created", "appointmentId" => $appointmentId]);
        } else {
            echo json_encode(["error" => "Failed to create appointment"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "Missing required fields"]);
    }
} else {
    echo json_encode(["error" => "Invalid request method"]);
}

$conn->close();
?>
