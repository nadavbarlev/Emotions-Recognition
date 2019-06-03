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
    var scannedFaceImage = [UIImage]()
    let configuration = ARWorldTrackingConfiguration()
    var emotionModel: VNCoreMLModel?
    var isScanActive: Bool = false
    
    // MARK: Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var collectionViewFaces: UICollectionView!
    @IBOutlet weak var consCollectionViewFacesHeight: NSLayoutConstraint!
    @IBOutlet weak var barItemToggleScan: UIBarButtonItem!
    @IBOutlet weak var titleRecognition: UITextView!
    
    @IBOutlet weak var tmuna: UIImageView!
    
    // MARK: Actions
    @objc func toggleScan() {
        if isScanActive {
            setupStopScan()
            self.showBottomToast(onView: self.view, withMessage: "Stop Scanning")
        } else {
            setupPlayScan()
            self.showBottomToast(onView: self.view, withMessage: "Start Scanning")
        }
        
        isScanActive = !isScanActive
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Face It"
        
        // Load Emotions Model
        emotionModel = try? VNCoreMLModel(for: EmotionsModel().model)
        
        // Set scan to NOT Active
        isScanActive = false
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(toggleScan))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        // Collection data source and delegate
        collectionViewFaces.dataSource = self
        collectionViewFaces.delegate   = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop scan for faces
        scanTimer?.invalidate()
        sceneView.session.pause()
    }

    // MARK: Methods
    private func setupPlayScan() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(toggleScan))
        navigationItem.rightBarButtonItem?.tintColor = .black
        scanTimer = Timer.scheduledTimer(timeInterval: 3,
                                         target: self,
                                         selector: #selector(scanForFaces),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    private func setupStopScan() {
        clearData()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(toggleScan))
        navigationItem.rightBarButtonItem?.tintColor = .black
        scanTimer?.invalidate()
    }
    
    @objc private func scanForFaces() {
        
        clearData()
        
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
                    
                    // Get emotion from SERVER
                    /* EmotionService.shared.emotion(of: imageCropped) { (emojiID: String?) in
                        guard let emojiAsString = emojiID else { print("Server Error"); return }
                        guard let emojiAsInt = Int(emojiAsString), let emoji = Emotion(rawValue: emojiAsInt)
                            else { print("Invalid returned value"); return }
                        print(emoji.toEmojie)
                    } */
                        
                    // Get emotion from LOCAL model
                    guard let emotionModel = self?.emotionModel else { return UIView() }
                    let detectEmotionRequest = VNCoreMLRequest(model: emotionModel) { (request: VNRequest, error: Error?) in
                        guard let faceEmotion = request.results?.first as? VNClassificationObservation else { return }
<<<<<<< HEAD
                        self?.titleRecognition.text? = String(faceEmotion.identifier)
=======
                        faceView.imgViewFace.image = UIImage(named: "emoji-winking")
                        print(faceEmotion.identifier)
>>>>>>> Add emoji to face
                    }
                    try? VNImageRequestHandler(cgImage: faceCGImage, orientation: UIDeviceOrientation.cameraOrientation)
                        .perform([detectEmotionRequest])

                    return faceView
                }
            }
        }
        
        // Run face detection
        try? VNImageRequestHandler(ciImage: ciImage, orientation: UIDeviceOrientation.cameraOrientation)
            .perform([detectFaceRequest])
    }
    
    /* Clear previous faces from memory and from UI */
    private func clearData() {
        scannedFaceView.forEach { $0.removeFromSuperview() }
        scannedFaceView.removeAll()
        scannedFaceImage.removeAll()
        collectionViewFaces.reloadData()
    }
    
    private func mark(_ face: VNFaceObservation) -> MarkFaceView {
        let faceRect = face.normalize(imageHeight: self.sceneView.bounds.height,
                                      imageWidth: self.sceneView.bounds.width)
        let faceView: MarkFaceView = .fromNib()
        faceView.frame = faceRect
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
