//
//  ViewController.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/22/17.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var signedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Stylize buttons
        signInButton.layer.cornerRadius = 10
        startButton.layer.cornerRadius = 10
        
        // Get saved user data
        let id = UserDefaults.standard.integer(forKey: "userid")
        
        // ID will be set to -1 if user is not signed in
        if (id != -1) {
            signedIn = true
        }
    }
    
    // Setup for user information happens here because this will be called when views are popped
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if the user is signed in (id = -1 if not)
        // Set label text, button text and variable
        if (UserDefaults.standard.integer(forKey: "userid") != -1) {
            userStatusLabel.text = UserDefaults.standard.string(forKey: "email")
            signInButton.setTitle("Sign Out", for: .normal)
            signedIn = true
        } else {
            userStatusLabel.text = "Not signed in"
            signInButton.setTitle("Sign In", for: .normal)
            signedIn = false
        }
    }
    
    @IBAction func signIn() {
        // Sign user out by setting ID to -1, or redirect to sign in page
        if (signedIn) {
            UserDefaults.standard.set(-1, forKey: "userid")
            signedIn = false
            userStatusLabel.text = "Not signed in"
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

