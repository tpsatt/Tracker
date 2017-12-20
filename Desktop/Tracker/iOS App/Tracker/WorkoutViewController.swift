//
//  WorkoutViewController.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/22/17.
//

import UIKit
import CoreLocation

class WorkoutViewController: UIViewController, CLLocationManagerDelegate {
    
    // User interface elements
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // Global variables
    var timer = Timer()
    var elapsedTime = 0
    var elapsedDistance = 0
    var workoutInProgress = false
    var firstLocation = true
    var startTime: Date = Date()
    var points: [Point] = []
    var locationManager: CLLocationManager!
    var lastLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize labels
        speedLabel.text = "0:00"
        timeLabel.text = "0:00:00"
        distanceLabel.text = "0"
        
        // Stylize buttons
        startButton.layer.cornerRadius = 10
        stopButton.layer.cornerRadius = 10
        
        // Initialize button and disable until location is available
        startButton.setTitle("Start", for: .normal)
        startButton.isEnabled = false
        
        // Record start time
        startTime = Date()
        
        // Initialize location
        // Learned to use CoreLocation here: https://www.hackingwithswift.com/read/22/2/requesting-location-core-location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // At first, I tried stopping and starting location monitoring when the workout was paused/resumed to conserve
        // battery life, but this led to weird issues with the location jumping that I couldn't avoid because of the
        // nature of CLLocationManager
        locationManager.startUpdatingLocation()
    }
    
    // Location permitted
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Enable start button
            startButton.isEnabled = true
        }
    }
    
    // Location updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only look at location if workout is in progress
        if (workoutInProgress) {
            // Check if workout has just been started/resumed (to prevent jumping)
            if (firstLocation) {
                lastLocation = locations[0]
                firstLocation = false
            } else {
                elapsedDistance += Int(locations[0].distance(from: lastLocation))
                lastLocation = locations[0]
            }
            // Save location info as a Point
            let newPoint = Point(time: elapsedTime, distance: elapsedDistance, speed: locations[0].speed, location: locations[0].coordinate, date: locations[0].timestamp)
            points.append(newPoint)
            
            // Update labels
            speedLabel.text = newPoint.getSplit()
            distanceLabel.text = String(elapsedDistance)
        }
    }
    
    // Start, pause or resume workout
    @IBAction func startWorkout() {
        if (workoutInProgress) {
            // Pause timer, set variable, change button text and stop monitoring location
            timer.invalidate()
            workoutInProgress = false
            startButton.setTitle("Resume", for: .normal)
        } else {
            // Start timer, set variable and change button text
            // Learned to use Timer here: https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(WorkoutViewController.updateTimer)), userInfo: nil, repeats: true)
            workoutInProgress = true
            startButton.setTitle("Pause", for: .normal)
            firstLocation = true
        }
    }
    
    // Update the timer label
    @objc func updateTimer() {
        // Increment timer
        elapsedTime += 1
        
        // Format the elapsed time to a readable format: hrs:mins:secs
        let hours = Int(elapsedTime/3600) % 3600
        let minutes = Int(elapsedTime/60) % 60
        let seconds = elapsedTime % 60
        
        // Set label
        timeLabel.text = String(format:"%i:%02i:%02i", hours, minutes, seconds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // End workout and pass data
        // Learned to pass variables here: https://stackoverflow.com/questions/26207846/pass-data-through-segue
        let workout = Workout(time: elapsedTime, distance: elapsedDistance, points: points, date: startTime)
        let destinationViewController = segue.destination as! SummaryViewController
        destinationViewController.workout = workout
    }

}
