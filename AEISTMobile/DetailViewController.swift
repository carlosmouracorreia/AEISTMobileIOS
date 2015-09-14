//
//  DetailViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 07/09/2015.
//  Copyright (c) 2015 AEIST. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	var detailItem: [String: String]!

    @IBOutlet weak var myConcNavItem: UINavigationItem!
    @IBOutlet weak var myDescText: UITextView!

	override func viewDidLoad() {
		super.viewDidLoad()
        if navigationController?.tabBarItem.tag == 0 {
            myConcNavItem.title = "Evento"
            post(Int(detailItem["id"]!)!)
        } else {
            myConcNavItem.title = "Churrasco"
        }

        
		if let body = detailItem["body"] {
			myDescText.text = body
		}
	}
    
    //     func post(params : Dictionary<String, String>, url : String) {
    
    func post(id: Int) {
        let request = NSMutableURLRequest(URL: NSURL(string: AppConfig.urlPost)!)
        request.HTTPMethod = "POST"
        
        let postString = "hash={\"controller\":\"AEIST\",\"action\":\"GetEventDetails\",\"data\":{ \"id\":\(id) } }"
        //CREATE A CONSTANT FILE WITH THIS THING PWD
        let headers: NSDictionary = ["X-Mobile-Key": "aeist", "Content-Type": "application/x-www-form-urlencoded", "X-No-Encrypt": AppConfig.noEncryptPwd]
        request.allHTTPHeaderFields = headers as? [String : String]
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}

