//
//  AEISTViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 25/09/15.
//  Copyright © 2015 AEIST. All rights reserved.
//

import UIKit
import WebImage

class AEISTViewController: UITableViewController {
    let url = "http://www.loungerist.com/v1"
    var detailItem : String!
    var objects = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        doRequest()
    }
    
    func doRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let postString = "hash={\"controller\":\"AEIST\",\"action\":\"GetPessoas\",\"data\":{\"id\":"+detailItem+"} }"
        let headers: NSDictionary = ["X-Mobile-Key": "aeist", "Content-Type": "application/x-www-form-urlencoded", "X-No-Encrypt": AppConfig.noEncryptPwd]
        request.allHTTPHeaderFields = headers as? [String : String]
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                self.showError()
                return
            }
            
            let json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.parseJSON(json)
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            print("response = \(response)")
            
        }
        task.resume()
    }
    
    func parseJSON(json: JSON) {
        for result in json["data"].arrayValue {
            var nome,email,photoUrl,role : String
            nome = result["nome"].stringValue
            email = result["email"].stringValue
            photoUrl = result["photoUrl"].stringValue
            role = result["role"].stringValue
            let obj = ["nome": nome, "email": email, "photoUrl": photoUrl,"role": role]
            objects.append(obj)
        }
        self.tableView.reloadData()
    }

    
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        cell.myName!.text = object["nome"]
        cell.myEmail!.text = object["email"]
        cell.myRoll!.text = object["role"]
        let url = NSURL(string: object["photoUrl"]!)
        cell.myImage.sd_setImageWithURL(url)
        return cell
    }
}