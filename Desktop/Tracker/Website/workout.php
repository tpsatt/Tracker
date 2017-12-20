<?php
	include 'header.php';

	// Check that the user can view this page
	if (!isset($_COOKIE["id"])) {
		header("Location: http://tracker.tpsatt.com/in.php");
		exit();
	}

	// Get workout id and user's id
	$workoutid = $_GET["workoutid"];
	$id = $_COOKIE["id"];

	include 'sql.php';

	// Perform SQL to get workout data
	$sql = $conn->prepare("SELECT * FROM workouts WHERE id=?");
	$sql->bind_param("i", $workoutid);
	$sql->execute();
	$sql->bind_result($workoutid, $userid, $time, $distance, $speed, $date);
	$sql->fetch();
	$sql->close();

	// Ensure that the workout exists
	if (!$workoutid) {
		header("Location: http://tracker.tpsatt.com/");
		exit();
	}

	// Ensure that the user can view this workout
	if ($userid != $id) {
		header("Location: http://tracker.tpsatt.com/");
		exit();
	}

	// Perform SQL to get point data
	$sql1 = $conn->prepare("SELECT * FROM points WHERE workoutid=?");
	$sql1->bind_param("i", $workoutid);
	$sql1->execute();
	$result = $sql1->get_result();

	// Get results into points array
	$points = [];

	while ($point = $result->fetch_assoc()) {
		array_push($points, $point);
	}

	$conn->close();

	// Format workout data
	$dateString = date_format(date_create($date), "F d, Y");
	$distanceString = $distance . " meters";

	$hours = floor($time / 3600);
	$mins = floor($time / 60 % 60);
	if ($mins < 10) {
		$mins = "0" . $mins;
	}
	$secs = floor($time % 60);
	if ($secs < 10) {
		$secs = "0" . $secs;
	}
	$timeString = $hours . ":" . $mins . ":" . $secs;

	$speedString = round($speed, 2) . " mps";
?>

<div id="title">
	<h1><?php echo $dateString; ?></h1>
</div>
<div id="container">
	<script>
		// Get points data
		// Learned to pass data from PHP to JavaScript here: https://stackoverflow.com/questions/10889233/efficient-way-to-pass-variables-from-php-to-javascript
		var points = <?php echo json_encode($points); ?>;
		points.sort(comparePoints);
	
		// Get needed data from points
		var positions = [];
		var times = [];
		var speeds = [];
		var distances = [];

		for (i = 0, l = points.length; i < l; i++) {
			positions.push({lat: points[i]["latitude"], lng: points[i]["longitude"]});
			times.push(readTime(points[i]["time"]));
			// Round speed to 2 decimal places (learned to here: https://stackoverflow.com/questions/11832914/round-to-at-most-2-decimal-places-only-if-necessary)
			speeds.push(Math.round(points[i]["speed"] * 100) / 100);
			distances.push(points[i]["distance"]);
		}

		// Initialize Google Map with path line
		// Learned from Google Maps API: https://developers.google.com/maps/documentation/javascript/examples/polyline-simple
		function initMap() {
			var map = new google.maps.Map(document.getElementById('map'), {
				center: positions[0],
				zoom: 15
			});

			var workoutPath = new google.maps.Polyline({
				path: positions,
				geodesic: true,
				strokeColor: '#FF0000',
				strokeOpacity: 1.0,
				strokeWeight: 3
			});

			workoutPath.setMap(map);
		}

		document.addEventListener("DOMContentLoaded", function() {
			// Initialize chart using chart.js
			// Learned from documentation: http://www.chartjs.org/docs/latest/getting-started/
			var ctx = document.getElementById('chart').getContext('2d');
			var chart = new Chart(ctx, {
				type: 'line',
				data: {
					labels: times,
					datasets: [{
						label: "Speed (mps)",
						borderColor: 'rgb(255, 99, 132)',
						data: speeds
					}]
				},
				options: {
					title: {
						display: true,
						text: 'Speed v. Time',
						fontSize: 20
					},
					legend: {
						display: true,
						position: 'right'
					},
					scales: {
						xAxes: [{
							ticks: {
								autoSkip: true,
								maxTicksLimit: 10
							}
						}]
					}
				}
			});
		});

		// Function to compare points by time
		function comparePoints(a, b) {
			if (a["time"] < b["time"]) {
				return -1;
			} else if (a["time"] > b["time"]) {
				return 1;
			} else {
				return 0;
			}
		}

		// Function to convert seconds to user readable format
		function readTime(secs) {
			var hours = Math.floor(secs / 3600);
			secs -= hours * 3600;
			var mins = Math.floor(secs / 60);
			var minsString = "";
			secs -= mins * 60;
			var secsString = "";

			if (mins < 10) {
				minsString = "0" + mins;
			} else {
				minsString = mins;
			}

			if (secs < 10) {
				secsString = "0" + secs;
			} else {
				secsString = secs;
			}
			return hours + ":" + minsString + ":" + secsString;
		}
	</script>
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBPNffE_it3FsebeONhsRjkwV-NO4TBOOk&callback=initMap" async defer></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
	<div class="row">
		<div class="col-sm-8">
			<!-- Map -->
			<div id="map" style="width:100%;height:50%;"></div>
		</div>
		<div class="col-sm-4">
			<!-- Workout data -->
			<ul class="list-group">
				<?php
					// Display workout data
					echo "<li class='list-group-item'>Distance: " . $distanceString . "</li>";
					echo "<li class='list-group-item'>Elapsed Time: " . $timeString . "</li>";
					echo "<li class='list-group-item'>Average Speed: " . $speedString . "</li>";
				?>
			</ul>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<!-- Graph -->
			<canvas id="chart"></canvas>
		</div>
	</div>
</div>
<?php
	include 'footer.php';
?>