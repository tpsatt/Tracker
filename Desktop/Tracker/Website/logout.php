<?php
	// Remove cookie
	if (isset($_COOKIE["id"])) {
		setcookie("id", "", time() - 3600);
	}

	// Redirect to sign in page
	header("Location: http://tracker.tpsatt.com/in.php");
?>