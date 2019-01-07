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
    @IBOutlet weak var valueChangeLabel: UILabel!
    @IBOutlet weak var fillUpGauge: UIView!
    
    var counter: Counter?
    var id: Int?
    var saveDelegate: SaveCounterDelegate?
    var editFields = [UITextField]()
    var gaugeHeightConstraint:NSLayoutConstraint?
    
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
        
        editFields.append(counterName)
        editFields.append(counterObjective)
        editFields.forEach { $0.delegate = self }
        
        valueChangeLabel.alpha = 0
        
        gaugeHeightConstraint = NSLayoutConstraint(item: fillUpGauge,
                                                   attribute: NSLayoutConstraint.Attribute.height,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: nil,
                                                   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 300)
        gaugeHeightConstraint!.isActive = true
        render()
    }
    
    func edit() {
        editFields.first?.becomeFirstResponder()
    }
    
    @objc func changeValue(gesture : UISwipeGestureRecognizer) {
        let isUp = gesture.direction == UISwipeGestureRecognizer.Direction.up
        if counter!.addToValue(isUp ? 1 : -1) {
            animateChangeLabel(isUp, fromPosition: gesture.location(in: view))
            update()
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.window?.firstResponder?.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let firstResponder = view.window?.firstResponder as? UITextField {
            firstResponder.resignFirstResponder()
            if let idx = editFields.firstIndex(of: firstResponder) {
                if idx < editFields.endIndex {
                    editFields[idx + 1].becomeFirstResponder()
                }
            }
        }
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
    
    private func animateChangeLabel(_ isUp: Bool, fromPosition: CGPoint) {
        valueChangeLabel.text = isUp ? "+1" : "-1"
        valueChangeLabel.alpha = 0.6
        valueChangeLabel.textColor = isUp ? .green : .red
        valueChangeLabel.center = fromPosition
        let newY: CGFloat = valueChangeLabel.center.y + 70 * (isUp ? -1 : 1)
        UIView.animate(withDuration: 0.7) {
            self.valueChangeLabel.center.y = newY
            self.valueChangeLabel.alpha = 0
        }
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
        
        let factor = CGFloat(counter!.value) / CGFloat(counter!.objective)
        fillUpGauge.removeConstraint(gaugeHeightConstraint!)
        gaugeHeightConstraint = NSLayoutConstraint(item: fillUpGauge,
                                                   attribute: NSLayoutConstraint.Attribute.height,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: nil,
                                                   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 300 * factor)
        gaugeHeightConstraint!.isActive = true
    }
}
