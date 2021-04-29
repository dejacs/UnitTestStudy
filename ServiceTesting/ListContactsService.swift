import Foundation

/*
 Json Contract
[
  {
    "id": 1,
    "name": "Shakira",
    "photoURL": "https://api.adorable.io/avatars/285/a1.png"
  }
]
*/

protocol ListContactsServicing {
    func fetchContacts(completion: @escaping (Result<[Contact], APIError>) -> Void)
}

struct ListContactsService: ListContactsServicing {
    private let requestManager: Requestable
    
    init(requestManager: Requestable = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func fetchContacts(completion: @escaping (Result<[Contact], APIError>) -> Void) {
        let endpoint: ListContactsEndpoint = .fetchContacts
        requestManager.request(with: endpoint) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
