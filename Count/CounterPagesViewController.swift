//
//  CounterPagesViewController.swift
//  Count
//
//  Created by Yacine Badiss on 06/01/2019.
//  Copyright © 2019 Yacine Badiss. All rights reserved.
//

import UIKit

class CounterPagesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CounterViewDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        while let _ = loadCounterViewController(id: pages.count) {}
        if (pages.isEmpty) {
            addCounter()
        } else  {
            setViewControllers([pages.first!],
                               direction: UIPageViewController.NavigationDirection.forward,
                               animated: false,
                               completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
//         if you prefer to NOT scroll circularly, simply add here:
         if cur == 0 { return nil }
        
        let prev = abs((cur - 1) % pages.count)
        return pages[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
         if cur == (pages.count - 1) { return nil }
        
        let next = abs((cur + 1) % pages.count)
        return pages[next]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
    
    func addCounter() {
        let id = pages.count
        let counter = Counter(name: dataKey(id))
        let v = appendCounterPage(id, counter: counter)
        setViewControllers([v], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        v.edit()
    }
    
    func removeCounter(_ counterView: UIViewController) {
        if let idx = pages.firstIndex(of: counterView) {
            deleteCounter(idx)
            pages.remove(at: idx)
            setViewControllers([pages[min(idx, pages.count - 1)]], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    private func dataKey(_ id: Int) -> String {
        return "Counter \(id + 1)"
    }
    
    private func loadCounterViewController(id: Int) -> CounterViewController? {
        if let counter = loadCounter(id) {
            return appendCounterPage(id, counter: counter)
        }
        return nil
    }
    
    private func appendCounterPage(_ id: Int, counter: Counter) -> CounterViewController {
        let v: CounterViewController = storyboard!.instantiateViewController(withIdentifier: "CounterViewController") as! CounterViewController
        v.counter = counter
        v.id = id
        v.counterDelegate = self
        saveCounter(id, counter: counter)
        pages.insert(v, at: id)
        return v
    }
    
    func saveCounter(_ id: Int, counter: Counter) {
        let userDefaults = UserDefaults.standard
        print("Saving for id \(id)")
        userDefaults.set(counter.encode(), forKey: dataKey(id))
    }
    
    private func loadCounter(_ id: Int) -> Counter? {
        print("Loading for id \(id)...")
        let userDefaults = UserDefaults.standard
        if let counterData = userDefaults.data(forKey: dataKey(id)) {
            print("Loaded id \(id)!")
            return Counter.decode(counterData)
        }
        print("id \(id) not found")
        return nil
    }
    
    private func deleteCounter(_ id: Int) {
        // TODO this may hide some counters on reload of the app
        // I should store this in an sqlite and just select everything to display
        // Also we need sqlite to store the event times (one event = hour + day + total change)
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: dataKey(id))
    }
}

