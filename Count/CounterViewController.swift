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
    var id: Int?
    var saveDelegate: SaveCounterDelegate?
    
    @objc func changeValue(gesture : UISwipeGestureRecognizer) {
        counter!.value += gesture.direction == UISwipeGestureRecognizer.Direction.up ? 1 : -1
        update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeValue))
        upGesture.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(upGesture)
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeValue))
        downGesture.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(downGesture)
        
        render()
    }
    
    private func update() {
        saveDelegate!.saveCounter(id!, counter: counter!)
        render()
    }
    
    private func render() {
        counterName.text = counter!.name
        counterStatus.text = counter!.status
    }
}
