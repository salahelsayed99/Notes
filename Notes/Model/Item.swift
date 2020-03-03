//
//  Item.swift
//  Notes
//
//  Created by Salah  on 02/03/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object{
    
@objc dynamic var title:String=""
@objc dynamic var done:Bool=false
    
    var parentCategory=LinkingObjects(fromType: Parent.self, property: "items")
    
}
