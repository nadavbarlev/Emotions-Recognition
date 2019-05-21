//
//  WalkthroughContentViewController.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 21/05/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    // MARK: Data Members
    private var shouldShowTitle: Bool = false {
        didSet { labelTitle.isHidden = !shouldShowTitle }
    }
    
    private var shouldShowButton: Bool = false {
        didSet { buttonStart.isHidden = !shouldShowButton }
    }
    
    // MARK: Properties
    public var emoji: UIImage?
    public var content: String?
    public var index: Int = 0
    
    // MARK: Outlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewEmoji: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonStart: UIButton!
    
    // MARK: Actions
    @IBAction func start(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isWalkthroughDisplayed")
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboardMain.instantiateInitialViewController() else { return }
        self.present(mainVC, animated: true, completion: nil)
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    // MARK: Private Methods
    private func setupComponents() {
        labelContent.text = content
        imageViewEmoji.image = emoji
        pageControl.currentPage = index
        shouldShowTitle = (index == 0)
        shouldShowButton = (index == 2)
    }
}
