<?php
	// Got syntax for SQL connections here: https://www.w3schools.com/php/php_mysql_select.asp
	$servername = "REDACTED";
	$username = "REDACTED";
	$password = "REDACTED";
	$dbname = "REDACTED";

	// Create and check connection
	$conn = new mysqli($servername, $username, $password, $dbname);

	if ($conn->connect_error) {
		die("Connection Failed: " . $conn->connect_error);
	}
?>