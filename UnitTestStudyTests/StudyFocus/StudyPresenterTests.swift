//
//  StudyPresenterTests.swift
//  UnitTestStudyTests
//
//  Created by Jade Silveira on 16/04/21.
//

@testable import UnitTestStudy
import XCTest

enum StudyMock {
    static let `default` = StudyModel(
        name: "Lindinha",
        birthDate: "01/04/2002",
        profileImage: "http.."
    )
}

private final class StudyViewControllerSpy: StudyDisplaying {
    private(set) var displayNameCount = 0
    private(set) var displayNameInvocation: [String] = []
    private(set) var displayBirthDateCount = 0
    private(set) var displayBirthDateInvocation: [String] = []
    private(set) var displayImageCount = 0
    private(set) var displayImageInvocation: [String] = []
    private(set) var displayErrorCount = 0
    
    func display(name: String) {
        displayNameCount += 1
        displayNameInvocation.append(name)
    }
    
    func display(birthDate: String) {
        displayBirthDateCount += 1
        displayBirthDateInvocation.append(birthDate)
    }
    
    func display(image: String) {
        displayImageCount += 1
        displayImageInvocation.append(image)
    }
    
    func displayError() {
        displayErrorCount += 1
    }
}

private final class StudyCoordinatorSpy: StudyCoordinating {
    var viewController: UIViewController?
    
    private(set) var performActionCount = 0
    private(set) var performActionInvocations: [StudyAction] = []
    
    func perform(action: StudyAction) {
        performActionCount += 1
        performActionInvocations.append(action)
    }
}

final class StudyPresenterTests: XCTestCase {
    private let viewController = StudyViewControllerSpy()
    private let coordinator = StudyCoordinatorSpy()
    
    lazy var sut: StudyPresenting = {
        let presenter = StudyPresenter(coordinator: coordinator)
        presenter.viewController = viewController
        return presenter
    }()
    
    func testPresent_ShouldDisplayStudyScreen() {
        sut.present(study: StudyMock.default)
        
        XCTAssertEqual(viewController.displayNameCount, 1)
        XCTAssertEqual(viewController.displayNameInvocation.first, StudyMock.default.name)
        XCTAssertEqual(viewController.displayBirthDateCount, 1)
        XCTAssertEqual(viewController.displayBirthDateInvocation.first, StudyMock.default.birthDate)
        XCTAssertEqual(viewController.displayImageCount, 1)
        XCTAssertEqual(viewController.displayImageInvocation.first, StudyMock.default.profileImage)
    }
    
    func testNextStep_ShouldPerformAction() {
        let action: StudyAction = .open(featureFlag: true)
        sut.nextStep(action: action)
        
        XCTAssertEqual(coordinator.performActionCount, 1)
        XCTAssertEqual(coordinator.performActionInvocations.first, action)
    }
    
    func testPresentError_ShouldDisplayErrorScreen() {
        sut.presentError()
        
        XCTAssertEqual(viewController.displayErrorCount, 1)
    }
}
