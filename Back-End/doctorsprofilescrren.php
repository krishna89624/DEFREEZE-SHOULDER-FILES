<?php

require "dbh.php"; 


function fetchDoctorDetails($conn, $doctorId) {
    $doctorId = $conn->real_escape_string($doctorId);

    $sql = "SELECT doctorname, phoneno, gender, age, experience, specialization, password, confirmpassword, image FROM doctorlogin WHERE doctorId = '$doctorId'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        return $row;
    } else {
        return null;
    }
}

if (isset($_GET['doctorId'])) {
    $doctorId = $_GET['doctorId'];
    $doctorDetails = fetchDoctorDetails($conn, $doctorId);

    if ($doctorDetails) {
        header('Content-Type: application/json');
        echo json_encode($doctorDetails);
    } else {
        echo "Doctor not found";
    }
} else {
    echo "Doctor ID is not provided";
}

$conn->close();
?>
