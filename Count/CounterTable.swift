//
//  CounterTable.swift
//  Count
//
//  Created by Yacine Badiss on 27/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//
import SQLite
import Foundation

class CounterTable {
    private var db: Connection
    private var table: Table
    private var id: Expression<Int64>
    private var name: Expression<String>
    private var value: Expression<Int64>
    private var objective: Expression<Int64>
    
    init(path: String) {
        db = try! Connection("\(path)/counter_db.sqlite3")
        table = Table("counters")
        id = Expression<Int64>("id")
        name = Expression<String>("name")
        value = Expression<Int64>("value")
        objective = Expression<Int64>("objective")
        let _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(value)
            t.column(objective)
        })
    }
    
    func get(id: Int64) -> Counter? {
        for row in try! db.prepare(table.filter(self.id == id)) {
            return rowToCounter(row)
        }
        return nil
    }
    
    func getAll() -> [Counter] {
        return try! db.prepare(table).map { rowToCounter($0) }
    }
    
    func insert(name: String, value: Int64, objective: Int64) -> Int64 {
        print("Inserting counter: name=\(name), value=\(value), objective=\(objective)")
        let insert = table.insert(self.name <- name, self.value <- value, self.objective <- objective)
        return try! db.run(insert)
    }
    
    func update(id: Int64, name: String, value: Int64, objective: Int64) {
        print("Updating counter \(id): name=\(name), value=\(value), objective=\(objective)")
        try! db.run(table.filter(self.id == id).update(
            self.name <- name,
            self.value <- value,
            self.objective <- objective))
    }
    
    func delete(id: Int64) {
        print("Deleting counter for id \(id)")
        try! db.run(table.filter(self.id == id).delete())
    }
    
    private func rowToCounter(_ row: Row) -> Counter {
        return Counter(id: row[id], name: row[name], value: row[value], objective: row[objective])
    }
}
