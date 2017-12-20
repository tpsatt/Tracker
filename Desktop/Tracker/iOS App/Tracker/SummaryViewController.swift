//
//  SummaryViewController.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/22/17.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    // Initialize workout with dummy variable
    var workout = Workout(time: 0, distance: 0, points: [], date: Date())
    var signedIn = false
    var errors = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set labels
        // Learned to format dates here: https://stackoverflow.com/questions/35700281/date-format-in-swift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        dateLabel.text = dateFormatter.string(from: workout.date)
        
        // Stylize buttons
        discardButton.layer.cornerRadius = 10
        mapButton.layer.cornerRadius = 10
        uploadButton.layer.cornerRadius = 10
        
        // Set text to workout data
        distanceLabel.text = String(format: "%i m", workout.distance)
        timeLabel.text = workout.formattedTime()
        speedLabel.text = String(format: "%.2f m/s", workout.averageSpeed)
    }
    
    // Setup for the upload/sign in button will happen here because this method is called when views are popped
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if the user is signed in to allow uploading (id = -1 if not)
        if (UserDefaults.standard.integer(forKey: "userid") != -1) {
            uploadButton.setTitle("Upload", for: .normal)
            signedIn = true
        } else {
            uploadButton.setTitle("Sign In", for: .normal)
            signedIn = false
        }
    }
    
    @IBAction func upload() {
        // Check if the user is signed in
        if (!signedIn) {
            // Load sign in page
            performSegue(withIdentifier: "SignInFromSummarySegue", sender: nil)
            return
        }
        
        // Upload workout information to web service
        var request = URLRequest(url: URL(string: "http://tracker.tpsatt.com/uploadworkout.php")!)
        request.httpMethod = "POST"
        // Prepare POST data with workout data
        let postString = "userid=\(UserDefaults.standard.integer(forKey: "userid"))&time=\(workout.time)&distance=\(workout.distance)&speed=\(workout.averageSpeed)&date=\(workout.sqlDate())"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                // Status code 200 = workout uploaded successfully
                if (response.statusCode == 200) {
                    if let useableData = String(data: data!, encoding: .utf8) {
                        DispatchQueue.main.async {
                            // Upload the points using the workout's id which is output on the webpage
                            self.uploadPoints(workoutId: Int(useableData)!)
                        }
                    }
                } else {
                    // Something went wrong
                    DispatchQueue.main.async {
                        self.displayError(error: "Could not upload workout")
                        self.errors = true
                    }
                }
            }
        }
        task.resume()
    }
    
    func uploadPoints(workoutId: Int) {
        // Upload points to web service
        var request = URLRequest(url: URL(string: "http://tracker.tpsatt.com/uploadpoint.php")!)
        request.httpMethod = "POST"
        
        // Iterate over each point to upload each one
        for point in workout.points {
            // Prepare POST data with Point data
            let postString = "workoutid=\(workoutId)&latitude=\(point.location.latitude)&longitude=\(point.location.longitude)&time=\(point.time)&distance=\(point.distance)&speed=\(point.speed)&date=\(point.sqlDate())"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    // Status code 200 = point uploaded successfully
                    if (response.statusCode != 200) {
                        // Something went wrong
                        DispatchQueue.main.async {
                            print(postString)
                            print(response)
                            self.displayError(error: "Could not upload point")
                            self.errors = true
                        }
                    }
                }
            }
            task.resume()
        }
        
        if (!errors) {
            success()
        }
    }
    
    @IBAction func discard() {
        // Pop back to home view without saving data
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Display errors in UIAlertBox
    func displayError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Display UIAlertBox saying workout was successfully uploaded
    func success() {
        let alert = UIAlertController(title: "Success", message: "Workout uploaded successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        // Disable upload button to prevent multiple uploads
        uploadButton.isEnabled = false
        uploadButton.alpha = 0.3
        discardButton.setTitle("Back", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowMap") {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.workout = workout
        }
    }

}
