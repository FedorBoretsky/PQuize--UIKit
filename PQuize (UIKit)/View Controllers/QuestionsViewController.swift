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
        case .rangeChoice:
            showRangeChoice()
        case .segmentedChoice:
            showSegmentedChoice()
        }
    }
    
    func showSingleChoice() {
        singleChoiceForm.isHidden = false
        singleChoiceItems.forEach{ $0.isHidden = true }
        zip(singleChoiceItems, currentAnswers).forEach{
            (button, answer)
            in
            button.setTitle(answer.text, for: [])
            button.isHidden = false
        }
    }
    
    func showMultipleChoice() {
        multipleChoiceForm.isHidden = false
        multipleChioceItems.forEach{ $0.isHidden = true }
        zip(multipleChioceItems, currentAnswers).forEach{
            (chiceItem, answer)
            in
            let label = chiceItem.arrangedSubviews.first as! UILabel
            label.text = answer.text
            chiceItem.isHidden = false
        }
    }
    
    func showRangeChoice() {
        rangeChoiceForm.isHidden = false
        rangeStartLabel.text = currentAnswers.first?.text
        rangeFinishLabel.text = currentAnswers.last?.text
    }
    
    func showSegmentedChoice() {
        segmentedChoiceForm.isHidden = false
        segmentedStartLabel.text = currentAnswers.first?.text
        segmentedFinishLabel.text = currentAnswers.last?.text
        // TODO: Implement showSegmentedChoice().

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
    
    func saveRangeResponse() {
        let range = rangeSlider.maximumValue - rangeSlider.minimumValue
        let stepLentgh = range / Float(currentAnswers.count)
        let stepsInValue = Int( (rangeSlider.value / stepLentgh).rounded(.towardZero) )
        let answerIndex = min(stepsInValue, currentAnswers.count - 1)
        quiz.selectAnswer(questionIndex: currentQuestionIndex, answerIndex: answerIndex)
    }

    func saveSegmentedResponse() {
        
    }
    
    // MARK: - Interactions
    
    @IBAction func finishQuestion() {
        switch currentQuestion.responseType {
        case .singleChoice:     saveSingleChoiceResponse()
        case .multipleChoice:   saveMultipleChoiceResponse()
        case .rangeChoice:      saveRangeResponse()
        case .segmentedChoice:  saveSegmentedResponse()
        }
        currentQuestionIndex += 1
    }
    
    @IBSegueAction func gotoResultAction(_ coder: NSCoder) -> ResultViewController? {
        return ResultViewController(coder: coder, quiz: quiz)
    }
    
    @IBAction func singleChoiceButtonPressed(_ sender: UIButton) {
        singleChoiceItems.forEach{ $0.isSelected = false}
        sender.isSelected = true
    }
    
}
