//
//  Category.swift
//  Todoey
//
//  Created by Oz Arie Tal Shachar on 21.2.2018.
//  Copyright © 2018 Oz Arie Tal Shachar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    //Each Category points to a list of items
    //List comes from Realm - not Swift!
    let items : List<Item> = List<Item>()
}
