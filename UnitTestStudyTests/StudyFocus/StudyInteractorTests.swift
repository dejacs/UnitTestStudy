//
//  StudyInteractorTests.swift
//  UnitTestStudyTests
//
//  Created by Jade Silveira on 16/04/21.
//
@testable import UnitTestStudy
import XCTest

private class StudyServiceMock: StudyServicing {
    // MARK: - Fetch
    private(set) var fetchEndpointCompletionCallsCount = 0
    private(set) var fetchEndpointCompletionReceivedInvocations: [(endpoint: EndpointProtocol, completion: (Result<StudyModel, APIError>) -> Void)] = []
    
    var fetchEndpointCompletionClosure: ((EndpointProtocol, @escaping(Result<StudyModel, APIError>) -> Void) -> Void)?
    
    func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<StudyModel, APIError>) -> Void) {
        fetchEndpointCompletionCallsCount += 1
        fetchEndpointCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        fetchEndpointCompletionClosure?(endpoint, completion)
    }
}

private class StudyPresenterSpy: StudyPresenting {
    var viewController: StudyDisplaying?
    
    var presentStudyCount = 0
    var presentStudyInvocations: [StudyModel] = []
    
    func present(study: StudyModel) {
        presentStudyCount += 1
        presentStudyInvocations.append(study)
    }
    
    func nextStep(action: StudyAction) {
        
    }
}

final class StudyInteractorTests: XCTestCase {
    private let presenter = StudyPresenterSpy()
    private let service = StudyServiceMock()
    
    lazy var sut = StudyInteractor(
        presenter: presenter,
        service: service
    )
    
    func testFetch_WhenTextNotNilAndFeatureFlagEnabled_ShouldPresentStudyWithSuccess() {
//        system under testing
        sut.featureFlag = true
        let texto = "Teste"
        
        service.fetchEndpointCompletionClosure = success
        sut.fetch(text: texto)
        
        XCTAssertEqual(presenter.presentStudyCount, 1)
        XCTAssertFalse(presenter.presentStudyInvocations.isEmpty)
        XCTAssertEqual(presenter.presentStudyInvocations.first, successResponse())
    }
}

private extension StudyInteractorTests {
    func successResponse() -> StudyModel? {
        let asset = NSDataAsset(name: "study-model", bundle: Bundle.main)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let response = try decoder.decode(StudyModel.self, from: asset!.data)
            return response
        } catch { return nil }
    }
    
    func success(endpoint: EndpointProtocol, completion: @escaping(Result<StudyModel, APIError>) -> Void) {
        guard let studyModel = successResponse() else {
            completion(.failure(.genericError))
            return
        }
        completion(.success(studyModel))
    }
    
    func failure(endpoint: EndpointProtocol, completion: @escaping(Result<StudyModel, APIError>) -> Void) {
        completion(.failure(APIError.genericError))
    }
}
