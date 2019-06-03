//
//  Emojie.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 15/04/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import Foundation


enum Emotion: Int {
    
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
