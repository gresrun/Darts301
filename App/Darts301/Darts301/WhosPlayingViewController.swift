//
//  WhosPlayingViewController.swift
//  Darts301
//
//  Created by Greg Haines on 3/3/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

class WhosPlayingViewController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var player1NameField: UITextField!
    @IBOutlet weak var player2NameField: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 8.0
        skipButton.layer.cornerRadius = 8.0
        skipButton.layer.borderColor = Colors.player1Color.cgColor
        skipButton.layer.borderWidth = 2.0
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

    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Do nothing
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField === player1NameField) {
            player2NameField.becomeFirstResponder()
        } else if (textField === player2NameField) {
            textField.resignFirstResponder()
            performSegue(withIdentifier: Segues.startGame, sender: textField)
        }
        return true;
    }
}
