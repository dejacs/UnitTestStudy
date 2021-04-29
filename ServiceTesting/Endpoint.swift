import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var absoluteURL: String { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    var baseURL: URL {
        guard let baseURL = URL(string: "https://run.mocky.io/v3/") else {
            fatalError("You need to define the base url")
        }
        
        return baseURL
    }
    
    var absoluteURL: String {
        "\(baseURL)\(path)"
    }
    
    var method: HTTPMethod {
        .get
    }
}
