//
//  Dog.swift
//  RealmDemo
//
//  Created by David Mills on 2019-01-31.
//  Copyright © 2019 David Mills. All rights reserved.
//

import Foundation
import RealmSwift

class Dog: Object {
  @objc dynamic var name = ""
  @objc dynamic var age = 0
}
