//
//  EmotionService.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 17/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

class EmotionService {
    
    // MARK: Constants
    let URL: String = "http://35.204.73.177:5000/v1/detect"
    
    // MARK: Properties
    static let shared = EmotionService()
    
    // MARK: Constructor
    private init() {}
    
    // MARK: Methods
    func emotion(of image: UIImage, completion: @escaping (String?)->Void) {
        
        // Convert image to base64 String
        guard let imageAsString = image.toBase64() else {
            completion(nil)
            return
        }
        
        Network.request(method: .post,url: URL ,parameters: ["base64_image": imageAsString],
        onSuccess: { (emojiID: String) in
            completion(emojiID)
        },
        onError: { (error: Error) in
            completion(nil)
            print(error.localizedDescription)
        })
    }
}
