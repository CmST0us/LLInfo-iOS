//
//  InformationPageViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class InformationPageViewController: UIPageViewController {
    
    var currentIndex = 0
    
    @IBAction func nextPage(_ sender: Any) {
        if currentIndex == self.pageViewControllers.count - 1 {
            
        } else {
            currentIndex += 1
            self.setViewControllers([self.pageViewControllers[currentIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
    @IBAction func lastPage(_ sender: Any) {
        if currentIndex == 0 {
            
        } else {
            currentIndex -= 1
            self.setViewControllers([self.pageViewControllers[currentIndex]], direction: .reverse, animated: true, completion: nil)
        }
    }
    private lazy var pageViewControllers: [UIViewController] = {
        return [
            InfoListTableViewController.storyboardInstance(),
            OfficialNewsListTableViewController.storyboardInstance()
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([self.pageViewControllers[0]], direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = UIColor.white
//        self.scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InformationPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == self.pageViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == pageViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}

extension InformationPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            let firstVC = pageViewController.viewControllers!.first!
            self.currentIndex = pageViewControllers.index(of: firstVC)!
        }
    }
}

extension InformationPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = pageViewControllers.index(of: viewController) {
            if viewControllerIndex - 1 <= 0 {
                return nil
            } else {
                return pageViewControllers[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = pageViewControllers.index(of: viewController) {
            if viewControllerIndex + 1 >= pageViewControllers.count {
                return nil
            } else {
                return pageViewControllers[viewControllerIndex + 1]
            }
        }
        return nil
    }
    
    
}
