//
//  DbStore.swift
//  Count
//
//  Created by Yacine Badiss on 08/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//
import SQLite
import Foundation

class DbStore: StoreDelegate {
    private var db: Connection
    private var counters: Table
    private var id: Expression<Int64>
    private var name: Expression<String>
    private var value: Expression<Int>
    private var objective: Expression<Int>
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        db = try! Connection("\(path)/counter_db.sqlite3")
        counters = Table("counters")
        id = Expression<Int64>("id")
        name = Expression<String>("name")
        value = Expression<Int>("value")
        objective = Expression<Int>("objective")
        
        let _ = try? db.run(counters.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(value)
            t.column(objective)
        })
    }
    
    func getCounters() -> [Counter] {
        return try! db.prepare(counters).map {
            Counter(id: $0[id], name: $0[name], value: $0[value], objective: $0[objective])
        }
    }
    
    func createCounter() -> Counter {
        let insert = counters.insert(name <- name, value <- 0, objective <- 0)
        let rowid = try! db.run(insert)
        let counter = Counter(id: rowid)
        updateCounter(counter)
        
        print("Created new counter \(counter)")
        return counter
    }
    
    func updateCounter(_ counter: Counter) {
        print("Updating counter with \(counter)")
        let counterRow = counters.filter(id == counter.id)
        try! db.run(counterRow.update(name <- counter.name, value <- counter.value, objective <- counter.objective))
    }
    
    func deleteCounter(_ counter: Counter) {
        // Also we need sqlite to store the event times (one event = hour + day + total change)
        print("Deleting counter \(counter)")
        let counterRow = counters.filter(id == counter.id)
        try! db.run(counterRow.delete())
    }
}

