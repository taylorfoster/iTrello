//
//  ViewController.swift
//  iTrello
//
//  Created by Taylor Foster on 10/30/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var arrayofBoards = [Board]()
    override func viewDidLoad() {
        super.viewDidLoad()
        var API: TrelloAPI = TrelloAPI()
        API.fetchBoard() {
            (boards) -> Void in
                self.arrayofBoards = boards
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Boards", forIndexPath: indexPath)
        let board = arrayofBoards[indexPath.row]
        
        cell.textLabel?.text = board.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayofBoards.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowList" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let board = arrayofBoards[row]
                let viewControllerList = segue.destinationViewController as! ViewControllerList
                viewControllerList.board = board
            }
        }
    }
    
}


