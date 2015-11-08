//
//  AnalisysTableViewController.swift
//  eHealth
//
//  Created by Stefan Iarca on 11/7/15.
//  Copyright © 2015 Stefan Iarca. All rights reserved.
//

import UIKit

class AnalisysTableViewController: UITableViewController,APIDelegate,UITextFieldDelegate {

    let handler = GoogleAPIHandler();
    
    var userArray = Array<User>()
    let textWrapperView = UIView(frame: CGRectMake(0,0,UIScreen().bounds.size.width,38));
    var textField = UITextField(frame: CGRectMake(0,20,280,30))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        handler.delegate = self;
        handler.getDoctorUsers();
        
        textWrapperView.hidden = false;
        confTextView();
        textWrapperView.addSubview(textField);
        textField.delegate = self;
        
    }
    
    func confTextView(){
        let sampleTextField = UITextField(frame: CGRectMake(20,4,280,32))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFontOfSize(15)
        sampleTextField.borderStyle = UITextBorderStyle.RoundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.No
        sampleTextField.keyboardType = UIKeyboardType.Default
        sampleTextField.returnKeyType = UIReturnKeyType.Done
        sampleTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        sampleTextField.delegate = self
        self.textField = sampleTextField;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let user = userArray[indexPath.row];
        cell.textLabel?.text = user.name;

        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false;
        performSegueWithIdentifier("HomeSegue", sender: userArray[indexPath.row]);
    }
    
    func handlerDidGetResults(results:Array<AnyObject>?){
        
        handler.delegate = nil;
        userArray = results as! Array<User>
        tableView.reloadData();
        print(userArray);
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "HomeSegue"{
            
            let dvc = segue.destinationViewController as! CategoryTableViewController;
            let user = sender as! User;
            dvc.uid = user.uid;
            
        }
        
    }

    
    @IBAction func addUser(sender: AnyObject) {
        self.tableView.tableHeaderView = textWrapperView;
        textField.becomeFirstResponder();
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        handler.delegate = self;
        handler.addUserForDoctor(textField.text!);
        
        self.tableView.tableHeaderView = nil

        return true;
    }
    
}
