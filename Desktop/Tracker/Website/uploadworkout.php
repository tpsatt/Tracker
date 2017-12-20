<?php
	
	include 'sql.php';

	// Check that data exists
	// I use strlen() because a value of "0" should still be considered a value (distance or time = 0)
	if (!strlen($_POST["userid"]) || !strlen($_POST["time"]) || !strlen($_POST["distance"]) || !strlen($_POST["speed"]) || !strlen($_POST["date"])) {
		$conn->close();
		header("Location: http://tracker.tpsatt.com", true, 403);
		exit();
	}

	// Get workout data from POST
	$userid = $_POST["userid"];
	$time = $_POST["time"];
	$distance = $_POST["distance"];
	$speed = $_POST["speed"];
	$date = $_POST["date"];

	// Insert workout into database
	$sql = $conn->prepare("INSERT INTO workouts (userid, time, distance, speed, date) VALUES (?, ?, ?, ?, ?)");
	$sql->bind_param("sssss", $userid, $time, $distance, $speed, $date);
	$sql->execute();
	$sql->close();
	// Echo id of inserted workout
	echo $conn->insert_id;
	$conn->close();
?>