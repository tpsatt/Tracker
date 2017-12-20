<html>
	<head>
		<title>Tracker</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
		<link rel="stylesheet" href="style.css" type="text/css">
	</head>
	<body>
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
			<div class="container-fluid">
				<div class="navbar-header">
					<a class="navbar-brand" href="/">Tracker</a>
				</div>
				<ul class="navbar-nav ml-auto">
					<?php
						// Display appropriate links based off of if the user is logged in
						if (isset($_COOKIE["id"])) {
							echo "<li class='nav-item'><a href='logout.php' class='nav-link'>Sign Out</a></li>";
						} else {
							echo "<li class='nav-item'><a href='in.php' class='nav-link'>Sign In</a></li>";
							echo "<li class='nav-item'><a href='up.php' class='nav-link'>Sign Up</a></li>";
						}
					?>
				</ul>
			</div>
		</nav>