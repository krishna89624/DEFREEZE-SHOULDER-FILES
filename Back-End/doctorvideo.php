<?php
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_FILES["video_file"])) {
    $target_dir = "uploads/";

    $introduction = $_POST['introduction'];
    $custom_file_name = $_POST['custom_file_name'];
    $doctorId = $_POST['doctorId']; 

    $video_name = $custom_file_name . "_" . basename($_FILES["video_file"]["name"]);
    $target_file = $target_dir . $video_name;

    if (move_uploaded_file($_FILES["video_file"]["tmp_name"], $target_file)) {
        require "dbh.php";

        $sql = "INSERT INTO adddoctorvideos (video_name, video_path, introduction, custom_file_name, doctorId) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);

        $video_path = $target_file;
        $stmt->bind_param("sssss", $video_name, $video_path, $introduction, $custom_file_name, $doctorId);

        if ($stmt->execute()) {
            echo "Video uploaded successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }

        $stmt->close();
        $conn->close();
    } else {
        echo "Sorry, there was an error uploading your file.";
    }
}
?>
