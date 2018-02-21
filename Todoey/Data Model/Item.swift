//
//  Item.swift
//  Todoey
//
//  Created by Oz Arie Tal Shachar on 21.2.2018.
//  Copyright © 2018 Oz Arie Tal Shachar. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    /* Inverse Relationships
    Relationships are unidirectional. Take our two classes, Category and Item. If Category.items links to an Item instance, you can follow the linl from Category to Item, but there's no way to go from an Item to its category object. You can set a one-to-one property, but those links are independent from one another. To solve this problem, Realm provides linking objects properties to represent Inverse Relationships.
     */
    
    
    //without .self it will create an object from type Category, but we want
    let parentCategory : LinkingObjects = LinkingObjects(fromType: Category.self, property: "items")
}
