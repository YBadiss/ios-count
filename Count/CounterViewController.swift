//
//  CounterViewController.swift
//  Count
//
//  Created by Yacine Badiss on 06/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var counterStatus: UILabel!
    @IBOutlet weak var counterName: UITextField!
    @IBOutlet weak var counterObjective: UITextField!
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        counterName.delegate = self
        counterObjective.delegate = self
        
        render()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        counterName.resignFirstResponder()
        counterObjective.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        counterName.resignFirstResponder()
        counterObjective.resignFirstResponder()
        return true
    }
    
    @IBAction func counterNameEditingEnded(_ sender: Any) {
        counter!.name = counterName.text!
        update()
    }
    @IBAction func counterObjectiveEditingEnded(_ sender: Any) {
        counter!.objective = Int(counterObjective.text ?? "") ?? -1
        update()
    }
    
    private func update() {
        saveDelegate!.saveCounter(id!, counter: counter!)
        render()
    }
    
    private func render() {
        counterName.text = counter!.name
        counterStatus.text = String(counter!.value)
        counterObjective.text = String(counter!.objective)
        if counter!.done {
            counterObjective.text?.append(" ✅")
        }
    }
}
