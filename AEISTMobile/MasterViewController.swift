//
//  MasterViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia
//  Copyright (c) 2015 Carlos Correia. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	var objects = [[String: String]]()

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

        let urlString = "http://mobile.aeist.pt/service_ios.php"

			if let url = NSURL(string: urlString) {
			if let data = try? NSData(contentsOfURL: url, options: []) {
				let json = JSON(data: data)
                parseJSON(json)
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

	func parseJSON(json: JSON) {
		for result in json["results"].arrayValue {
			let title = result["evento_titulo"].stringValue
			let body = result["evento_desc"].stringValue
			let sigs = result["evento_link"].stringValue
			let obj = ["title": title, "body": body, "sigs": sigs]
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
                (segue.destinationViewController as! DetailViewController).detailItem = object
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
		
		return cell
	}
    
}

