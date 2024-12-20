<?php
header('Content-Type: application/json');

// Include the database connection and base URL
$dbh = include 'dbh.php'; // Use include to get the associative array
$conn = $dbh['conn'];     // Extract the database connection
$base_url = $dbh['base_url']; // Extract the base URL

// Function to generate a sequential appointment ID
function generateAppointmentId($conn) {
    $sql = "SELECT appointmentId FROM doctorappointments ORDER BY id DESC LIMIT 1";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $lastId = $result->fetch_assoc()['appointmentId'];
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
        isset($data['patientId']) && isset($data['name']) &&
        isset($data['patientCase']) && isset($data['date']) &&
        isset($data['start_time']) && isset($data['end_time']) && isset($data['status'])
    ) {
        try {
            // Handle file uploads for doctorImage
            $doctorImage = '';
            if (isset($data['doctorImage']) && !empty($data['doctorImage'])) {
                $doctorImagePath = 'uploads/' . basename($data['doctorImage']);
                if (!file_exists($doctorImagePath)) {
                    file_put_contents($doctorImagePath, base64_decode($data['doctorImage']));
                }
                $doctorImage = $doctorImagePath;
            }

            // Handle file uploads for patientImage
            $patientImage = '';
            if (isset($data['patientImage']) && !empty($data['patientImage'])) {
                $patientImagePath = 'uploads/' . basename($data['patientImage']);
                if (!file_exists($patientImagePath)) {
                    file_put_contents($patientImagePath, base64_decode($data['patientImage']));
                }
                $patientImage = $patientImagePath;
            }

            $appointmentId = generateAppointmentId($conn);

            $sql = "
                INSERT INTO doctorappointments (
                    appointmentId, doctorId, doctorname, specialization, experience, doctorImage, 
                    patientId, name, patientCase, patientImage, date, start_time, end_time, status, created_at
                ) VALUES (
                    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW()
                )
            ";

            $stmt = $conn->prepare($sql);
            $stmt->bind_param(
                'ssssssssssssss',
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
                $data['start_time'],
                $data['end_time'],
                $data['status']
            );

            if ($stmt->execute()) {
                echo json_encode([
                    "message" => "Appointment successfully created",
                    "appointmentId" => $appointmentId,
                    "doctorImage" => $doctorImage ? $base_url . $doctorImage : null,
                    "patientImage" => $patientImage ? $base_url . $patientImage : null
                ]);
            } else {
                echo json_encode(["error" => "Failed to create appointment"]);
            }
        } catch (Exception $e) {
            echo json_encode(["error" => $e->getMessage()]);
        }
    } else {
        echo json_encode(["error" => "Missing required fields"]);
    }
} else {
    echo json_encode(["error" => "Invalid request method"]);
}

// Close the connection
$conn->close();
?>
