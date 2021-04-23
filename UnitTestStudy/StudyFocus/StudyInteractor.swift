//
//  StudyInteractor.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation

protocol StudyInteracting: AnyObject {
    func fetch(text: String?)
    func open(flag: Bool)
}

final class StudyInteractor {
    private let presenter: StudyPresenting
    private let service: StudyServicing
    
    var featureFlag: Bool = false
    
    init(presenter: StudyPresenting, service: StudyServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension StudyInteractor: StudyInteracting {
    func fetch(text: String?) {
        if let unwrappedText = text {
            let endpoint = StudyEndpoint.fetch(text: unwrappedText)
            service.fetch(endpoint: endpoint) { [weak self] result in
                switch result {
                case .success(let studyModel):
                    if self?.featureFlag ?? false {
                        self?.presenter.present(study: studyModel)
                    }
                case .failure:
                    break
                }
            }
        }
    }
    
    func open(flag: Bool) {
        if flag {
            presenter.nextStep(action: .open)
        } else {
            presenter.nextStep(action: .close)
        }
    }
}
