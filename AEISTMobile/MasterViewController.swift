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

			if let url = NSURL(string: urlString) {
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
			}
		} else {
			showError()
		}
	}

    func parseJSON(json: JSON, typeC: Int) {
		for result in json["results"].arrayValue {
            var title,body,sigs,pic,id : String
            if typeC==0 {
                title = result["evento_titulo"].stringValue
                body = result["evento_desc"].stringValue
                sigs = result["evento_link"].stringValue
                pic = result["evento_foto"].stringValue
                id = result["id"].stringValue
            } else {
                title = result["name"].stringValue
                body = result["desc"].stringValue
                sigs = result["dia"].stringValue
                pic = result["urlFoto"].stringValue
                id = result["id"].stringValue
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
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyEventCell

		let object = objects[indexPath.row]
		cell.myTitleLabel!.text = object["title"]
		cell.myDescLabel!.text = object["body"]
        let url = NSURL(string: object["pic"]!)
        cell.myImage.sd_setImageWithURL(url)
        if navigationController?.tabBarItem.tag == 0 {
            cell.myDateLabel!.hidden = true
        } else {
            cell.myDateLabel!.hidden = false
            cell.myDateLabel!.text = object["sigs"]
        }
		return cell
	}
    
}

