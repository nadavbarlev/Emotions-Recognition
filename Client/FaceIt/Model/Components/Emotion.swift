//
//  Emojie.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 15/04/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit


enum Emotion: Int {
    
    case angry_face = 0
    case contempt_face
    case disgust_face
    case fear_face
    case happiness_face
    case sadness_face
    case surprise_face
    
    /* Computed Properties */
    var toImage: UIImage {
        switch self {
        case .angry_face: return UIImage(named: "emoji-angry")!
        case .contempt_face: return UIImage(named: "emoji-contempt")!
        case .disgust_face: return UIImage(named: "emojie-disgust")!
        case .fear_face: return UIImage(named: "emoji-fear")!
        case .happiness_face: return UIImage(named: "emoji-grinning")!
        case .sadness_face: return UIImage(named: "emoji-sandness")!
        case .surprise_face: return UIImage(named: "emoji-surprise")!
        }
    }
    
    static var neutral: UIImage {
        return UIImage(named: "emoji-neutral")!
    }
    
    /* Methods */
    static func image(from description: String) -> UIImage {
        switch description {
        case "Anger", "Angry":
            return UIImage(named: "emoji-angry")!
        /*
        case "Contempt":
            return UIImage(named: "emoji-contempt")!
        */
        case "Disgust":
            return UIImage(named: "emojie-disgust")!
        case "Fear":
            return UIImage(named: "emoji-fear")!
        case "Happiness", "Happy":
            return UIImage(named: "emoji-grinning")!
        case "Sadness", "Sad":
            return UIImage(named: "emoji-sandness")!
        case "Surprise":
            return UIImage(named: "emoji-surprise")!
        default: return neutral
        }
    }
}
