//
//  CardEditController.swift
//  iTrello
//
//  Created by Taylor Foster on 11/6/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import UIKit

class CardEditController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var card: Card!
    var board: Board!
    var API: TrelloAPI!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var deletion: UIButton!
    @IBOutlet var moveCardPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        self.title = "Edit \(card.title)"
        API = TrelloAPI()
        titleTextField.text = card.title
        descTextView.text = card.desc
        descTextView.layer.borderWidth = 1
        self.moveCardPickerView.delegate = self
        self.moveCardPickerView.dataSource = self
    }
    
    @IBAction func deleteCard(sender: UIButton) {
        API.deleteCard(card.id) {
            () -> Void in
            dispatch_async(dispatch_get_main_queue(), { self.navigationController?.popViewControllerAnimated(true) })
        }
        
    }
    
    @IBAction func updateCard(sender: UIButton) {
        let row = self.moveCardPickerView.selectedRowInComponent(0)
        let list = board.arrayofLists[row]
        API.updateCard(titleTextField.text!, cardDesc: descTextView.text, cardID: card.id, listID: list.id) {
            () -> Void in
            dispatch_async(dispatch_get_main_queue(), { self.navigationController?.popViewControllerAnimated(true) })
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return board.arrayofLists.count
    }
    

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = board.arrayofLists[row]
        return list.title
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}