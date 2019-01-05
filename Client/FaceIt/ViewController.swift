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
    
    // MARK: Computed Properties
    var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }
    
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
        scanTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true)
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
                for face in faces {
                    let faceRect  = self.faceFrame(from: face.boundingBox)
                    let faceView = UIView(frame: faceRect)
                    faceView.layer.borderColor = UIColor.black.cgColor
                    faceView.layer.borderWidth = 1
                    self.sceneView.addSubview(faceView)
                    self.scannedFaceView.append(faceView)
                }
            }
        }
        
        // Run face detection
        try? VNImageRequestHandler(ciImage: image, orientation: imageOrientation).perform([detectFaceRequest])
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        // Translate the size and coordinates of the boundingBox to the ones of the ARSCNView.
        let origin = CGPoint(x: boundingBox.minX * sceneView.bounds.width, y: (1 - boundingBox.maxY) * sceneView.bounds.height)
        let size = CGSize(width: boundingBox.width * sceneView.bounds.width, height: boundingBox.height * sceneView.bounds.height)
        return CGRect(origin: origin, size: size)
    }
}

