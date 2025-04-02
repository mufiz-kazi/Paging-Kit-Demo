//
//  ViewController.swift
//  Paging-Kit-Example
//
//  Created by Rahil WOS on 02/04/25.
//

import UIKit
import PagingKit

class ViewController: UIViewController {

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!

    // ✅ Properly Initialize ViewControllers for Different Segments
    var dataSource: [(menuTitle: String, vc: UIViewController)] = [
        (menuTitle: "ACTIVE", vc: DummyVC()),
        (menuTitle: "NEW", vc: DummyVC2())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✅ Register menu cell and focus view
        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))

        // ✅ Apply Corner Radius & Border to Focus View
        menuViewController.focusView.layer.cornerRadius = 20
        menuViewController.focusView.layer.borderWidth = 3
        menuViewController.focusView.layer.borderColor = UIColor.orange.cgColor
        menuViewController.focusView.clipsToBounds = true

        // ✅ Sync Scrolling
        menuViewController.delegate = self
        contentViewController.delegate = self
        contentViewController.scrollView.delegate = self
        contentViewController.scrollView.isScrollEnabled = true

        // ✅ Reload Data
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
        }
    }
}

// MARK: - PagingMenuViewControllerDataSource
extension ViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return view.frame.width / 2  // Each menu item takes 50% of the screen width
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        cell.titleLabel.text = dataSource[index].menuTitle
        return cell
    }
}

// MARK: - PagingContentViewControllerDataSource
extension ViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
}

// MARK: - PagingContentViewControllerDelegate
extension ViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didScrollTo index: Int) {
        print("✅ Content Scrolled to index: \(index)")  // Debugging step
        menuViewController.scroll(index: index, animated: true)  // Sync menu with content scroll
    }
}

// MARK: - PagingMenuViewControllerDelegate
extension ViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect index: Int, previousPage previousIndex: Int) {
        print("📌 Menu Selected: \(index)")  // Debugging step
        contentViewController.scroll(to: index, animated: true)  // Sync Content when menu is tapped
    }
}

// MARK: - UIScrollViewDelegate (Smooth Scroll Sync)
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        menuViewController.scroll(index: index, animated: true) // ✅ Smooth sync without delay
    }
}

/*
 another code
 // MARK: - UIScrollViewDelegate (Real-time Sync)
 extension ViewController: UIScrollViewDelegate {
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
         menuViewController.scroll(index: index, animated: false) // ✅ Smooth sync without delay
     }
 }

 */
