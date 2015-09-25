//
//  MasterViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia
//  Copyright (c) 2015 Carlos Correia. All rights reserved.
//

import UIKit
import WebImage

class MasterViewController: UITableViewController {
	var objects = [[String: String]]()

    @IBOutlet weak var myNavTitle: UINavigationItem!
    
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

        var urlString: String
        var typeT: Int
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "http://mobile.aeist.pt/service_ios.php"
            typeT = 0
            myNavTitle.title = "Eventos"
        } else if navigationController?.tabBarItem.tag == 1  {
            urlString = "http://mobile.aeist.pt/service_ios_bbq.php"
            typeT = 1
            myNavTitle.title = "Churrascos"
        } else {
            urlString = "http://www.loungerist.com/v1"
            typeT = 2
            myNavTitle.title = "A AEIST"
        }

        doRequest(typeT,web: urlString)
        
      /*  let url = NSMutableURLRequest(URL: NSURL(string: urlString)!)
			if let data = try? NSData(contentsOfURL: url, options: []) {
				let json = JSON(data: data)
                parseJSON(json,typeC: typeT)
				/*if json["metadata"]["responseInfo"]["status"].intValue == 200 {
					parseJSON(json)
				} else {
					showError()
				} */
			} else {
				showError()
			} */
	}
    
    
    func doRequest(typeT: Int,web url:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = typeT==2 ? "POST" : "GET"
        
        /**
        * We need to make an HTTP Request using POST verb here, that's where all the confusing is arising....
        *
        **/
        if typeT==2 {
             let postString = "hash={\"controller\":\"AEIST\",\"action\":\"GetPelouros\",\"data\":{} }"
             let headers: NSDictionary = ["X-Mobile-Key": "aeist", "Content-Type": "application/x-www-form-urlencoded", "X-No-Encrypt": AppConfig.noEncryptPwd]
             request.allHTTPHeaderFields = headers as? [String : String]
             request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        }
          let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                self.showError()
                return
            }
            
            let json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.parseJSON(json,typeC: typeT)
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            print("response = \(response)")
            
        }
        task.resume()
    }

    func parseJSON(json: JSON, typeC: Int) {
        let lol : String = typeC==2 ? "data" : "results"
        for result in json[lol].arrayValue {
            var title,body,sigs,pic,id : String
            switch(typeC) {
            case 0:
                title = result["evento_titulo"].stringValue
                body = result["evento_desc"].stringValue
                sigs = result["evento_link"].stringValue
                pic = result["evento_foto"].stringValue
                id = result["id"].stringValue
                break;
            case 1:
                title = result["name"].stringValue
                body = result["desc"].stringValue
                sigs = result["dia"].stringValue
                pic = result["urlFoto"].stringValue
                id = result["id"].stringValue
                break;
            case 2:
                title = result["nome"].stringValue
                body = result["desc"].stringValue
                sigs = ""
                pic = result["photoUrl"].stringValue
                id = result["id"].stringValue
                break;
            default:
                title = ""
                body = ""
                sigs = ""
                pic = ""
                id = ""
                break;
                
            }
            let obj = ["title": title, "body": body, "sigs": sigs,"pic": pic,"id":id]
			objects.append(obj)
		}

		self.tableView.reloadData()
	}

	func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
		        let object = objects[indexPath.row]
                (segue.destinationViewController as! EventViewController).detailItem = object
            }
		}
        if segue.identifier == "showDetailAEIST" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                (segue.destinationViewController as! AEISTViewController).detailItem = object["id"]
            }
        }
    }

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        if navigationController?.tabBarItem.tag == 2 {
          let cell = tableView.dequeueReusableCellWithIdentifier("AEISTCell", forIndexPath: indexPath) as! MyAEISTEventCell
            cell.myTitleLabel!.text = object["title"]
            cell.myDescLabel!.text = object["body"]
            let url = NSURL(string: object["pic"]!)
            cell.myImageLabel.sd_setImageWithURL(url)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyEventCell
            if navigationController?.tabBarItem.tag == 0 {
                cell.myDateLabel!.hidden = true
            } else {
                cell.myDateLabel!.hidden = false
                cell.myDateLabel!.text = object["sigs"]
            }
            cell.myTitleLabel!.text = object["title"]
            cell.myDescLabel!.text = object["body"]
            let url = NSURL(string: object["pic"]!)
            cell.myImage.sd_setImageWithURL(url)
            return cell
        }
        
	}
    
}

