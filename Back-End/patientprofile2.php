<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require "dbh.php";

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

if (empty($patientId) || empty($name) || empty($contactNo) || empty($age) || empty($gender) || empty($height) || empty($weight) || empty($patientCase) || empty($painDuration) || empty($admittedOn) || empty($rbs) || empty($password) || empty($confirmPassword) || empty($doctorId)) {
    die(json_encode(["success" => false, "message" => "Please fill in all required fields."]));
}

if ($password !== $confirmPassword) {
    die(json_encode(["success" => false, "message" => "Passwords do not match."]));
}

$checkSql = "SELECT COUNT(*) FROM patientlogin WHERE patientId = ? AND doctorId = ?";
$checkStmt = $conn->prepare($checkSql);

if ($checkStmt === false) {
    die(json_encode(["success" => false, "message" => "Failed to prepare check statement: " . $conn->error]));
}

$checkStmt->bind_param("ss", $patientId, $doctorId);
$checkStmt->execute();
$checkStmt->bind_result($count);
$checkStmt->fetch();
$checkStmt->close();

if ($count > 0) {
    die(json_encode(["success" => false, "message" => "This patient already exists for this doctor."]));
}


$imageDir = "uploads/";
$imagePath = $imageDir . basename($_FILES["image"]["name"]);

if (move_uploaded_file($_FILES["image"]["tmp_name"], $imagePath)) {
    $sql = "INSERT INTO patientlogin (patientId, name, contactNo, age, gender, height, weight, patientCase, painDuration, admittedOn, rbs, password, confirmPassword, image, doctorId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        die(json_encode(["success" => false, "message" => "Failed to prepare statement: " . $conn->error]));
    }

    $stmt->bind_param("sssisdssssissss", $patientId, $name, $contactNo, $age, $gender, $height, $weight, $patientCase, $painDuration, $admittedOn, $rbs, $password, $confirmPassword, $imagePath, $doctorId);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Form submitted successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error inserting data into database: " . $stmt->error]);
    }

    $stmt->close();
} else {
    die(json_encode(["success" => false, "message" => "Error uploading image."]));
}

$conn->close();
?>
