//
//  StudyEndpoint.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//
import Alamofire
import Foundation

protocol EndpointProtocol {
    var path: String { get  }
    var method: HTTPMethod { get }
    var params: Parameters { get }
}

enum StudyEndpoint: EndpointProtocol {
    case fetch(text: String)
    
    var path: String {
        switch self {
        case .fetch:
            return "https://br1.api.riotgames.com/lol/platform/v3/champion-rotations"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var params: Parameters {
        switch self {
        case let .fetch(text):
            return [ "api_key" : "RGAPI-d3db86d7-ff5b-4088-ad4d-ebbae48d6a5b" ]
        }
    }
}
