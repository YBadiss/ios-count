//
//  ValueChangeTable.swift
//  Count
//
//  Created by Yacine Badiss on 27/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//
import SQLite
import Foundation

class ValueChangeTable {
    private var db: Connection
    private var table: Table
    private var id: Expression<Int64>
    private var timestamp: Expression<Int64>
    private var counterId: Expression<Int64>
    private var oldValue: Expression<Int64>
    private var newValue: Expression<Int64>
    
    init(path: String) {
        db = try! Connection("\(path)/value_changes_db.sqlite3")
        table = Table("value_changes")
        id = Expression<Int64>("id")
        timestamp = Expression<Int64>("timestamp")
        counterId = Expression<Int64>("counter_id")
        oldValue = Expression<Int64>("old_value")
        newValue = Expression<Int64>("new_value")
        
        let _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(timestamp)
            t.column(counterId)
            t.column(oldValue)
            t.column(newValue)
        })
    }
    
    func insert(timestamp: Date, counterId: Int64, oldValue: Int64, newValue: Int64) -> Int64 {
        print("Inserting value change: timestamp=\(timestamp), counterId=\(counterId), oldValue=\(oldValue), newValue=\(newValue)")
        
        let insert = table.insert(self.timestamp <- Int64(timestamp.timeIntervalSince1970), self.counterId <- counterId, self.oldValue <- oldValue, self.newValue <- newValue)
        return try! db.run(insert)
    }
}
