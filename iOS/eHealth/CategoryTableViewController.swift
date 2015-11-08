//
//  CategoryTableViewController.swift
//  eHealth
//
//  Created by Stefan Iarca on 11/7/15.
//  Copyright © 2015 Stefan Iarca. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController, APIDelegate {

    let handler = GoogleAPIHandler();
    
    var categoryArray = Array<Category>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        handler.delegate = self;
        handler.getIndices();
        self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)

        // Configure the cell...
        let categ = categoryArray[indexPath.row];
        cell.textLabel?.text = categ.name;
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false;
        performSegueWithIdentifier("DetailedSegue", sender: categoryArray[indexPath.row]);
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

   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "DetailedSegue"{
     
            let dvc = segue.destinationViewController as! SingleGraphViewController;
            let category = sender as! Category;
            print(category.maxValue);
            print(category.minValue);
            dvc.category = category;
            
        }
    
    }
    
    
    func handlerDidGetResults(results:Array<AnyObject>?){
        
        handler.delegate = nil;
        categoryArray = results as! Array<Category>;
        tableView.reloadData();
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

}
