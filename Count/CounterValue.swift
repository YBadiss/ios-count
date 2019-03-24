//
//  CounterValue.swift
//  Count
//
//  Created by Yacine Badiss on 24/03/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import Foundation

class CounterValue {
    var timestamp: Date
    var value: Int64
    
    init(timestamp: Int64, value: Int64) {
        self.value = value
        self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
    }
}
