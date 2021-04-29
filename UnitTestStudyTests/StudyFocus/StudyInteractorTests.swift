//
//  StudyInteractorTests.swift
//  UnitTestStudyTests
//
//  Created by Jade Silveira on 16/04/21.
//
@testable import UnitTestStudy
import XCTest

enum StudyModelMock {
    static let `default` = StudyModel(
        name: "Lindinha",
        birthDate: "01/04/2002",
        profileImage: "http.."
    )
}

private final class StudyServiceMock: StudyServicing {
    var fetchEndpointCompletion: Result<StudyModel, APIError>?
    
    func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<StudyModel, APIError>) -> Void) {
        guard let fetchEndpointCompletion = fetchEndpointCompletion else {
            XCTFail("fetchEndpointCompletion should not be nil")
            return
        }
        completion(fetchEndpointCompletion)
    }
}

private final class StudyPresenterSpy: StudyPresenting {
    var viewController: StudyDisplaying?
    
    private(set) var presentStudyCount = 0
    private(set) var presentStudyInvocations: [StudyModel] = []
    private(set) var presentErrorCount = 0
    private(set) var nextStepActionCount = 0
    private(set) var nextStepActionInvocations: [StudyAction] = []
    
    func present(study: StudyModel) {
        presentStudyCount += 1
        presentStudyInvocations.append(study)
    }
    
    func presentError() {
        presentErrorCount += 1
    }
    
    func nextStep(action: StudyAction) {
        nextStepActionCount += 1
        nextStepActionInvocations.append(action)
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
        let studyModel = StudyModelMock.default
        sut.featureFlag = true
        let texto = "Teste"
        
        service.fetchEndpointCompletion = .success(studyModel)
        sut.fetch(text: texto)
        
        XCTAssertEqual(presenter.presentStudyCount, 1)
        XCTAssertFalse(presenter.presentStudyInvocations.isEmpty)
        XCTAssertEqual(presenter.presentStudyInvocations.first, studyModel)
    }
    
    func testFetch_WhenTextNotNilAndFeatureFlagDisabled_ShouldPresentError() {
//        system under testing
        let studyModel = StudyModelMock.default
        sut.featureFlag = false
        let texto = "Teste"
        
        service.fetchEndpointCompletion = .success(studyModel)
        sut.fetch(text: texto)
        
        XCTAssertEqual(presenter.presentErrorCount, 1)
    }
    
    func testFetch_WhenTextNotNilAndFeatureFlagEnabled_ShouldPresentStudyWithError() {
//        system under testing
        sut.featureFlag = true
        let texto = "Teste"
        
        service.fetchEndpointCompletion = .failure(.genericError)
        sut.fetch(text: texto)
        
        XCTAssertEqual(presenter.presentErrorCount, 1)
    }
    
    func testOpen_WhenFlagIsTrue_ShouldPresentNextStepWithOpenAction() {
        sut.featureFlag = true
        sut.open()
        
        XCTAssertEqual(presenter.nextStepActionCount, 1)
        XCTAssertEqual(presenter.nextStepActionInvocations.first, .open(featureFlag: true))
    }
    
    func testOpen_WhenFlagIsFalse_ShouldPresentNextStepWithCloseAction() {
        sut.featureFlag = false
        sut.open()
        
        XCTAssertEqual(presenter.nextStepActionCount, 1)
        XCTAssertEqual(presenter.nextStepActionInvocations.first, .close)
    }
}
