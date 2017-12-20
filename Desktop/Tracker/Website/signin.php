<?php

	// Check that the user can view this page
	if (isset($_COOKIE["id"]) && $_GET["source"] != "mobile") {
		header("Location: http://tracker.tpsatt.com/", true, 200);
		exit();
	}

	include 'sql.php';

	// Get form info
	$email = $_POST["email"];
	$pword = $_POST["password"];

	// Query database for email
	$sql = $conn->prepare("SELECT id, password FROM users WHERE email=?");
	$sql->bind_param("s", $email);
	$sql->execute();
	$sql->bind_result($id, $correctPword);
	$sql->fetch();
	$sql->close();

	$conn->close();

	// Check if user exists
	if (!$id) {
		// If mobile, echo the error for the device to recognize
		if ($_GET["source"] == "mobile") {
			echo "error";
			exit();
		} else {
			header("Location: http://tracker.tpsatt.com/in.php?e=e");
			exit();
		}
	}

	// Check if password is correct
	if (password_verify($pword, $correctPword)) {
		setcookie("id", $id, time() + (86400 * 30), "/"); // 86400 = 1 day
		// Check if the source is mobile, and display the user's id for the app if so
		if ($_GET["source"] == "mobile") {
			echo $id;
		} else {
			header("Location: http://tracker.tpsatt.com/", false, 200);
		}
	} else {
		// If mobile, echo the error for the device to recognize
		if ($_GET["source"] == "mobile") {
			echo "error";
			exit();
		} else {
			header("Location: http://tracker.tpsatt.com/in.php?e=e");
			exit();
		}
	}
?>