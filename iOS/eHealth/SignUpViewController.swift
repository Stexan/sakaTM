//
//  SignUpViewController.swift
//  eHealth
//
//  Created by Stefan Iarca on 11/7/15.
//  Copyright © 2015 Stefan Iarca. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,APIDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var topKeyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var wrapperView: UIView!
    let handler = GoogleAPIHandler();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUp(sender: AnyObject) {
   
        handler.delegate = self;
        handler.register(nameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!);
        
    }
    
    func handlerDidGetResults(results:Array<AnyObject>?){
        
        handler.delegate = nil;
        self.performSegueWithIdentifier("HomeSegue", sender: nil);
    }
    
    func handlerDidFailWithError(error:NSError?,description:String?){
        
        handler.delegate = nil;
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: description, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        topKeyboardHeight.constant = -48;
        UIView.animateWithDuration(0.2, animations: {
            self.wrapperView.layoutIfNeeded();
            }
        )
    }
    
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        if emailTextField.isFirstResponder() == true {
            topKeyboardHeight.constant = 8;
            UIView.animateWithDuration(0.2, animations: {
                self.wrapperView.layoutIfNeeded();
                }
            )
            emailTextField.resignFirstResponder();
        }else if passwordTextField.isFirstResponder() == true {
            topKeyboardHeight.constant = 8;
            UIView.animateWithDuration(0.2, animations: {
                self.wrapperView.layoutIfNeeded();
                }
            )
            passwordTextField.resignFirstResponder();
        }
    }

}
