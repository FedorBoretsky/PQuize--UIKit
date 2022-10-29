//
//  PrintQuiz.swift
//  PQuize (UIKit)
//
//  Created by Fedor Boretsky on 29.10.2022.
//

import Foundation

func printQuiz(_ quiz: Quiz) {
    // TODO: - Delete PRINT
    print("\n\n\n===== QUIZE STATE ======\n")
    for question in quiz.questions {
        print(question.text)
        for answer in question.answers {
            if answer.isSelected {
                let votes = answer.votes.map { $0.name }.joined(separator: ", ")
                print("    \(answer.text) (\(answer.isSelected ? votes : ""))")
            }
        }
    }
    print("\nResult: \(quiz.finishTitle)")
    print("\nResult: \(quiz.finishDescription)")

}
