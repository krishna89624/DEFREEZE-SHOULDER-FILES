<?php
require "dbh.php";
$sql = "SELECT * FROM doctorlogin";
$result = $conn->query($sql);

$doctors = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $doctors[] = $row;
    }
}

$conn->close();

// Set the content type to JSON
header('Content-Type: application/json');

// Output the JSON data
echo json_encode($doctors);
?>
