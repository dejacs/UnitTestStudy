//
//  StudyCoordinator.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation
import UIKit

enum StudyAction {
    case open, close
}

protocol StudyCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: StudyAction)
}

final class StudyCoordinator {
    weak var viewController: UIViewController?
}

extension StudyCoordinator: StudyCoordinating {
    func perform(action: StudyAction) {
        switch action {
        case .open:
            let featureFlag: String = "está habilitada"
            if featureFlag == "está habilitada" {
                viewController?.present(NewStudyViewController(), animated: true)
            } else {
                viewController?.dismiss(animated: true)
            }
        case .close:
            viewController?.dismiss(animated: true)
        }
    }
}
