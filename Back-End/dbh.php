<?php

// Database connection parameters
$servername = "localhost";
$username = "root";
$password = "";
$database = "orthocare";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Manually set the base URL with a fixed IP address
$base_url = 'http://192.168.232.82/defreezeshoulder/'; // Replace with your manual IP address and correct path

// Return an associative array with connection and base URL
return array('conn' => $conn, 'base_url' => $base_url);

?>
