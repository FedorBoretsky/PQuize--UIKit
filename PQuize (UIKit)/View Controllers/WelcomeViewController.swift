//
//  WelcomeViewController.swift
//  Personality Quiz (UIKit)
//
//  Created by Fedor Boretskiy on 18.02.2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var startTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        startTitle.text = quiz.startTitle
    }

    @IBAction func unwindToWelcomeScreen(_ unwindSegue: UIStoryboardSegue) {
    }

}

