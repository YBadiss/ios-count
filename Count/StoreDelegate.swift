//
//  StoreDelegate.swift
//  Count
//
//  Created by Yacine Badiss on 08/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import Foundation

protocol StoreDelegate {
    func getCounter(_ id: Int) -> Counter?
    func createCounter(_ id: Int, counter: Counter) -> Int
    func updateCounter(_ id: Int, counter: Counter)
    func deleteCounter(_ id: Int)
}
