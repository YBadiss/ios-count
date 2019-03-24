//
//  GraphViewController.swift
//  Count
//
//  Created by Yacine Badiss on 24/03/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var lineChartEntry = [ChartDataEntry]()
        for i in 0...10 {
            lineChartEntry.append(ChartDataEntry(x: Double(i), y: Double(i*i)))
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        line1.colors = [#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]
        
        let data = LineChartData()
        data.addDataSet(line1)
        chartView.data = data
        chartView.chartDescription?.text = "My awesome chart"
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

