//
//  Network.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 17/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit
import Alamofire

// MARK: Network Protocol
protocol NetworkService {
    
    static func image(url: String,
                      onSuccess: @escaping ((UIImage)->Void),
                      onError: ((Error)->Void)?)
    
    static func request(method: NetworkMethod,
                        url: String,
                        parameters: [String : Any]?,
                        onSuccess: @escaping ((Data)->Void),
                        onError: ((Error)->Void)?)
    
    static func request(method: NetworkMethod,
                        url: String,
                        parameters: [String : Any]?,
                        onSuccess: ((String)->Void)?,
                        onError: ((Error)->Void)?)
    
    static func request<T: Decodable>(method: NetworkMethod,
                                      url: String,
                                      parameters: [String : Any]?,
                                      onSuccess: @escaping ((T)->Void),
                                      onError: ((Error)->Void)?)
}

final class Network: NetworkService {
    
 
    /* Request - Response Data */
    static func request(method: NetworkMethod,
                        url: String,
                        parameters: [String:Any]?,
                        onSuccess: @escaping ((Data)->Void),
                        onError: ((Error)->Void)?) {
        
        AF.request(url, method: method.httpMethod(), parameters: parameters)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    onSuccess(value)
                case .failure(let error):
                     onError?(error)
                }
        }
    }
    
    /* Request - Response String */
    static func request(method: NetworkMethod,
                        url: String,
                        parameters: [String:Any]?,
                        onSuccess: ((String)->Void)?,
                        onError: ((Error)->Void)?) {
        
        AF.request(url, method: method.httpMethod(), parameters: parameters)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let value):
                    onSuccess?(value)
                case .failure(let error):
                    onError?(error)
                }
        }
    }
    
    /* Request - Response Decodable */
    static func request<T: Decodable>(method: NetworkMethod,
                                      url: String,
                                      parameters: [String : Any]?,
                                      onSuccess: @escaping ((T)->Void),
                                      onError: ((Error)->Void)?) {

       request(method: method, url: url, parameters: parameters,onSuccess: { (data: Data) in
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodedObject)
            }
            catch { onError?(NetworkError.IncorrectDataReturned) }
        },
        onError: { (error: Error) in
            onError?(error)
        })
    }
    
    /* Request - Response image */
    static func image(url: String, onSuccess: @escaping ((UIImage)->Void), onError: ((Error)->Void)?) {
        AF.request(url, method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        onError?(NetworkError.IncorrectDataReturned)
                        return
                    }
                    onSuccess(image)
                case .failure(let error):
                    onError?(error)
                }
        }
    }
    
}

