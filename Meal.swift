//
//  Meal.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 05/09/15.
//  Copyright © 2015 AEIST. All rights reserved.
//

import UIKit

class Meal {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // ? means its possible for initializer to return nil, so its a failable initializer
    init?(name:String,photo:UIImage?,rating:Int) {
        self.name = name
        self.photo = photo
        self.rating = rating
        
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
}
