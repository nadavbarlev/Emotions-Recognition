//
//  VNFaceObservationExtension.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 11/02/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import Vision


extension VNFaceObservation {
    
    /* Translate the size and coordinates of the boundingBox to ones of ARSCNView. */
    func normalize(imageHeight: CGFloat, imageWidth: CGFloat) -> CGRect {
        let origin = CGPoint(x: self.boundingBox.minX * imageWidth, y: (1 - boundingBox.maxY) * imageHeight)
        let size = CGSize(width: self.boundingBox.width * imageWidth, height: boundingBox.height * imageHeight)
        return CGRect(origin: origin, size: size)
    }
}
