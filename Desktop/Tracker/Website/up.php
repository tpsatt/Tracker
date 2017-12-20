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
	<script>
		function validateForm() {
			// The only case that is not checked by HTML is the passwords matching
			if (document.getElementById("password").value != document.getElementById("confirmPassword").value) {
				document.getElementById("error").style.display = "block";
				return false;
			} else {
				return true;
			}
		}
	</script>
	<?php
		// Check for errors sent via GET
		if (isset($_GET["e"])) {
			// Create alert box
			// I can't use the other alert box because its CSS sets its display to none and altering CSS with PHP is improper
			echo "<div id='error' style='display:block;' class='alert alert-danger'>";
			$error = $_GET["e"];
			// Email is taken
			if ($error == "e") {
				echo "Email address already taken.";
			}
			echo "</div>";
		}
	?>
	<div id="error" class="alert alert-danger">
		Passwords must match.
	</div>
	<div id="form-title">
		<h1>Sign Up</h1>
	</div>
	<div id="form-container">
		<form action="signup.php" method="post" onsubmit="return validateForm()">
			<div class="form-group">
				<input autocomplete="off" autofocus class="form-control" name="email" placeholder="Email" type="email" required>
			</div>
			<div class="form-group">
				<input autocomplete="off" class="form-control" name="password" placeholder="Password" type="password" id="password" required>
			</div>
			<div class="form-group">
				<input autocomplete="off" class="form-control" name="c_password" placeholder="Confirm Password" id="confirmPassword" type="password" required>
			</div>
			<div class="text-center">
				<button class="btn btn-primary" type="submit">Sign Up</button>
			</div>
		</form>
	</div>
<?php
	include 'footer.php';
?>