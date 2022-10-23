//
//  Question.swift
//  Quiz (UIKit)
//
//  Created by Fedor Boretsky on 22.10.2022.
//

import Foundation

struct Question {
    let text: String
    let responseType: ResponseType
    var answers: [Answer]
}

