//
//  NetworkMethods.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 17/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkMethod {
    
    // MARK: Properties
    case get
    case post
    case put
    case delete
    
    // MARK: Methods
    func httpMethod() -> HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }
}
