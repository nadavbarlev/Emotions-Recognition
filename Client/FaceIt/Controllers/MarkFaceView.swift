//
//  MarkFaceView.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 03/06/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

class MarkFaceView: UIView {
    
    // MARK: Outlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imgViewFace: UIImageView!
    
    // MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   }
    
    // MARK: Methods
    func setup() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
    }
}
