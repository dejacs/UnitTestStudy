//
//  StudyFactory.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation

enum StudyFactory {
    static func make() -> StudyViewController {
        let coordinator: StudyCoordinating = StudyCoordinator()
        let presenter: StudyPresenting = StudyPresenter(coordinator: coordinator)
        let service: StudyServicing = StudyService()
        let interactor = StudyInteractor(presenter: presenter, service: service)
        let viewController = StudyViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
