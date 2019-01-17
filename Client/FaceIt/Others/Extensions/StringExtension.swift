//
//  StringExtension.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 17/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

extension String {
    
    func image() -> UIImage? {
        
        let size = CGSize(width: 40, height: 40)
        
        // Begin of image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // Set context color to transparent
        UIColor.clear.set()
        
        // Draw the string as Image
        (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        
        // Get the context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // End of Image Context
        UIGraphicsEndImageContext()
        
        // Return String as Image
        return image
    }
}
