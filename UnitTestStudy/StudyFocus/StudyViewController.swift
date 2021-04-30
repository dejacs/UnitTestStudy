//
//  StudyViewController.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation
import UIKit

protocol StudyDisplaying: AnyObject {
    func display(name: String)
    func display(birthDate: String)
    func display(image: String)
    func displayError()
}

final class StudyViewController: UIViewController {
    private let interactor: StudyInteracting
    
    init(interactor: StudyInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
}

extension StudyViewController: StudyDisplaying {
    func display(name: String) {
        
    }
    
    func display(birthDate: String) {
        
    }
    
    func display(image: String) {
        
    }
    
    func displayError() {
        
    }
}
