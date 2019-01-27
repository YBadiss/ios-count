//
//  DbStore.swift
//  Count
//
//  Created by Yacine Badiss on 08/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//
//import SQLite
import Foundation

class DbStore: StoreDelegate {
//    var db: Connection
//    
//    init() {
//        db = try Connection("counter_db.sqlite3")
//    }
    
    func getCounter(_ id: Int) -> Counter? {
        print("Get counter for id \(id)...")
        let userDefaults = UserDefaults.standard
        if let counterData = userDefaults.data(forKey: dataKey(id)) {
            print("Retrieved counter for id \(id)!")
            return Counter.decode(counterData)
        }
        print("Counter not found for id \(id)")
        return nil
    }
    
    func createCounter(_ id: Int, counter: Counter) -> Int {
        updateCounter(id, counter: counter)
        return id
    }
    
    func updateCounter(_ id: Int, counter: Counter) {
        let userDefaults = UserDefaults.standard
        print("Saving for id \(id)")
        userDefaults.set(counter.encode(), forKey: dataKey(id))
    }
    
    func deleteCounter(_ id: Int) {
        // TODO this may hide some counters on reload of the app
        // I should store this in an sqlite and just select everything to display
        // Also we need sqlite to store the event times (one event = hour + day + total change)
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: dataKey(id))
    }
    
    private func dataKey(_ id: Int) -> String {
        return "Counter \(id + 1)"
    }
}

