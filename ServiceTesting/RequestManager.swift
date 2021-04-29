import Foundation

protocol Requestable {
    func request<D: Decodable>(with endpoint: Endpoint, completion: @escaping (Result<D, APIError>) -> Void)
}

struct RequestManager: Requestable {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<D>(with endpoint: Endpoint, completion: @escaping (Result<D, APIError>) -> Void) where D: Decodable {
        let request = createURLRequest(with: endpoint)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data else {
                return completion(.failure(.internalServer))
            }
            
            do {
                let contacts = try JSONDecoder().decode(D.self, from: jsonData)
                
                completion(.success(contacts))
            } catch {
                completion(.failure(.other(error: error)))
            }
        }
        
        task.resume()
    }
    
    private func createURLRequest(with endpoint: Endpoint) -> URLRequest {
        var url = endpoint.baseURL
        url.appendPathComponent(endpoint.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        return urlRequest
    }
}
