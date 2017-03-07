//
//  WhosPlayingViewController.swift
//  Darts301
//
//  Created by Greg Haines on 3/3/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import SwiftValidator
import UIKit

class WhosPlayingViewController : UIViewController, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet weak var player1NameField: UITextField!
    @IBOutlet weak var player2NameField: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    private let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 8.0
        skipButton.layer.cornerRadius = 8.0
        skipButton.layer.borderColor = Colors.player1Color.cgColor
        skipButton.layer.borderWidth = 2.0
        Utils.addShadow(to: startButton)
        player1NameField.layer.cornerRadius = 4.0
        player2NameField.layer.cornerRadius = 4.0
        validator.registerField(player1NameField, rules: [RequiredRule()])
        validator.registerField(player2NameField, rules: [RequiredRule()])
        clearValidationErrors()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.startGame, let gameVC = segue.destination as? GameViewController {
            gameVC.player1 = Player(player1NameField.text!, playerNum: 1)
            gameVC.player2 = Player(player2NameField.text!, playerNum: 2)
        } else if segue.identifier == Segues.startGameSkipNames, let gameVC = segue.destination as? GameViewController {
            gameVC.player1 = Player("Player 1", playerNum: 1)
            gameVC.player2 = Player("Player 2", playerNum: 2)
        }
    }

    @IBAction func startTapped(_ sender: UIButton) {
        validator.validate(self)
    }

    private func clearValidationErrors() {
        for field in [player1NameField, player2NameField] {
            if let field = field {
                clearValidationError(field)
            }
        }
    }

    private func clearValidationError(_ field: UITextField) {
        field.layer.borderColor = UIColor.clear.cgColor
        field.layer.borderWidth = 0.0
    }

    private func addValidationError(_ field: UITextField) {
        field.layer.borderColor = UIColor.red.cgColor
        field.layer.borderWidth = 1.0
    }

    private func validateField(_ field: UITextField) {
        validator.validateField(field) { error in
            if let _ = error {
                addValidationError(field)
            } else {
                clearValidationError(field)
            }
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Do nothing
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validateField(textField)
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField === player1NameField) {
            validateField(textField)
            player2NameField.becomeFirstResponder()
        } else if (textField === player2NameField) {
            textField.resignFirstResponder()
            validator.validate(self)
        }
        return true;
    }

    // MARK: ValidationDelegate
    func validationSuccessful() {
        clearValidationErrors()
        performSegue(withIdentifier: Segues.startGame, sender: self)
    }

    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        clearValidationErrors()
        // Highlight fields with errors in red
        for (field, _) in errors {
            if let field = field as? UITextField {
                addValidationError(field)
            }
        }
    }
}
