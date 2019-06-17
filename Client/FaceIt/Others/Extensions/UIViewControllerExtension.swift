//
//  UIViewControllerExtension.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 27/05/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIViewController {
    
    var toastStyle: ToastStyle {
        var style = ToastStyle()
        style.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
        style.messageColor = .white
        style.messageAlignment = .center
        return style
    }
    
    func showTopToast(onView view: UIView, withMessage message: String) {
        let estimatedDuration = getDurationBy(messageLength: message.count)
        let duration = estimatedDuration > 1.0 ? estimatedDuration : 1.0
        view.makeToast(message, duration: duration, position: .top, style: toastStyle)
    }
    
    func showBottomToast(onView view: UIView, withMessage message: String) {
        let estimatedDuration = getDurationBy(messageLength: message.count)
        let duration = estimatedDuration > 1.0 ? estimatedDuration : 1.0
        view.makeToast(message, duration: duration, position: .bottom, style: toastStyle)
    }
    
    func showCenterToast(onView view: UIView, withMessage message: String) {
        let estimatedDuration = getDurationBy(messageLength: message.count)
        let duration = estimatedDuration > 1.0 ? estimatedDuration : 1.0
        view.makeToast(message, duration: duration, position: .center, style: toastStyle)
    }
    
    func getDurationBy(messageLength length: Int) -> Double {
        return Double(length) * 0.04
    }
}
