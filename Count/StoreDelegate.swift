//
//  StoreDelegate.swift
//  Count
//
//  Created by Yacine Badiss on 08/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import Foundation

protocol StoreDelegate {
    func getCounters() -> [Counter]
    func createCounter() -> Counter
    func updateCounter(_ counter: Counter)
    func deleteCounter(_ counter: Counter)
}
