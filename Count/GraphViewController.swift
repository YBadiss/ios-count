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
    @IBOutlet weak var precisionSelector: UISegmentedControl!
    @IBOutlet weak var dateTargetLabel: UILabel!
    
    var counter: Counter?
    var values = [CounterValue]()
    
    private var maximum: Double {
        get { return Double(counter!.objective) }
    }
    private var precisionToCalendar: [String: Calendar.Component] = [
    "Day": .day,
    "Week": .weekOfYear,
    "Month": .month
    ]
    private var calendarPrecision: Calendar.Component {
        get {
            let precision = precisionSelector.titleForSegment(at: precisionSelector.selectedSegmentIndex)!
            return precisionToCalendar[precision]!
        }
    }
    
    override func viewDidLoad() {
        dateTargetLabel.text = counter!.dateTargetStr
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        chartView!.animate(xAxisDuration: 0.75, yAxisDuration: 0.75)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        render()
    }
    
    @IBAction func precisionChanged(_ sender: Any) {
        render()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    private func render() {
        chartView.data = getChartData()
        
        chartView.leftAxis.axisMaximum = maximum * 1.05
        let maxLine = ChartLimitLine.init(limit: maximum, label: "Target")
        maxLine.lineColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        chartView.leftAxis.removeAllLimitLines()
        chartView.leftAxis.addLimitLine(maxLine)
    }
    
    private func getChartData() -> LineChartData {
        let data = LineChartData()
        let cal = Calendar.current
        var lineChartEntry = [ChartDataEntry]()
        
        var groupedValues = Dictionary(grouping: values, by: { cal.ordinality(of: calendarPrecision, in: .year, for: $0.timestamp)! })
        let todayKey = cal.ordinality(of: calendarPrecision, in: .year, for: Date())!
        if let _ = groupedValues[todayKey] {}
        else {
            groupedValues[todayKey] = groupedValues[groupedValues.keys.max()!]
        }
        for (x, values) in groupedValues {
            let last = values.max { a, b in a.timestamp < b.timestamp }
            lineChartEntry.append(ChartDataEntry(x: Double(x), y: Double(last!.value)))
        }
        
        let dataLine = LineChartDataSet(entries: lineChartEntry.sorted { a, b in a.x < b.x }, label: counter!.name)
        dataLine.colors = [#colorLiteral(red: 0.3982805908, green: 0.8922122121, blue: 0.4089289308, alpha: 1)]
        dataLine.lineWidth = dataLine.lineWidth * 2
        dataLine.drawCircleHoleEnabled = false
        dataLine.circleRadius = dataLine.circleRadius * 0.5
        dataLine.circleColors = [#colorLiteral(red: 0, green: 0.7384181023, blue: 0, alpha: 1)]
        dataLine.valueFormatter = DefaultValueFormatter(decimals: 0)
        
        data.clearValues()
        data.addDataSet(dataLine)
        return data
    }
}

