/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate  {
    
    var signUpActive = true
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var registeredText: UILabel!
    
    @IBOutlet weak var goToButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        if #available(iOS 8.0, *) {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error in form", message:"Please enter a username and password")
            
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "please try again later"
            
            if signUpActive == true {
            
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            
            
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    
                  self.performSegueWithIdentifier("login", sender: self)
                    
                }  else {
                    
                    if  let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                    }
                    
                    self.displayAlert("Failed signup", message: errorMessage)
                    
                }
            })
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                         self.performSegueWithIdentifier("login", sender: self)
                        print("logged in!")
                        
                        
                        
                    } else {
                        
                        if  let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed login", message: errorMessage)
                        
                    }
                })
                
            }
        
    }
        
    }

    @IBAction func logIn(sender: AnyObject) {
        
        if signUpActive == true {
            
            goButton.setTitle("Log In", forState: UIControlState.Normal)
            
            registeredText.text = "Not registered?"
            
            goToButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
            
        } else {
            
            goButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already registered?"
            
            goToButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signUpActive = true
        }
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
         username.delegate = self
        password.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.objectId != nil {
            
        self.performSegueWithIdentifier("login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        return true
    }
}
