//
//  MealTableViewController.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 06/09/15.
//  Copyright © 2015 AEIST. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {

    // MARK : Properties
    
    //being var makes array mutable!
    var meals = [Meal]()
    
    func loadSampleMeals() {
    
    let photo1 = UIImage(named: "meal1.jpg")!
    let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
    
    let photo2 = UIImage(named: "meal2.jpg")!
    let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
    
    let photo3 = UIImage(named: "meal3.jpg")!
    let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        let photo4 = UIImage(named: "meal4.jpg")!
        let meal4 = Meal(name: "Pasta with Meatballs", photo: photo4, rating: 3)!

        let photo5 = UIImage(named: "meal5.jpg")!
        let meal5 = Meal(name: "Chocolate with Meatballs", photo: photo5, rating: 1)!
        let photo6 = UIImage(named: "meal6.jpg")!
        let meal6 = Meal(name: "Hate with Meatballs", photo: photo6, rating: 2)!



    meals += [meal1,meal2,meal3]
    meals += [meal4,meal5,meal6]
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMeals()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
