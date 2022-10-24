//
//  Quize.swift
//  Quize (UIKit)
//
//  Created by Fedor Boretsky on 22.10.2022.
//

import Foundation

var quiz = Quiz()

struct Quiz {
    
    // MARK: - Content of the Quiz.
    
    let startTitle = "Какая у меня фигура, тренер?"
    
    var questions: [Question] = [
        Question(text: "TEST QUESTION (MULTIPLE CHOICE)?",
                 responseType: .multipleChoice,
                 answers: [
                    Answer(text: "11", votes: [.king]),
                    Answer(text: "22", votes: [.pawn]),
                    Answer(text: "33", votes: [.bishop]),
                    Answer(text: "44", votes: [.queen], isSelected: true),
                 ]),
        Question(text: "REPEAT TEST QUESTION (MULTIPLE CHOICE)?",
                 responseType: .multipleChoice,
                 answers: [
                    Answer(text: "11 11", votes: [.king], isSelected: true),
                    Answer(text: "22 22", votes: [.pawn]),
                    Answer(text: "33 33", votes: [.bishop]),
                    Answer(text: "44 44", votes: [.queen]),
                 ]),

        Question(text: "Много ли вы едите?",
                 responseType: .singleChoice,
                 answers: [
                    Answer(text: "Только чтобы выжить", votes: [.king]),
                    Answer(text: "Мало", votes: [.pawn]),
                    Answer(text: "Нормально", votes: [.bishop, .queen]),
                    Answer(text: "Постоянно", votes: [.queen]),
                 ]),
        Question(text: "Много ли вы двигаетесь?",
                 responseType: .segmentedChoice,
                 answers: [
                    Answer(text: "Мало", votes: [.king, .pawn]),
                    Answer(text: "Мало+", votes: [.pawn]),
                    Answer(text: "Много-", votes: [.bishop]),
                    Answer(text: "Много", votes: [.queen]),
                 ]),
        Question(text: "Из-за вашей фигуры вы не можете ходить:",
                 responseType: .multipleChoice,
                 answers: [
                    Answer(text: "Прямо", votes: [.bishop]),
                    Answer(text: "Назад", votes: [.pawn, .bishop]),
                    Answer(text: "Вбок", votes: [.bishop]),
                    Answer(text: "Далеко", votes: [.king, .pawn]),
                 ]),
        Question(text: "Из-за вашей фигуры другие люди:",
                 responseType: .multipleChoice,
                 answers: [
                    Answer(text: "Завидуют вам", votes: [.queen]),
                    Answer(text: "Избегают вас", votes: [.queen, .bishop]),
                    Answer(text: "Смеются над вами", votes: [.pawn]),
                    Answer(text: "Нападают на вас", votes: [.king, .queen]),
                 ]),
    ]
    

    var finishTitle: String {
        guard let result = calculatedResult
        else { return "У вас что-то непонятное" }
        
        return "У вас \(result.name)"
    }
    
    var finishDescription: String {
        guard let result = calculatedResult
        else { return "Ответьте хотя бы на один вопрос." }
        
        return result.description
    }
    
    

    // MARK: - Service
    
    private var calculatedResult: Piece? {
//        var candidates: [Piece: Int] = []
        
//        for question in questions {
//            for answer in question.answers {
//                if answer
//            }
//        }
        
        var candidates: [Piece: Int]
        candidates = questions.reduce([:]) { partialResult, question in
            question.answers.reduce(into: partialResult) { partialResult, answer in
                if answer.isSelected {
                    answer.votes.forEach { piece in
                        partialResult[piece, default: 0] += 1
                    }
                }
            }
        }
        
        let sortedCandidates = candidates.sorted { $0.value > $1.value }
        
        return sortedCandidates.first?.key
    }
    
    // MARK: - Intents.
    
    mutating func selectAnswer(questionIndex: Int, answerIndex: Int) {
        
        // Clear previous choice if only one answer is possible.
        switch questions[questionIndex].responseType {
        case .segmentedChoice, .singleChoice:
            deselectAnswersInQuestion(questionIndex: questionIndex)
        case .multipleChoice:
            break
        }
        
        // New selection.
        questions[questionIndex].answers[answerIndex].isSelected = true
    }
    
    mutating func deselectAnswersInQuestion(questionIndex: Int) {
        questions[questionIndex].answers.enumerated().forEach { (index, _) in
            questions[questionIndex].answers[index].isSelected = false
        }
    }
    

    
}
