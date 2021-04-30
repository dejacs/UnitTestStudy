//
//  ViewControllerSpy.swift
//  UnitTestStudyTests
//
//  Created by Jade Silveira on 30/04/21.
//

import Foundation
import UIKit

final class ViewControllerSpy: UIViewController {
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
