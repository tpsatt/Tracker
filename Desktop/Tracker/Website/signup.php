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
	$hashed_pword = password_hash($pword, PASSWORD_DEFAULT);

	// Learned to prevent SQL injection here: https://www.wikihow.com/Prevent-SQL-Injection-in-PHP
	// Check for users
	$sql0 = $conn->prepare("SELECT id FROM users WHERE email=?");
	$sql0->bind_param("s", $email);
	$sql0->execute();
	$sql0->bind_result($id);
	$sql0->fetch();
	$sql0->close();

	// Check if the email address is available
	if ($id) {
		$conn->close();
		// If mobile: echo error for device to recognize
		if ($_GET["source"] == "mobile") {
			echo "taken";
			exit();
		} else {
			// Redirect user back to sign up page with an error
			header("Location: http://tracker.tpsatt.com/up.php?e=e");
		}
		exit();
	} else {
		// Insert user into database
		$sql = $conn->prepare("INSERT INTO users (email, password) VALUES (?, ?)");
		$sql->bind_param("ss", $email, $hashed_pword);
		$sql->execute();
		$sql->close();

		// Get id of new user
		$sql1 = $conn->prepare("SELECT id FROM users WHERE email=?");
		$sql1->bind_param("s", $email);
		$sql1->execute();
		$sql1->bind_result($id);
		$sql1->fetch();
		$sql1->close();

		$conn->close();

		if ($_GET["source"] == "mobile") {
			echo $id;
		} else {
			// Learned to set cookies here: https://www.w3schools.com/php/php_cookies.asp
			setcookie("id", $id, time() + (86400 * 30), "/"); // 86400 = 1 day

			// Redirect to homepage
			header("Location: http://tracker.tpsatt.com");
		}
	}

	
?>