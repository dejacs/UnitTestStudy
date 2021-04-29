@testable import Interview
import XCTest


private final class RequestManagerMock: Requestable {
    var expectedResult: Result<Data?, APIError>?
    
    func request<D>(with endpoint: Endpoint, completion: @escaping (Result<D, APIError>) -> Void) where D : Decodable {
        guard let expectedResult = expectedResult else {
            XCTFail("ExpectedResult must have a value")
            return
        }
        
        do {
            switch expectedResult {
            case .success(let data):
                guard let jsonData = data else {
                    return completion(.failure(.internalServer))
                }
                
                let decoded = try JSONDecoder().decode(D.self, from: jsonData)
                completion(.success(decoded))
                
            case .failure(let error):
                completion(.failure(error))
            }
        } catch {
            completion(.failure(.other(error: error)))
        }
    }
}

final class ListContactsServiceTests: XCTestCase {
    private let requestManagerMock = RequestManagerMock()
    private lazy var sut: ListContactsServicing = ListContactsService(requestManager: requestManagerMock)
    
    private var contactsMock: Data? = {
        """
            [
                {
                    "id": 1,
                    "name": "Shakira",
                    "photoURL": "https://api.adorable.io/avatars/285/a1.png"
                }
            ]
        """.data(using: .utf8)
    }()
    
    func testFetchContacts_WhenRequestReturnSuccess_ShouldReturnAtLeastOneContact() {
        let fetchContactsExpectation = expectation(description: "fetchContacts success")
        requestManagerMock.expectedResult = .success(contactsMock)
        
        sut.fetchContacts { result in
            fetchContactsExpectation.fulfill()
            guard case .success(let contacts) = result else {
                XCTFail("não deveria retornar um caso de falha")
                return
            }
            XCTAssertGreaterThan(contacts.count, 0)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchContacts_WhenRequestReturnFailureWithDataNil_ShouldReturnAtLeastOneContact() {
        let fetchContactsExpectation = expectation(description: "fetchContacts success with data nil")
        requestManagerMock.expectedResult = .success(nil)

        sut.fetchContacts { result in
            fetchContactsExpectation.fulfill()
            guard case .failure(let error) = result else {
                XCTFail("não deveria retornar um caso de falha")
                return
            }
            XCTAssertEqual(error, .internalServer)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchContacts_WhenRequestReturnFailureWithDataIsWrong_ShouldReturnAtLeastOneContact() {
        let fakeContacts: Data? = {
            """
                [
                    {
                        "id": "1",
                        "nameS": "Shakira",
                        "photoURLL": "https://api.adorable.io/avatars/285/a1.png"
                    }
                ]
            """.data(using: .utf8)
        }()
        
        let fetchContactsExpectation = expectation(description: "fetchContacts success with data nil")
        requestManagerMock.expectedResult = .success(fakeContacts)

        sut.fetchContacts { result in
            fetchContactsExpectation.fulfill()
            guard case .failure(let error) = result else {
                XCTFail("não deveria retornar um caso de falha")
                return
            }
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchContacts_WhenRequestReturnFailureWithMalformedUrl_ShouldReturnAtLeastOneContact() {
        let fetchContactsExpectation = expectation(description: "fetchContacts failure with malformedURL")
        requestManagerMock.expectedResult = .failure(.malformedUrl)

        sut.fetchContacts { result in
            fetchContactsExpectation.fulfill()
            guard case .failure(let error) = result else {
                XCTFail("não deveria retornar um caso de falha")
                return
            }
            XCTAssertEqual(error, .malformedUrl)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
