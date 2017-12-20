//
//  SignInViewController.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/23/17.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Stylize buttons
        backButton.layer.cornerRadius = 10
        signInButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        // Add gesture recognizer to dismiss keyboard on tap
        // Learned to do this here: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signIn() {
        // Validate input
        // Learned to check for empty text field here: https://stackoverflow.com/questions/24102641/how-to-check-if-a-text-field-is-empty-or-not-in-swift
        if let text = emailField.text, text.isEmpty {
            displayError(error: "Enter email")
            return
        }
        if let text = passwordField.text, text.isEmpty {
            displayError(error: "Enter password")
            return
        }
        
        // Send post request to PHP web service to log in
        // Learned about POST requests here: https://stackoverflow.com/questions/43779111/http-request-in-swift-with-post-method-in-swift3
        var request = URLRequest(url: URL(string: "http://tracker.tpsatt.com/signin.php?source=mobile")!)
        request.httpMethod = "POST"
        let postString = "email=\(emailField.text!)&password=\(passwordField.text!)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let useableData = String(data: data!, encoding: .utf8) {
                if (useableData != "error") {
                    DispatchQueue.main.async {
                        // The user's id is output on the webpage (when source=mobile)
                        UserDefaults.standard.set(useableData, forKey: "userid")
                        UserDefaults.standard.set(self.emailField.text!, forKey: "email")
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.displayError(error: "Incorrect email or password")
                    }
                }
            }
        }
        task.resume()
    }
    
    // Go back to home screen
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
    // Display errors in UIAlertBox
    func displayError(error: String) {
        // Learned to use alert boxes here: https://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
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
