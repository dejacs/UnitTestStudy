//
//  StudyService.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Alamofire
import Foundation

enum StatusCode {
    static let success = 200
}

enum APIError: Error {
    case genericError
}

protocol StudyServicing: AnyObject {
    func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<StudyModel, APIError>) -> Void)
}

final class StudyService {
    
}

extension StudyService: StudyServicing {
    func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<StudyModel, APIError>) -> Void) {
        guard let url = URL(string: endpoint.path) else {
            return
        }
        AF.request(url, method: endpoint.method, parameters: endpoint.params).responseJSON { (result) in
            DispatchQueue.main.async {
                guard let data = result.data else {
                    completion(.failure(.genericError))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(StudyModel.self, from: data)
                    completion(.success(response))
                } catch { completion(.failure(.genericError)) }
            }
        }
    }
}
