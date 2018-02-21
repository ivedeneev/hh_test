//
//  NetworkClient.swift
//  hh_test
//
//  Created by Igor Vedeneev on 13.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

protocol NetworkClient {
    func send(request: URLRequest, completion: @escaping NetworkResponseCompletion)
}

final class NetworkClientImpl: NetworkClient {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func send(request: URLRequest, completion: @escaping NetworkResponseCompletion) {
        self.session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
