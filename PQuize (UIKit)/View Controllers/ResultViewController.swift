//
//  ResultViewController.swift
//  Personality Quiz (UIKit)
//
//  Created by Fedor Boretskiy on 20.02.2022.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let quiz: Quiz
    
    init?(coder: NSCoder, quiz: Quiz) {
        self.quiz = quiz
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        displayResult()
    }
    
    func displayResult() {
        resultLabel.text = quiz.finishTitle
        descriptionLabel.text = quiz.finishDescription
    }
    
}
