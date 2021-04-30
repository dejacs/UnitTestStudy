//
//  StudyPresenter.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation

protocol StudyPresenting: AnyObject {
    var viewController: StudyDisplaying? { get set }
    func present(study: StudyModel)
    func presentError()
    func nextStep(action: StudyAction)
}

final class StudyPresenter {
    weak var viewController: StudyDisplaying?
    private let coordinator: StudyCoordinating
    
    init(coordinator: StudyCoordinating) {
        self.coordinator = coordinator
    }
}

extension StudyPresenter: StudyPresenting {
    func present(study: StudyModel) {
        viewController?.display(name: study.name)
        viewController?.display(birthDate: study.birthDate)
        viewController?.display(image: study.profileImage!)
    }
    
    func nextStep(action: StudyAction) {
        coordinator.perform(action: action)
    }
    
    func presentError() {
        viewController?.displayError()
    }
}
