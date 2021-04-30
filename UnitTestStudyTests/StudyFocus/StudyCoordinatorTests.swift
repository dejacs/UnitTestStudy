//
//  StudyCoordinatorTests.swift
//  UnitTestStudyTests
//
//  Created by Jade Silveira on 16/04/21.
//

@testable import UnitTestStudy
import XCTest

final class StudyCoordinatorTests: XCTestCase {
    private let viewController = ViewControllerSpy()
    
    lazy var sut: StudyCoordinating = {
        let coordinator = StudyCoordinator()
        coordinator.viewController = viewController
        return coordinator
    }()
    
    func testPerform_WhenActionOpenAndFeatureFlagIsEnabled_ShouldPresentNewStudyScreen() {
        sut.perform(action: .open(featureFlag: true))
        
        XCTAssertEqual(viewController.presentCount, 1)
        XCTAssertTrue(viewController.presentedViewControllerInvocations.first is NewStudyViewController)
    }
    
    func testPerform_WhenActionOpenAndFeatureFlagIsDisabled_ShouldDismissScreen() {
        sut.perform(action: .open(featureFlag: false))
        
        XCTAssertEqual(viewController.dismissCount, 1)
        XCTAssertTrue(viewController.dismissedViewControllerInvocations.first is ViewControllerSpy)
    }
    
    func testPerform_WhenActionClose_ShouldDismissScreen() {
        sut.perform(action: .close)

        XCTAssertEqual(viewController.dismissCount, 1)
        XCTAssertTrue(viewController.dismissedViewControllerInvocations.first is ViewControllerSpy)
    }
}
