<?php
require "dbh.php";

function fetchPatientDetails($conn, $patientId) {
    $patientId = $conn->real_escape_string($patientId);

    $sql = "SELECT name, contactNo, gender, age, height, weight, patientCase,	painDuration, admittedOn, rbs, password, confirmPassword, image,doctorId FROM patientlogin WHERE patientId = '$patientId'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        return $row;
    } else {
        return null;
    }
}

if (isset($_GET['patientId'])) {
    $patientId = $_GET['patientId'];
    $patientDetails = fetchPatientDetails($conn, $patientId);

    if ($patientDetails) {
        header('Content-Type: application/json');
        echo json_encode($patientDetails);
    } else {
        echo "Patient not found";
    }
} else {
    echo "Patient ID is not provided";
}

$conn->close();
?>
