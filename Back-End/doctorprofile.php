<?php
require "dbh.php";

// Get the POST data from the request
$doctorId = $_POST['doctorId'];
$doctorname = $_POST['doctorname'];
$phoneno = $_POST['phoneno'];
$gender = $_POST['gender'];
$age = $_POST['age'];
$experience = $_POST['experience'];
$specialization = $_POST['specialization'];
$password = $_POST['password'];
$confirmpassword = $_POST['confirmpassword'];

// Validate form inputs
if (empty($doctorId) || empty($doctorname) || empty($phoneno) || empty($gender) || empty($age) || empty($experience) || empty($specialization) || empty($password) || empty($confirmpassword)) {
    die(json_encode(["success" => false, "message" => "Please fill in all required fields."]));
}

// Check if passwords match
if ($password !== $confirmpassword) {
    die(json_encode(["success" => false, "message" => "Passwords do not match."]));
}

// Check if doctorId already exists
$sql = "SELECT doctorId FROM doctorlogin WHERE doctorId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $doctorId);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    // doctorId already exists
    die(json_encode(["success" => false, "message" => "Doctor ID already exists."]));
}

// Close the select statement
$stmt->close();

// Upload image
$imageDir = "uploads/";
$imagePath = $imageDir . basename($_FILES["image"]["name"]);

if (move_uploaded_file($_FILES["image"]["tmp_name"], $imagePath)) {
    // Image uploaded successfully, proceed with database insertion

    // Prepare SQL statement
    $sql = "INSERT INTO doctorlogin (doctorId, doctorname, phoneno, gender, age, experience, specialization, password, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    // Bind parameters
    $stmt->bind_param("ssssissss", $doctorId, $doctorname, $phoneno, $gender, $age, $experience, $specialization, $password, $imagePath);

    // Execute statement
    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Form submitted successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error inserting data into database: " . $stmt->error]);
    }

    // Close statement
    $stmt->close();
} else {
    // Image upload failed
    die(json_encode(["success" => false, "message" => "Error uploading image."]));
}

// Close connection
$conn->close();
?>
