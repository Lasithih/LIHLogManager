//
//  ErrorLogViewController.swift
//  Smart Office
//
//  Created by Lasith Hettiarachchi on 10/23/15.
//  Copyright © 2015 fidenz. All rights reserved.
//

import UIKit
import LIHLogManager

class ErrorLogViewController: UIViewController {
    
    var logs: [LIHLog] = []
    var textFieldTitle: UITextField!
    var textFieldMessage: UITextField!
    
    @IBOutlet weak var tableLogs: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refreshControl.addTarget(self, action: Selector("refreshTable:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableLogs.addSubview(self.refreshControl)
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK - Private Methods
    func loadData() {
        
        //get the latest 200 records. Use nil to get all records.
        self.logs = LIHLogManager.getRecords(200)
    }
    
    //MARK: - Events
    @IBAction func clearPressed(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to clear the log?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Clear", style: UIAlertActionStyle.Destructive, handler: { (_) -> Void in
            
            LIHLogManager.clearLog()
            self.loadData()
            self.tableLogs.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add Record", message: "Insert a new record to add to log.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            self.textFieldTitle = textField
            self.textFieldTitle.placeholder = "Title"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            self.textFieldMessage = textField
            self.textFieldMessage.placeholder = "Message"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
            
            if let title = self.textFieldTitle.text, message = self.textFieldMessage.text where message != "" || title != "" {
                
                if LIHLogManager.addToLog(message, title: title) {
                    self.refreshTable(self.tableLogs)
                }
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func refreshTable(sender: AnyObject) {
        
        self.logs = LIHLogManager.getRecords(nil)
        self.tableLogs.reloadData()
        self.refreshControl.endRefreshing()
    }
    
}


extension ErrorLogViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.logs.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("logCell") as! ErrorLogTableViewCell
        
        cell.lblDateTime.text = "\(logs[indexPath.row].date)  \(logs[indexPath.row].time)"
        cell.lblTitle.text = logs[indexPath.row].title
        cell.lblMessage.text = logs[indexPath.row].message
        
        return cell
    }
}