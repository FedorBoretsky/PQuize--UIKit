//
//  QuestionsViewController.swift
//  Personality Quiz (UIKit)
//
//  Created by Fedor Boretskiy on 18.02.2022.
//

import UIKit

class QuestionsViewController: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var quizProgressBar: UIProgressView!
    
    @IBOutlet weak var questionWording: UILabel!
    
    @IBOutlet var choiceControls: [UIStackView]!
    
    @IBOutlet weak var singleChoiceForm: UIStackView!
    @IBOutlet var singleChoiceItems: [UIButton]!
    
    @IBOutlet weak var multipleChoiceForm: UIStackView!
    @IBOutlet var multipleChioceItems: [UIStackView]!
    
    @IBOutlet weak var rangeChoiceForm: UIStackView!
    @IBOutlet weak var rangeStartLabel: UILabel!
    @IBOutlet weak var rangeFinishLabel: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    
    @IBOutlet weak var segmentedChoiceForm: UIStackView!
    @IBOutlet weak var segmentedStartLabel: UILabel!
    @IBOutlet weak var segmentedFinishLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    // MARK: - State
    
    var quiz: Quiz!
    
    var currentQuestionIndex = 0 {
        didSet {
            if currentQuestionIndex < quiz.questions.count {
                updateUI()
            } else {
                performSegue(withIdentifier: "gotoResult", sender: nil)
            }
        }
    }
    
    var currentQuestion: Question {
        quiz.questions[currentQuestionIndex]
    }
    
    var currentAnswers: [Answer] {
        currentQuestion.answers
    }
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quiz = Quiz()
        updateUI()
    }
    
    // MARK: - Update
    
    func updateUI() {
        
        // Quiz progress bar
        let progressStep: Float = 1.0 / Float(quiz.questions.count)
        let currentProgress = Float(currentQuestionIndex) * progressStep + progressStep / 4
        quizProgressBar.setProgress(currentProgress, animated: true)
        
        // Number and the text of question.
        self.title = "Вопрос \(currentQuestionIndex + 1) из \(quiz.questions.count)"
        questionWording.text = currentQuestion.text
        
        // Response controls.
        choiceControls.forEach{ $0.isHidden = true }
        switch currentQuestion.responseType {
        case .singleChoice:
            showSingleChoice()
        case .multipleChoice:
            showMultipleChoice()
        case .segmentedChoice:
            showSegmentedChoice()
        }
    }
    
    func showSingleChoice() {
        
        // Show forms.
        singleChoiceForm.isHidden = false
        
        // Show answers.
        singleChoiceItems.forEach{ $0.isHidden = true }
        zip(singleChoiceItems, currentAnswers).forEach{
            (button, answer) in
            button.setTitle(answer.text, for: [])
            button.isSelected = answer.isSelected
            button.isHidden = false
        }
    }
    
    func showMultipleChoice() {
        
        // Show forms
        multipleChoiceForm.isHidden = false
        
        // Show answers.
        multipleChioceItems.forEach{ $0.isHidden = true }
        zip(multipleChioceItems, currentAnswers).forEach{
            (chioceItem, answer) in
            let label = chioceItem.arrangedSubviews.first as! UILabel
            let uiswitch = chioceItem.arrangedSubviews.last as! UISwitch
            label.text = answer.text
            uiswitch.isOn = answer.isSelected
            chioceItem.isHidden = false
        }
    }
    
    func showSegmentedChoice() {
        
        // Show form.
        segmentedChoiceForm.isHidden = false
        
        // Show actual labels.
        segmentedStartLabel.text = currentAnswers.first?.text
        segmentedFinishLabel.text = currentAnswers.last?.text
        // TODO: Implement showSegmentedChoice().
        
        // Show segments for answers.
        segmentedControl.removeAllSegments()
        currentAnswers.forEach { _ in
            segmentedControl.insertSegment(withTitle: nil, at: 0, animated: false)
        }
        
        // Select actual answer.
        let answerIndexFromQuize = currentAnswers.firstIndex { $0.isSelected }
        segmentedControl.selectedSegmentIndex = answerIndexFromQuize ?? 0
        
    }
    
    // MARK: - Save responses
    
    func saveSingleChoiceResponse() {
        let answerIndex = singleChoiceItems.firstIndex{ $0.isSelected }
        if let answerIndex = answerIndex {
            quiz.selectAnswer(questionIndex: currentQuestionIndex, answerIndex: answerIndex)
        }
    }
    
    func saveMultipleChoiceResponse() {
        
        // Clear previous answers.
        quiz.deselectAnswersInQuestion(questionIndex: currentQuestionIndex)
        
        // Select new answers.
        for (answerIndex, labelWithSwitch) in multipleChioceItems.enumerated() {
            if let uiSwitch = labelWithSwitch.arrangedSubviews.last as? UISwitch,
               uiSwitch.isOn
            {
                quiz.selectAnswer(questionIndex: currentQuestionIndex, answerIndex: answerIndex)
            }
        }
        
    }
    
    func saveSegmentedResponse() {
        let answerIndex = segmentedControl.selectedSegmentIndex
        quiz.selectAnswer(questionIndex: currentQuestionIndex, answerIndex: answerIndex)
    }
    
    // MARK: - Interactions
    
    @IBAction func finishQuestion() {
        switch currentQuestion.responseType {
        case .singleChoice:     saveSingleChoiceResponse()
        case .multipleChoice:   saveMultipleChoiceResponse()
        case .segmentedChoice:  saveSegmentedResponse()
        }
        currentQuestionIndex += 1
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
    }
    
    @IBSegueAction func gotoResultAction(_ coder: NSCoder) -> ResultViewController? {
        return ResultViewController(coder: coder, quiz: quiz)
    }
    
    @IBAction func singleChoiceButtonPressed(_ sender: UIButton) {
        singleChoiceItems.forEach{ $0.isSelected = false}
        sender.isSelected = true
    }
    
}
