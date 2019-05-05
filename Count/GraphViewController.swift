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
        dateTargetLabel.text = counter!.endDateStr
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
    }
    
    private func getChartData() -> LineChartData {
        let firstDate = values.map({$0.timestamp}).min()!
        let firstKey = doubleFromDate(firstDate)
        let lastDate = values.map({$0.timestamp}).max()!
        let lastKey = doubleFromDate(lastDate)
        let todayDate = Date()
        let todayKey = doubleFromDate(todayDate)
        
        var groupedValues = Dictionary(grouping: values, by: { doubleFromDate($0.timestamp) })
        if let _ = groupedValues[todayKey] {}
        else {
            groupedValues[todayKey] = groupedValues[lastKey]
        }
        
        var dataEntries = [ChartDataEntry]()
        // TODO rewrite with map
        for (x, values) in groupedValues {
            let last = values.max { a, b in a.timestamp < b.timestamp }
            dataEntries.append(ChartDataEntry(x: x, y: Double(last!.value)))
        }
        
        let startDateInterval = counter!.startDate.timeIntervalSince1970
        let a = Double(counter!.objective) / (counter!.endDate.timeIntervalSince1970 - startDateInterval)
        let targetEntries = [
            ChartDataEntry(x: firstKey, y: a * (firstDate.timeIntervalSince1970 - startDateInterval)),
            ChartDataEntry(x: todayKey, y: a * (todayDate.timeIntervalSince1970 - startDateInterval))
        ]
        
        let data = LineChartData()
        data.clearValues()
        data.addDataSet(makeDataLine(entries: dataEntries.sorted { a, b in a.x < b.x }))
        data.addDataSet(makeTargetLine(entries: targetEntries))
        return data
    }
    
    private func makeDataLine(entries: [ChartDataEntry]) -> LineChartDataSet {
        let line = makeLine(descriptor: "Progress", entries: entries, color: #colorLiteral(red: 0, green: 0.7384181023, blue: 0, alpha: 1))
        line.lineWidth = line.lineWidth * 2
        return line
    }
    
    private func makeTargetLine(entries: [ChartDataEntry]) -> LineChartDataSet{
        let line = makeLine(descriptor: "Target", entries: entries, color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        line.circleRadius = line.circleRadius * 0.5
        return line
    }
    
    private func makeLine(descriptor: String, entries: [ChartDataEntry], color: UIColor) -> LineChartDataSet {
        let line = LineChartDataSet(entries: entries, label: "\(counter!.name) \(descriptor)")
        line.colors = [color]
        line.circleColors = [color]
        line.drawCircleHoleEnabled = false
        line.circleRadius = line.circleRadius * 0.5
        line.valueFormatter = DefaultValueFormatter(decimals: 0)
        return line
    }
    
    private func doubleFromDate(_ date: Date) -> Double {
        let cal = Calendar.current
        return Double(cal.ordinality(of: calendarPrecision, in: .year, for: date)!)
    }
}

