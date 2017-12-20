<?php
	
	include 'sql.php';

	// Check that data exists
	// I use strlen() because a value of "0" should still be considered a value (distance or time = 0)
	if (!strlen($_POST["workoutid"]) || !strlen($_POST["latitude"]) || !strlen($_POST["longitude"]) || !strlen($_POST["time"]) || !strlen($_POST["distance"]) || !strlen($_POST["speed"]) || !strlen($_POST["date"])) {
		$conn->close();
		header("Location: http://tracker.tpsatt.com", true, 403);
		exit();
	}

	// Get point data from POST
	$workoutid = $_POST["workoutid"];
	$latitude = $_POST["latitude"];
	$longitude = $_POST["longitude"];
	$time = $_POST["time"];
	$distance = $_POST["distance"];
	$speed = $_POST["speed"];
	$date = $_POST["date"];

	// Insert workout into database
	$sql = $conn->prepare("INSERT INTO points (workoutid, latitude, longitude, time, distance, speed, date) VALUES (?, ?, ?, ?, ?, ?, ?)");
	$sql->bind_param("sssssss", $workoutid, $latitude, $longitude, $time, $distance, $speed, $date);
	$sql->execute();
	$sql->close();
	$conn->close();
?>