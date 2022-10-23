//
//  Piece.swift
//  Quiz (UIKit)
//
//  Created by Fedor Boretsky on 22.10.2022.
//

import Foundation

enum Piece: String {
    case pawn = "Пешка"
    case king = "Король"
    case bishop = "Слон"
    case queen = "Ферзь"
    
    var name: String { self.rawValue }
    var description: String {
        switch self {
        case .pawn: return "Хотя фигура слабенькая, за 6 простых шагов можно стать королевой."
        case .king: return "Фигура малоподвижная, но влиятельная. Коллеги ее защищают."
        case .bishop: return "Несмотря на название, легко протискивается между другими."
        case .queen: return "Очень энергичная фигура. С ней вы всегда в гуще событий, как хороших так и плохих."
        }
    }
}

