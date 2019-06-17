//
//  WalkthroughViewController.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 21/05/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // MARK: Properties
    var pagesContent = ["Face It is a simple way to capture and share the world’s moments.",
                       "Follow your friends and family to see what they’re up to, and discover accounts from all over the world that are sharing things you love.",
                       "Join the community of over 1 billion people and express yourself by sharing all the moments of your day — the highlights and everything in between, too."]
    
    var pagesImages = [UIImage(named: "emoji-winking"),
                       UIImage(named: "emoji-surprise"),
                       UIImage(named: "emoji-grinning")]
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        guard let pageContentVC = createViewController(for: 0) else { return }
        setViewControllers([pageContentVC], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    func createViewController(for index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index == pagesContent.count { return nil }
        let pageContnetVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController")
                                as! WalkthroughContentViewController
        pageContnetVC.index = index
        pageContnetVC.content = pagesContent[index]
        pageContnetVC.emoji = pagesImages[index]
        return pageContnetVC
    }
    
    // MARK: Implement - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let indexPage = (viewController as! WalkthroughContentViewController).index
        return createViewController(for: indexPage - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let indexPage = (viewController as! WalkthroughContentViewController).index
        return createViewController(for: indexPage + 1)
    }
    
}
