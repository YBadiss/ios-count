//
//  GraphViewController.swift
//  Count
//
//  Created by Yacine Badiss on 24/03/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

