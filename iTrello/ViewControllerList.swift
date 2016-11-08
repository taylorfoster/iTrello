//
//  ViewControllerList.swift
//  iTrello
//
//  Created by Taylor Foster on 11/5/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import UIKit

class ViewControllerList: UITableViewController {
    
    var board: Board!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = board.title
        var API: TrelloAPI = TrelloAPI()
        API.fetchList(board.id) {
            (lists) -> Void in
            self.board.arrayofLists = lists
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Lists", forIndexPath: indexPath)
        let list = board.arrayofLists[indexPath.row]
        
        cell.textLabel?.text = list.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board.arrayofLists.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCard" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let list = board.arrayofLists[row]
                let viewControllerCard = segue.destinationViewController as! ViewControllerCard
                viewControllerCard.list = list
                viewControllerCard.board = board
            }
        }
    }
    
}