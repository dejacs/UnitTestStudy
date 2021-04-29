//
//  StudyCoordinatorTests.swift
//  UnitTestStudyTests
//
//  Created by Jade Silveira on 16/04/21.
//

@testable import UnitTestStudy
import XCTest

private final class ViewControllerSpy: UIViewController {
    private(set) var presentCount = 0
    private(set) var presentedViewControllerInvocations: [UIViewController] = []
    private(set) var dismissCount = 0
    private(set) var dismissedViewControllerInvocations: [UIViewController] = []
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCount += 1
        presentedViewControllerInvocations.append(viewControllerToPresent)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCount += 1
        dismissedViewControllerInvocations.append(self)
    }
}

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
