//
//  AddPageViewController.swift
//  Count
//
//  Created by Yacine Badiss on 06/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

class AddPageViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    var addCounterDelegate: AddCounterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: #selector(addCounter), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func addCounter() {
        addCounterDelegate!.addCounter()
    }
}
