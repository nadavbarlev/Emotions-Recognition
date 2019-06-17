//
//  UIViewExtension.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 03/06/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
