//
//  DbStore.swift
//  Count
//
//  Created by Yacine Badiss on 08/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//
import Foundation

class DbStore: StoreDelegate {
    private var counters: CounterTable
    private var valueChanges: ValueChangeTable
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        counters = CounterTable(path: path)
        valueChanges = ValueChangeTable(path: path)
    }
    
    func getCounters() -> [Counter] {
        return counters.getAll()
    }
    
    func createCounter() -> Counter {
        let rowId = counters.insert(name: "", value: 0, objective: 0)
        let counter = Counter(id: rowId)
        updateCounter(counter, isNew: true)
        print("Created new counter \(counter)")
        return counter
    }
    
    func updateCounter(_ counter: Counter, isNew: Bool = false) {
        let oldCounter = counters.get(id: counter.id)!
        counters.update(id: counter.id, name: counter.name, value: counter.value, objective: counter.objective)
        
        if isNew || (counter.value != oldCounter.value) {
            let _ = valueChanges.insert(timestamp: Date(), counterId: counter.id, oldValue: oldCounter.value, newValue: counter.value)
        }
    }
    
    func getCounterValues(_ counter: Counter) -> [CounterValue] {
        return valueChanges.get(counterId: counter.id)
    }
    
    func deleteCounter(_ counter: Counter) {
        counters.delete(id: counter.id)
        valueChanges.delete(counterId: counter.id)
    }
}

