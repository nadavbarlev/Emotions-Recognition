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

enum Emotions: Int {
    case neutral_face = 0
    case slightly_smiling_face
    case frowning_face
    case winking_face
    case kissing_face_with_closed_eyes
    case surprised_face
    case pouting_face
    case grinning_face
    case winking_face_with_stuck_out_tongue
    case face_with_open_mouth_and_cold_sweat
    case nauseated_face
    
    var toEmojie: String {
        switch self {
        case .neutral_face: return "😐"
        case .slightly_smiling_face: return "🙂"
        case .frowning_face: return "☹️"
        case .winking_face: return "😉"
        case .kissing_face_with_closed_eyes: return "😚"
        case .surprised_face: return "😯"
        case .pouting_face: return "😡"
        case .grinning_face: return "😀"
        case .winking_face_with_stuck_out_tongue: return "😜"
        case .face_with_open_mouth_and_cold_sweat: return "😰"
        case .nauseated_face: return"🤢"
        }
    }
}

class ViewController: UIViewController {
    
    // MARK: Properties
    var scanTimer: Timer?
    var scannedFaceView = [UIView]()
    var scannedFaceImage = [UIImage]()
    let configuration = ARWorldTrackingConfiguration()
    
    // MARK: Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var collectionViewFaces: UICollectionView!
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewFaces.dataSource = self
        collectionViewFaces.delegate   = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start scan for faces
        sceneView.session.run(configuration)
        scanTimer = Timer.scheduledTimer(timeInterval: 10,
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
        
        scannedFaceImage.removeAll()
        collectionViewFaces.reloadData()
        
        // Get current image captured
        guard let cvBufferCapturedImage = sceneView.session.currentFrame?.capturedImage else { return }
        
        // Buffer to ciImage
        let ciImage = CIImage.init(cvPixelBuffer: cvBufferCapturedImage)
        
        // Create requset and handler for faces detection
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request: VNRequest, error: Error?) in
            
            DispatchQueue.main.async {
                
                // Gets all faces appear in session
                guard let faces = request.results as? [VNFaceObservation] else { return }
                
                // Rotate image and transfer to cgImage
                guard let cgImage = ciImage.rotate.toCGImage() else { return }
                
                self.scannedFaceView = faces.map { [weak self] (face: VNFaceObservation) in
                    
                    // Mark face with border
                    guard let faceView = self?.mark(face) else { return UIView() }
                    self?.sceneView.addSubview(faceView)
                    
                    // Crop face from images
                    guard let faceCGImage = self?.crop(face, from: cgImage) else { return UIView() }
                
                    // Add iamgeView to collection
                    let imageCropped = UIImage(cgImage: faceCGImage)
                    self?.scannedFaceImage.append(imageCropped)
                    self?.collectionViewFaces.reloadData()
                    
                    // Get recognition
                    EmotionService.shared.emotion(of: imageCropped) { (emojiID: String?) in
                        guard let emojiAsString = emojiID else { print("Server Error"); return }
                        guard let emojiAsInt = Int(emojiAsString), let emoji = Emotions(rawValue: emojiAsInt)
                            else { print("Invalid returned value"); return }
                        print(emoji.toEmojie)
                    }
                    
                    return faceView
                }
            }
        }
        
        // Run face detection
        try? VNImageRequestHandler(ciImage: ciImage, orientation: UIDeviceOrientation.cameraOrientation).perform([detectFaceRequest])
    }
    
    private func mark(_ face: VNFaceObservation) -> UIView {
        let faceRect = face.normalize(imageHeight: self.sceneView.bounds.height,
                                      imageWidth: self.sceneView.bounds.width)
        let faceView = UIView(frame: faceRect)
        faceView.layer.borderColor = UIColor.black.cgColor
        faceView.layer.borderWidth = 3
        return faceView
    }
    
    private func crop(_ face: VNFaceObservation, from cgImage: CGImage) -> CGImage? {
        let width = face.boundingBox.width * CGFloat(cgImage.width)
        let height = face.boundingBox.height * CGFloat(cgImage.height)
        let x = face.boundingBox.origin.x * CGFloat(cgImage.width)
        let y = (1 - face.boundingBox.origin.y) * CGFloat(cgImage.height) - height
        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        let faceCGImage = cgImage.cropping(to: croppingRect)
        return faceCGImage
    }
}

// MARK: Extension for CollectionView DataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* Collection View Data Source */
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scannedFaceImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewFaces.dequeueReusableCell(withReuseIdentifier: "FaceCollectionViewCell",for: indexPath)
                                as? FaceCollectionViewCell else { return UICollectionViewCell() }
        cell.face = scannedFaceImage[indexPath.row]
        return cell
    }
    
    /* Collection View Delegate Flow Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
