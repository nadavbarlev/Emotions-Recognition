//
//  CIImageExtension.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 17/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

extension CIImage {
    
    var rotate: CIImage {
        return self.oriented(UIDeviceOrientation.cameraOrientation)
    }
    
    func toCGImage() -> CGImage? {
        guard let cgImage = CIContext(options: nil)
            .createCGImage(self, from: self.extent) else { return nil }
        return cgImage
    }
    
}
