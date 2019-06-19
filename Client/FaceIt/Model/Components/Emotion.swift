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
    static var neutral: UIImage {
        return UIImage(named: "emoji-neutral")!
    }
    
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
    
    /* Methods */
    static func image(from description: String) -> UIImage {
        switch description {
        case "Angry", "Anger", "angry", "anger":
            return UIImage(named: "emoji-angry")!
        /*
        case "Contempt":
            return UIImage(named: "emoji-contempt")!
        */
        case "Disgust", "disgust":
            return UIImage(named: "emojie-disgust")!
        case "Fear", "Scared", "fear", "scared":
            return UIImage(named: "emoji-fear")!
        case "Happy", "Happiness", "happy", "happiness":
            return UIImage(named: "emoji-grinning")!
        case "Sad", "Sadness", "sad", "sadness":
            return UIImage(named: "emoji-sandness")!
        case "Surprise", "surprise", "surprised":
            return UIImage(named: "emoji-surprise")!
        default: return neutral
        }
    }
    
    static func image(from number: Int) -> UIImage {
        switch number {
        case 0:
            return UIImage(named: "emoji-angry")!
        /*
         case 1:
            return UIImage(named: "emoji-contempt")!
        */
        case 1:
            return UIImage(named: "emojie-disgust")!
        case 2:
            return UIImage(named: "emoji-fear")!
        case 3:
            return UIImage(named: "emoji-grinning")!
        case 4:
            return UIImage(named: "emoji-sandness")!
        case 5:
            return UIImage(named: "emoji-surprise")!
        default: return neutral
        }
    }
}
