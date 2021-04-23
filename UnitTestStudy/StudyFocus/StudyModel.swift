//
//  StudyModel.swift
//  UnitTestStudy
//
//  Created by Jade Silveira on 16/04/21.
//

import Foundation

struct StudyModel: Decodable, Equatable {
    let name: String
    let birthDate: String
    let profileImage: String?
}
