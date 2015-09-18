//
//  EventViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 07/09/2015.
//  Copyright (c) 2015 AEIST. All rights reserved.
//

import UIKit
import WebImage

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var detailItem: [String: String]!
    
    @IBOutlet weak var myConcNavItem: UINavigationItem!
    @IBOutlet weak var myDescText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventImage: UIImageView!
    var objects = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.tabBarItem.tag == 0 {
            myConcNavItem.title = "Evento"
            post(Int(detailItem["id"]!)!)
        } else if navigationController?.tabBarItem.tag == 1 {
            tableView.hidden = true
            myConcNavItem.title = "Churrasco"
        } else {
            eventImage.hidden = true
            myConcNavItem.title = detailItem["nome"]
        }
        
        
        if let body = detailItem["body"] {
            myDescText.text = body
            myDescText.textContainer.lineFragmentPadding = 0;
            myDescText.textContainerInset = UIEdgeInsetsZero;
        }
        
        if let pic = detailItem["pic"] {
            let url = NSURL(string: pic)
            eventImage.sd_setImageWithURL(url)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func post(id: Int) {
        let request = NSMutableURLRequest(URL: NSURL(string: AppConfig.urlPost)!)
        request.HTTPMethod = "POST"
        
        let postString = "hash={\"controller\":\"AEIST\",\"action\":\"GetEventDetails\",\"data\":{ \"id\":\(id) } }"
        let headers: NSDictionary = ["X-Mobile-Key": "aeist", "Content-Type": "application/x-www-form-urlencoded", "X-No-Encrypt": AppConfig.noEncryptPwd]
        request.allHTTPHeaderFields = headers as? [String : String]
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            print("response = \(response)")
            
            let json = JSON(data: data!)
            self.parseJSON(json)
        }
        task.resume()
    }
    
    func parseJSON(json: JSON) {
        for result in json["data"].arrayValue {
            var title: String
            title = result["texto_add"].stringValue
            if(title.isEmpty) {
                continue
            }
            print("Titulo: " + title)
            let obj = ["title": title]
            objects.append(obj)
        }
        
        self.tableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
        
        let object = objects[indexPath.row]
        cell.myTextLabel!.text = object["title"]
        cell.myTextLabel!.sizeToFit()
        return cell
    }
    
    
    
}
