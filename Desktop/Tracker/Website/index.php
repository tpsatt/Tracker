<?php
	include 'header.php';
?>
<div id="title">
	<h1>Workouts</h1>
</div>
<div id="container">
	<?php

		// Check that the user can view this page
		if (!isset($_COOKIE["id"])) {
			header("Location: http://tracker.tpsatt.com/in.php");
			exit();
		}

		include 'sql.php';

		// Get user's id
		$id = $_COOKIE["id"];

		// Perform SQL
		$sql = $conn->prepare("SELECT * FROM workouts WHERE userid=?");
		$sql->bind_param("i", $id);
		$sql->execute();
		$result = $sql->get_result();

		// Display table of workouts
		if ($result->num_rows > 0) {
			echo "<table class='table table-striped table-hover'><tr><th>Date</th><th>Distance</th><th>Time</th><th>Average Speed</th></tr>";
			while ($row = $result->fetch_assoc()) {
				// Format data to be output
				// Learned to format dates here: https://www.w3schools.com/php/func_date_date_format.asp
				$date = date_create($row["date"]);
				$distance = $row["distance"] . "m";
				// Learned to convert seconds to time here: https://stackoverflow.com/questions/3856293/how-to-convert-seconds-to-time-format
				$hours = floor($row["time"] / 3600);
				$mins = floor($row["time"] / 60 % 60);
				if ($mins < 10) {
					$mins = "0" . $mins;
				}
				$secs = floor($row["time"] % 60);
				if ($secs < 10) {
					$secs = "0" . $secs;
				}
				$time = $hours . ":" . $mins . ":" . $secs;
				$speed = round($row["speed"], 2) . " mps";
				echo "<tr><td><a href='workout.php?workoutid=" . $row["id"] . "'>" . date_format($date, "m/d/Y") . "</a></td><td>" . $distance . "</td><td>" . $time . "</td><td>" . $speed . "</td></tr>";
			}
			echo "</table>";
		} else {
			echo "No workouts yet!";
		}

		$conn->close();

	?>
</div>
<?php
	include 'footer.php';
?>