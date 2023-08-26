//
//  Category.swift
//  Todoey
//
//  Created by Huzhy on 2023/08/26.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
