//
//  SignUpViewController.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/24/17.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Stylize buttons
        backButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        // Add gesture recognizer to dismiss keyboard on tap
        // Learned to do this here: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signUp() {
        // Validate input
        if let text = emailField.text, text.isEmpty {
            displayError(error: "Enter email")
            return
        }
        if let text = passwordField.text, text.isEmpty {
            displayError(error: "Enter password")
            return
        }
        if let text = confirmPasswordField.text, text.isEmpty {
            displayError(error: "Enter password again")
            return
        }
        if (passwordField.text != confirmPasswordField.text) {
            displayError(error: "Passwords must match")
            return
        }
        
        // Send post request to PHP web service
        var request = URLRequest(url: URL(string: "http://tracker.tpsatt.com/signup.php?source=mobile")!)
        request.httpMethod = "POST"
        let postString = "email=\(emailField.text!)&password=\(passwordField.text!)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if email available
            if let useableData = String(data: data!, encoding: .utf8) {
                if (useableData != "taken") {
                    DispatchQueue.main.async {
                        // The user's id is output on the webpage (when source=mobile)
                        UserDefaults.standard.set(useableData, forKey: "userid")
                        UserDefaults.standard.set(self.emailField.text!, forKey: "email")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.displayError(error: "Email address taken")
                    }
                }
            }
        }
        task.resume()
    }
    
    // Go back to sign in page
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
    // Display errors in UIAlertBox
    func displayError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
