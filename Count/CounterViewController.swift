//
//  CounterViewController.swift
//  Count
//
//  Created by Yacine Badiss on 06/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    @IBOutlet weak var counterName: UILabel!
    @IBOutlet weak var counterStatus: UILabel!
    
    var counter: Counter?
    
    @objc func changeValue(gesture : UISwipeGestureRecognizer) {
        counter!.value += gesture.direction == UISwipeGestureRecognizer.Direction.up ? 1 : -1
        update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.counter = loadCounter()
        
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.changeValue))
        upGesture.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(upGesture)
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.changeValue))
        downGesture.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(downGesture)
        
        render()
    }
    
    private func update() {
        saveCounter()
        render()
    }
    
    private func loadCounter() -> Counter? {
        let userDefaults = UserDefaults.standard
        if let counterData = userDefaults.data(forKey: "counter") {
            return Counter.decode(counterData)
        }
        return Counter(name: "Gym", value: 0, objective: 5)
    }
    
    private func saveCounter() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(counter!.encode(), forKey: "counter")
    }
    
    private func render() {
        counterName.text = counter!.name
        counterStatus.text = counter!.status
    }
}
