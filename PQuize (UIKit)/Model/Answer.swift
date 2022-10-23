//
//  Answer.swift
//  Quiz (UIKit)
//
//  Created by Fedor Boretsky on 22.10.2022.
//

import Foundation

struct Answer {
    let text: String
    let votes: [Piece]
    var isSelected = false
}
