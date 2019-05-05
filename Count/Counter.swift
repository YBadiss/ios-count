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
        set(newId) { _id = newId }
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

    private var _value: Int64
    var value: Int64 {
        get { return _value }
    }
    mutating func addToValue(_ change: Int64) -> Bool {
        let newValue = _value + change
        if newValue < 0 || newValue > objective {
            return false
        }
        _value = newValue
        return true
    }
    
    private var _objective: Int64
    var objective: Int64 {
        get { return _objective }
        set(newObjective) {
            if newObjective >= 0 {
                _objective = newObjective
            }
        }
    }
    
    public var startDate: Date
    public var endDate: Date
    var endDateStr: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            return formatter.string(from: endDate)
        }
    }
    
    var done: Bool { return value == objective }
    
    init(id: Int64, name: String = "Counter", value: Int64 = 0, objective: Int64 = 10, startDate: Date? = nil, endDate: Date? = nil) {
        self._id = id
        self._name = name
        self._value = value
        self._objective = objective
        self.endDate = endDate ?? Calendar.current.date(byAdding: .year, value: 1, to: startDate ?? Date())!
        self.startDate = startDate ?? Date()
    }
    
    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    static func decode(_ data: Data) -> Counter {
        return try! JSONDecoder().decode(Counter.self, from: data)
    }
}
