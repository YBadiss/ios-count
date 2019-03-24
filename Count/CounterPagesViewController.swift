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
    var graphPage: GraphViewController?
    var store: StoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        store = DbStore()
        
        for counter in store!.getCounters() {
            let _ = appendCounterPage(counter)
        }

        if (pages.isEmpty) {
            addCounter()
        } else  {
            setViewControllers([pages.first!],
                               direction: UIPageViewController.NavigationDirection.forward,
                               animated: false,
                               completion: nil)
        }
        
        graphPage = storyboard!.instantiateViewController(withIdentifier: "GraphViewController") as? GraphViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
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
        let v = appendCounterPage()
        setViewControllers([v], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        v.edit()
    }
    
    func removeCounter(_ counterView: CounterViewController) {
        if let idx = pages.firstIndex(of: counterView) {
            store!.deleteCounter(counterView.counter!)
            pages.remove(at: idx)
            setViewControllers([pages[min(idx, pages.count - 1)]], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    private func appendCounterPage(_ counter: Counter? = nil) -> CounterViewController {
        let v: CounterViewController = storyboard!.instantiateViewController(withIdentifier: "CounterViewController") as! CounterViewController
        v.counter = counter ?? store!.createCounter()
        v.counterDelegate = self
        pages.append(v)
        return v
    }
    
    func saveCounter(_ counter: Counter) {
        store!.updateCounter(counter, isNew: false)
    }
    
    func showGraph(_ counter: Counter) {
        graphPage!.counter = counter
        graphPage!.values = store!.getCounterValues(counter)
        self.present(graphPage!, animated: true, completion: nil)
    }
}

