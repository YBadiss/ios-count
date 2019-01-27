//
//  CounterViewDelegate.swift
//  Count
//
//  Created by Yacine Badiss on 08/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

protocol CounterViewDelegate {
    func addCounter()
    func removeCounter(_ counterView: CounterViewController)
    func saveCounter(_ counter: Counter)
}
