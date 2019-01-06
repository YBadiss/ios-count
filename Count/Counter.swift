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
    var name: String
    var value: Int {
        didSet {
            if value < 0 {
                value = 0
            }
            else if value > objective {
                value = objective
            }
        }
    }
    var objective: Int
    var done: Bool { return value == objective }
    var status: String {
        let doneMark = done ? " ✅" : ""
        return "\(value)/\(objective)\(doneMark)"
    }
    
    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    static func decode(_ data: Data) -> Counter {
        return try! JSONDecoder().decode(Counter.self, from: data)
    }
}
