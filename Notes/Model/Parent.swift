//
//  Parent.swift
//  Notes
//
//  Created by Salah  on 02/03/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import Foundation
import RealmSwift

class Parent:Object{
    
   @objc dynamic var name:String=""
    @objc dynamic var colour:String=""
    
    var items=List<Item>()
    
}
