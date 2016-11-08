//
//  ViewControllerCard.swift
//  iTrello
//
//  Created by Taylor Foster on 11/5/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import UIKit

class ViewControllerCard: UITableViewController {
    
    var API: TrelloAPI!
    var list: List!
    var board: Board!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = list.title
        API = TrelloAPI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        API.fetchCard(list.id) {
            (cards) -> Void in
            self.list.arrayofCards = cards
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    @IBAction func addNewCard(sender: AnyObject) {
        var API: TrelloAPI = TrelloAPI()
        API.addCard("Default", newCardDesc: "Insert Text Here", listID: list.id) {
            (card) -> Void in
            self.list.arrayofCards.append(card)
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cards", forIndexPath: indexPath)
        let card = list.arrayofCards[indexPath.row]
        
        cell.textLabel?.text = card.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.arrayofCards.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCard" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let card = list.arrayofCards[row]
                let cardEditController = segue.destinationViewController as! CardEditController
                cardEditController.card = card
                cardEditController.board = board
            }
        }
    }
}