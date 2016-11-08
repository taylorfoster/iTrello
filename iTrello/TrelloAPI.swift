//
//  File.swift
//  iTrello
//
//  Created by Taylor Foster on 10/30/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import Foundation
import UIKit


enum Result {
    case Sucess
    case Failure(ErrorType)
}

enum BoardError: ErrorType {
    case InvalidJSONData
}


struct TrelloAPI {
    
    //Connect to Trello boards
    
    var boardArray = [Board]()
    var listArray = [List]()
    var cardArray = [Card]()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
    }()
    
    
    mutating func processBoardRequest(data data: NSData?, error: NSError?) -> [Board]? {
        
        guard let JSONBoard = data else {

            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            guard let jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            
            for boardDictionary in jsonDictionary {
                if let id = boardDictionary["id"] as? String,
                    title = boardDictionary["name"] as? String{
                    boardArray.append(Board(title: title, id: id))
                }
            }
            return boardArray
        }
        catch let error {
            return nil
        }
    }
    
    mutating func processListRequest(data data: NSData?, error: NSError?) -> [List]? {
        
        guard let JSONList = data else {
            
            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            guard let jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            
            for listDictionary in jsonDictionary {
                if let id = listDictionary["id"] as? String,
                    title = listDictionary["name"] as? String{
                    listArray.append(List(title: title, id: id))
                }
            }
            return listArray
        }
        catch let error {
            return nil
        }
    }
    
    
    
    mutating func processCardRequest(data data: NSData?, error: NSError?) -> [Card]? {
        
        guard let JSONCard = data else {
            
            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            guard let jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            
            for cardDictionary in jsonDictionary {
                if let id = cardDictionary["id"] as? String,
                    title = cardDictionary["name"] as? String,
                    desc = cardDictionary["desc"] as? String{
                    cardArray.append(Card(title: title, id: id, desc: desc))
                }
            }
            return cardArray
        }
        catch let error {
            return nil
        }
    }
    
    mutating func processCreateCard(data data: NSData?, error: NSError?) -> Card? {
        
        guard let JSONCard = data else {
            
            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            guard let jsonDictionary = jsonObject as? [NSObject:AnyObject]
                else {
                    return nil
            }
            if let id = jsonDictionary["id"] as? String,
                title = jsonDictionary["name"] as? String,
                desc = jsonDictionary["desc"] as? String{
                var newCard = Card(title: title, id: id, desc: desc)
                return newCard
            }
            else {
                return nil
            }

        }
        catch let error {
            return nil
        }
    }
    

    
    mutating func fetchBoard(completion: ([Board]) -> Void) {
        
        let baseURLString = "https://api.trello.com/1/members/taylorfoster5/boards?key=ac0064ddd11b2b86ffb51bae8f4659aa&token=39ff6a886c7a898c5a16c00adb9dfffbfd4ab9885562f374bf3352e721d5d39d"
        let trelloURL = NSURL(string: baseURLString)
        let request = NSURLRequest(URL: trelloURL!)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processBoardRequest(data: data, error: error)
            
            
            completion(result!)
        }
        task.resume()
    }
    
    mutating func fetchList(boardID: String, completion: ([List]) -> Void) {
        
        let baseURLString = "https://api.trello.com/1/boards/\(boardID)/lists?key=ac0064ddd11b2b86ffb51bae8f4659aa&token=39ff6a886c7a898c5a16c00adb9dfffbfd4ab9885562f374bf3352e721d5d39d"
        let trelloURL = NSURL(string: baseURLString)
        let request = NSURLRequest(URL: trelloURL!)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processListRequest(data: data, error: error)
            
            
            completion(result!)
        }
        task.resume()
    }

    mutating func fetchCard(listID: String, completion: ([Card]) -> Void) {
        
        let baseURLString = "https://api.trello.com/1/lists/\(listID)/cards?key=ac0064ddd11b2b86ffb51bae8f4659aa&token=39ff6a886c7a898c5a16c00adb9dfffbfd4ab9885562f374bf3352e721d5d39d"
        let trelloURL = NSURL(string: baseURLString)
        let request = NSURLRequest(URL: trelloURL!)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processCardRequest(data: data, error: error)
            
            
            completion(result!)
        }
        task.resume()
    }
    
    mutating func addCard(newCardName: String, newCardDesc: String, listID: String, completion: (Card) -> Void) {
        
        let newcardTitle = newCardName.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        let newcardDesc = newCardDesc.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let baseURLString = "https://api.trello.com/1/cards?name=\(newcardTitle)&desc=\(newcardDesc)&idList=\(listID)&key=ac0064ddd11b2b86ffb51bae8f4659aa&token=39ff6a886c7a898c5a16c00adb9dfffbfd4ab9885562f374bf3352e721d5d39d"
        let trelloURL = NSURL(string: baseURLString)
        let request = NSMutableURLRequest(URL: trelloURL!)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processCreateCard(data: data, error: error)
            
            
            completion(result!)
        }
        task.resume()
        
    }
    
    mutating func deleteCard(cardID: String, completion: () -> Void) {
        
        let baseURLString = "https://api.trello.com/1/cards/\(cardID)?key=ac0064ddd11b2b86ffb51bae8f4659aa&token=39ff6a886c7a898c5a16c00adb9dfffbfd4ab9885562f374bf3352e721d5d39d"
        let trelloURL = NSURL(string: baseURLString)
        let request = NSMutableURLRequest(URL: trelloURL!)
        request.HTTPMethod = "DELETE"
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            
            completion()
        }
        task.resume()
        
    }
    
    mutating func updateCard(cardTitle: String, cardDesc: String, cardID: String, listID: String, completion: () -> Void) {
        
        
        let newcardTitle = cardTitle.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        let newcardDesc = cardDesc.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let baseURLString = "https://api.trello.com/1/cards/\(cardID)?name=\(newcardTitle)&desc=\(newcardDesc)&idList=\(listID)&key=ac0064ddd11b2b86ffb51bae8f4659aa&token=39ff6a886c7a898c5a16c00adb9dfffbfd4ab9885562f374bf3352e721d5d39d"
        let trelloURL = NSURL(string: baseURLString)
        let request = NSMutableURLRequest(URL: trelloURL!)
        request.HTTPMethod = "PUT"
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            
            completion()
        }
        task.resume()
        
    }


}