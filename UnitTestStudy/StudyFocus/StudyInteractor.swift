//
//  StudyInteractor.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation

protocol StudyInteracting: AnyObject {
    func fetch(text: String?)
    func open()
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
        guard featureFlag else {
            presenter.presentError()
            return
        }
        
        if let unwrappedText = text {
            let endpoint = StudyEndpoint.fetch(text: unwrappedText)
            service.fetch(endpoint: endpoint) { [weak self] result in
                switch result {
                case .success(let studyModel):
                    self?.presenter.present(study: studyModel)
                    
                case .failure:
                    self?.presenter.presentError()
                }
            }
        }
    }
    
    func open() {
        if featureFlag {
            presenter.nextStep(action: .open(featureFlag: featureFlag))
        } else {
            presenter.nextStep(action: .close)
        }
    }
}
