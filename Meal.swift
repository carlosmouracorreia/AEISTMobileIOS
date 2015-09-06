//
//  Meal.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 05/09/15.
//  Copyright © 2015 AEIST. All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {
    
    // MARK : Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    // MARK: Types
    struct PropertyKey {
        static let nameKey = "name"
        static let ratingKey = "rating"
        static let photoKey = "photo"
    }
    
    // ? means its possible for initializer to return nil, so its a failable initializer
    init?(name:String,photo:UIImage?,rating:Int) {
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
    // MARK : NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    //The required keyword means this initializer must be implemented on every subclass of the class that defines this initializer.
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        self.init(name: name, photo: photo, rating: rating)
    }
}
