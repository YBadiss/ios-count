//
//  CounterTableViewController.swift
//  Count
//
//  Created by Yacine Badiss on 06/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

class CounterTableViewController: UITableViewController {
    // MARK: Instance Properties
    var counters = [Counter]()
    
    // MARK: Private Properties
    private let dataSource = ListViewDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        setUpCounters()
        render()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
    }
    
    // MARK: Private Functions
    private func render() {
        dataSource.list = counters.map { $0.description }
        tableView.reloadData()
    }
    
    private func setUpCounters () {
        counters.append(Counter(name: "Gym", value: 5, objective: 10))
        counters.append(Counter(name: "Books", value: 1, objective: 100))
        counters.append(Counter(name: "Songs", value: 8, objective: 8))
    }
}
