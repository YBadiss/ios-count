//
//  Counter.swift
//  Count
//
//  Created by Yacine Badiss on 06/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import Foundation
import UIKit

struct Counter: Codable {
    private var _id: Int64
    var id: Int64 {
        get { return _id }
    }

    private var _name: String
    var name: String {
        get { return _name }
        set(newName) {
            if !newName.isEmpty {
                _name = newName
            }
        }
    }

    private var _value: Int
    var value: Int {
        get { return _value }
    }
    mutating func addToValue(_ change: Int) -> Bool {
        let newValue = _value + change
        if newValue < 0 || newValue > objective {
            return false
        }
        _value = newValue
        return true
    }
    
    private var _objective: Int
    var objective: Int {
        get { return _objective }
        set(newObjective) {
            if newObjective >= 0 {
                _objective = newObjective
            }
        }
    }
    
    var done: Bool { return value == objective }
    
    init(id: Int64, name: String = "Counter", value: Int = 0, objective: Int = 10) {
        self._id = id
        self._name = name
        self._value = value
        self._objective = objective
    }
    
    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    static func decode(_ data: Data) -> Counter {
        return try! JSONDecoder().decode(Counter.self, from: data)
    }
}
