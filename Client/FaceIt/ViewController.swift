//
//  ViewController.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 30/12/2018.
//  Copyright © 2018 Nadav Bar Lev. All rights reserved.
//

import UIKit
import ARKit
import Vision

class ViewController: UIViewController {
    
    // MARK: Properties
    var scanTimer: Timer?
    var scannedFaceView = [UIView]()
    let configuration = ARWorldTrackingConfiguration()
    
    // MARK: Outlets
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: LifeCycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start scan for faces
        sceneView.session.run(configuration)
        scanTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                         target: self,
                                         selector: #selector(scanForFaces),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop scan for faces
        scanTimer?.invalidate()
        sceneView.session.pause()
    }

    // MARK: Methods
    @objc private func scanForFaces() {
        
        // Clear previous faces from memory and from UI
        _ = scannedFaceView.map { $0.removeFromSuperview() }
        scannedFaceView.removeAll()
      
        // Get current image captured
        guard let capturedImage = sceneView.session.currentFrame?.capturedImage else { return }
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        // Create requset and handler for faces detection
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request: VNRequest, error: Error?) in
            
            DispatchQueue.main.async {
                
                // Gets all faces appear in session
                guard let faces = request.results as? [VNFaceObservation] else { return }
                
                // Mark faces in black border
                self.scannedFaceView = faces.map { (face: VNFaceObservation) in
                    
                    // Mark them in blue border
                    let faceRect  = self.faceFrame(from: face.boundingBox)
                    let faceView = UIView(frame: faceRect)
                    faceView.layer.borderColor = UIColor.blue.cgColor
                    faceView.layer.borderWidth = 2
                    self.sceneView.addSubview(faceView)
                    
                    // Crop face from picure and get recognition
                    let faceCI = image.cropped(to: faceRect)
                    let faceUI = UIImage(ciImage: faceCI)
                    EmotionService.shared.emotion(of: faceUI) { (emojiID: String?) in
                        guard let emojiID = emojiID else { return }
                        print(emojiID)
                    }
                    
                    // Gets all face frames
                    return faceView
                }
            }
        }
        
        // Run face detection
        try? VNImageRequestHandler(ciImage: image, orientation: UIDeviceOrientation.cameraOrientation).perform([detectFaceRequest])
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        // Translate the size and coordinates of the boundingBox to the ones of the ARSCNView.
        let origin = CGPoint(x: boundingBox.minX * sceneView.bounds.width, y: (1 - boundingBox.maxY) * sceneView.bounds.height)
        let size = CGSize(width: boundingBox.width * sceneView.bounds.width, height: boundingBox.height * sceneView.bounds.height)
        return CGRect(origin: origin, size: size)
    }
}
