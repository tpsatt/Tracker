<?php
	include 'header.php';
?>
<?php
	// Check if user is already signed in
	if (isset($_COOKIE["id"])) {
		header("Location: http://tracker.tpsatt.com/");
		exit();
	}
?>
<?php
	// Check for errors sent via GET
	if (isset($_GET["e"])) {
		// Create alert box
		echo "<div id='error' style='display:block;' class='alert alert-danger'>";
		$error = $_GET["e"];
		// Email is taken
		if ($error == "e") {
			echo "Email address or password is incorrect.";
		}
		echo "</div>";
	}
?>
<div id="form-title">
	<h1>Sign In</h1>
</div>
<div id="form-container">
	<form action="signin.php" method="post" onsubmit="return validateForm()">
		<div class="form-group">
			<input autocomplete="off" autofocus class="form-control" name="email" placeholder="Email" type="email" required>
		</div>
		<div class="form-group">
			<input autocomplete="off" class="form-control" name="password" placeholder="Password" type="password" id="password" required>
		</div>
		<div class="text-center">
			<button class="btn btn-primary" type="submit">Sign In</button>
		</div>
	</form>
</div>
<?php
	include 'footer.php';
?>