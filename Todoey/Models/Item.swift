//
//  Item.swift
//  Todoey
//
//  Created by Huzhy on 2023/08/26.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
