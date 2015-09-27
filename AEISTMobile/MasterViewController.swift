//
//  MasterViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia
//  Copyright (c) 2015 Carlos Correia. All rights reserved.
//

import UIKit
//import WebImage

class MasterViewController: UITableViewController {
	var objects = [[String: String]]()
    var urlString: String?
    var typeT: Int?

    @IBOutlet weak var myNavTitle: UINavigationItem!
    
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

        
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

        doRequest()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Puxe para actualizar")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
    }
    
    func refresh(sender:AnyObject)
    {
        doRequest()
    }
    
    
    func doRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString!)!)
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
            
            if self.refreshControl!.refreshing {
                self.refreshControl!.endRefreshing()
            }

            if error != nil {
                print("error=\(error)")
                self.showError()
                return
            }
            
            let json = JSON(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.parseJSON(json,typeC: self.typeT!)
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            print("response = \(response)")
            
        }
        task.resume()
    }

    func parseJSON(json: JSON, typeC: Int) {
        objects.removeAll()
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
        if #available(iOS 8.0, *) {
            let ac = UIAlertController(title: "Erro de Carregamento", message: "Ocorreu um problema a carregar o conteudo. Tudo bem com a conexão à web? Recarregue deslizando para baixo", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.title = "Erro no Carregamento"
            alert.message = "Ocorreu um problema a carregar o conteudo. Tudo bem com a conexão à web? Recarregue deslizando para baixo"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
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
                (segue.destinationViewController as! AEISTViewController).detailObject = object
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

    /**
    * THIS IS SCANDALOUS - CORRECT !!!! //TODO
    *
    **/
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        if navigationController?.tabBarItem.tag == 2 {
          let cell = tableView.dequeueReusableCellWithIdentifier("AEISTCell", forIndexPath: indexPath) as! MyAEISTEventCell
            cell.myTitleLabel!.text = object["title"]
            cell.myDescLabel!.text = object["body"]
            let url = NSURL(string: object["pic"]!)
           // cell.myImageLabel.sd_setImageWithURL(url)
            SimpleCache.sharedInstance.getImage(url!) { image, error in
                if let err = error {
                    // thou shall handle errors
                } else if let fullImage = image {
                    cell.myImageLabel.image = fullImage
                }
            }

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
            //cell.myImage.sd_setImageWithURL(url)
            
            SimpleCache.sharedInstance.getImage(url!) { image, error in
                if let err = error {
                    // thou shall handle errors
                } else if let fullImage = image {
                    cell.myImage.image = fullImage
                }
            }
            return cell
        }
        
	}
    
    
}

