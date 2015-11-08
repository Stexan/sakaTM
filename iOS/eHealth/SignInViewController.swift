//
//  SignInViewController.swift
//  eHealth
//
//  Created by Stefan Iarca on 11/7/15.
//  Copyright © 2015 Stefan Iarca. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController,APIDelegate,UITextFieldDelegate {

    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topKeyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    let handler = GoogleAPIHandler();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logIn(sender: AnyObject) {
        
        handler.delegate = self;
        handler.login(emailTextField.text!, password: passwordTextField.text!);
    }
    
    func handlerDidGetResults(results:Array<AnyObject>?){
        
        handler.delegate = nil;
        let isDoctor = results?.first as! Bool;
        if isDoctor == true{
            self.performSegueWithIdentifier("DocSeg", sender: nil);
        }else{
            self.performSegueWithIdentifier("HomeSegue", sender: nil);
        }
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
        topKeyboardHeight.constant = -58;
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
