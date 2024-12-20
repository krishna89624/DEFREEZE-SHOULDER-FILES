<?php
require "dbh.php";

// Check if all required POST variables are set
$required_fields = ['patientId', 'name', 'contactNo', 'age', 'gender', 'height', 'weight', 'patientCase', 'painDuration', 'admittedOn', 'rbs', 'password', 'confirmPassword', 'doctorId'];

foreach ($required_fields as $field) {
    if (empty($_POST[$field])) {
        http_response_code(400); // Bad Request
        echo json_encode(["error" => "Missing required field: $field"]);
        exit;
    }
}

$patientId = $_POST['patientId'];
$name = $_POST['name'];
$contactNo = $_POST['contactNo'];
$age = $_POST['age'];
$gender = $_POST['gender'];
$height = $_POST['height'];
$weight = $_POST['weight'];
$patientCase = $_POST['patientCase'];
$painDuration = $_POST['painDuration'];
$admittedOn = $_POST['admittedOn'];
$rbs = $_POST['rbs'];
$password = $_POST['password'];
$confirmPassword = $_POST['confirmPassword'];
$doctorId = $_POST['doctorId'];

// Validate patient ID format (example validation)
if (!preg_match('/^[a-zA-Z0-9]+$/', $patientId)) {
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Invalid patientId format."]);
    exit;
}

if ($password !== $confirmPassword) {
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Passwords do not match."]);
    exit;
}

// Prepare SQL query
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = "uploads/";
    $tempFilename = $_FILES['image']['tmp_name'];
    $newFilename = uniqid() . '_' . basename($_FILES['image']['name']);
    
    if (move_uploaded_file($tempFilename, $uploadDir . $newFilename)) {
        $getImageSql = "SELECT `image` FROM `patientlogin` WHERE `patientId` = '$patientId'";
        $result = $conn->query($getImageSql);
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $existingImage = $row["image"];
            if (file_exists($existingImage)) {
                unlink($existingImage);
            }
        }
        $image = $uploadDir . $newFilename;
        $updatePatientSql = "UPDATE `patientlogin` SET 
                                `name` = '$name', 
                                `contactNo` = '$contactNo', 
                                `age` = '$age', 
                                `gender` = '$gender', 
                                `height` = '$height', 
                                `weight` = '$weight', 
                                `patientCase` = '$patientCase', 
                                `painDuration` = '$painDuration', 
                                `admittedOn` = '$admittedOn', 
                                `rbs` = '$rbs', 
                                `password` = '$password', 
                                `confirmPassword` = '$confirmPassword', 
                                `image` = '$image', 
                                `doctorId` = '$doctorId' 
                            WHERE `patientId` = '$patientId'";
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(["error" => "Failed to move uploaded file."]);
        exit;
    }
} else {
    $updatePatientSql = "UPDATE `patientlogin` SET 
                            `name` = '$name', 
                            `contactNo` = '$contactNo', 
                            `age` = '$age', 
                            `gender` = '$gender', 
                            `height` = '$height', 
                            `weight` = '$weight', 
                            `patientCase` = '$patientCase', 
                            `painDuration` = '$painDuration', 
                            `admittedOn` = '$admittedOn', 
                            `rbs` = '$rbs', 
                            `password` = '$password', 
                            `confirmPassword` = '$confirmPassword', 
                            `doctorId` = '$doctorId' 
                        WHERE `patientId` = '$patientId'";
}

if ($conn->query($updatePatientSql) === TRUE) {
    if (isset($image)) {
        $updateAppointmentsSql = "UPDATE `patientappointments` SET `patientImage` = '$image' WHERE `patientId` = '$patientId'";
        $updateDoctorAppointmentsSql = "UPDATE `doctorappointments` SET `patientImage` = '$image' WHERE `patientId` = '$patientId'";
        $appointmentsUpdated = $conn->query($updateAppointmentsSql) === TRUE;
        $doctorAppointmentsUpdated = $conn->query($updateDoctorAppointmentsSql) === TRUE;
        
        if ($appointmentsUpdated && $doctorAppointmentsUpdated) {
            echo json_encode(["message" => "Patient details and appointments updated successfully"]);
        } else {
            http_response_code(500); // Internal Server Error
            echo json_encode(["error" => "Error updating patient or doctor appointments: " . $conn->error]);
        }
    } else {
        echo json_encode(["message" => "Patient details updated successfully"]);
    }
} else {
    http_response_code(500); // Internal Server Error
    echo json_encode(["error" => "Error updating patient details: " . $conn->error]);
}

$conn->close();
?>
