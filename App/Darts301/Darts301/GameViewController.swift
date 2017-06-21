//
//  GameViewController.swift
//  Darts301
//
//  Created by Aly & Friends on 2/19/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import Firebase
import UIKit

class GameViewController: UIViewController {

    private static let gutterWidth: CGFloat = 4.0
    private static let gutterHeight: CGFloat = 6.0
    private static let multiplierAnimationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var player1ScoreBox: UIView!
    @IBOutlet weak var player1ScoreNameLabel: UILabel!
    @IBOutlet weak var player1ScoreValueLabel: UILabel!
    @IBOutlet weak var player2ScoreBox: UIView!
    @IBOutlet weak var player2ScoreNameLabel: UILabel!
    @IBOutlet weak var player2ScoreValueLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var scoreHelpText: UILabel!
    @IBOutlet weak var dart1ScoreLabel: UILabel!
    @IBOutlet weak var dart2ScoreLabel: UILabel!
    @IBOutlet weak var dart3ScoreLabel: UILabel!
    @IBOutlet weak var keypadView: UIView!
    @IBOutlet weak var confirmButtonView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var dart1ScoreView: UIView!
    @IBOutlet weak var dart2ScoreView: UIView!
    @IBOutlet weak var dart3ScoreView: UIView!
    @IBOutlet weak var multiplierView: UIView!

    var player1: Player!
    var player2: Player!
    private var currentPlayer: Player?
    private var roundScore: RoundScore = RoundScore(dart1: nil, dart2: nil, dart3: nil)
    private var state: State = State.inputDart(1)
    private var deleteButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButtonView.isHidden = true
        keypadView.isHidden = false
        player1ScoreNameLabel.text = player1.name
        player1ScoreValueLabel.text = "\(player1.score)"
        player2ScoreNameLabel.text = player2.name
        player2ScoreValueLabel.text = "\(player2.score)"
        confirmButton.layer.cornerRadius = 4.0

        // Tap gesture reconizers
        dart1ScoreView.addGestureRecognizer(
            UITapGestureRecognizer(target:self, action:#selector(GameViewController.reviseDart(_:))))
        dart2ScoreView.addGestureRecognizer(
            UITapGestureRecognizer(target:self, action:#selector(GameViewController.reviseDart(_:))))
        dart3ScoreView.addGestureRecognizer(
            UITapGestureRecognizer(target:self, action:#selector(GameViewController.reviseDart(_:))))

        // Log that a new game was started.
        Analytics.logEvent(AnalyticsEventLevelUp, parameters: [
            AnalyticsParameterLevel: "1" as NSObject,
            AnalyticsParameterCharacter: "0" as NSObject,
        ])
        nextPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createButtonGrid()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.victory, let victoryVC = segue.destination as? VictoryViewController {
            victoryVC.winner = currentPlayer
            victoryVC.pointSpread = (player1 == currentPlayer) ? player2.score : player1.score
        }
    }

    private func nextPlayer() {
        currentPlayer = (currentPlayer == player1) ? player2 : player1
        if (player1 == currentPlayer) {
            Utils.addShadow(to: player1ScoreBox)
            player2ScoreBox.layer.shadowOpacity = 0.0
        } else {
            player1ScoreBox.layer.shadowOpacity = 0.0
            Utils.addShadow(to: player2ScoreBox)
        }
        turnLabel.text = "\(currentPlayer!.name)'s Turn".uppercased()
        turnLabel.textColor = colorForCurrentPlayer()
        for subview in keypadView.subviews {
            if let buttonView = subview as? UIButton {
                buttonView.setTitleColor(colorForCurrentPlayer(), for: .highlighted)
            }
        }
        dart1ScoreLabel.text = ""
        dart2ScoreLabel.text = ""
        dart3ScoreLabel.text = ""
        roundScore.dart1 = nil
        roundScore.dart2 = nil
        roundScore.dart3 = nil
        scoreHelpText.isHidden = false
        confirmButton.backgroundColor = colorForCurrentPlayer()
    }

    private func createButtonGrid() {
        let buttonWidth: CGFloat = (keypadView.bounds.width - (GameViewController.gutterWidth * 4)) / 5.0
        let topOffset: CGFloat = keypadView.bounds.height - (5.0 * (GameViewController.gutterHeight + buttonWidth))
        var count: Int = 1
        for row in 0...3 {
            for col in 0...4 {
                let buttonView = keypadButton(at: CGRect(x: CGFloat(col) * (GameViewController.gutterWidth + buttonWidth),
                    y: topOffset + CGFloat(row) * (GameViewController.gutterHeight + buttonWidth), width: buttonWidth, height: buttonWidth), with: count)
                buttonView.addGestureRecognizer(
                    UILongPressGestureRecognizer(target: self, action:#selector(GameViewController.keyLongPressed(_:))))
                keypadView.addSubview(buttonView)
                count += 1
            }
        }
        let row: Int = 4
        var col: Int = 0
        let button25 = keypadButton(at: CGRect(x: CGFloat(col) * (GameViewController.gutterWidth + buttonWidth),
            y: topOffset + CGFloat(row) * (GameViewController.gutterHeight + buttonWidth), width: buttonWidth, height: buttonWidth), with: 25)
        keypadView.addSubview(button25)
        col += 1
        let button50 = keypadButton(at: CGRect(x: CGFloat(col) * (GameViewController.gutterWidth + buttonWidth),
            y: topOffset + CGFloat(row) * (GameViewController.gutterHeight + buttonWidth), width: buttonWidth, height: buttonWidth), with: 50)
        keypadView.addSubview(button50)
        col += 1
        let button0 = keypadButton(at: CGRect(x: CGFloat(col) * (GameViewController.gutterWidth + buttonWidth),
            y: topOffset + CGFloat(row) * (GameViewController.gutterHeight + buttonWidth), width: buttonWidth, height: buttonWidth), with: 0)
        keypadView.addSubview(button0)
        col += 1
        deleteButton = keypadButton(at: CGRect(x: CGFloat(col) * (GameViewController.gutterWidth + buttonWidth),
            y: topOffset + CGFloat(row) * (GameViewController.gutterHeight + buttonWidth), width: buttonWidth * 2 + GameViewController.gutterWidth, height: buttonWidth), with: -1)
        deleteButton.setTitle("Back", for: .normal)
        keypadView.addSubview(deleteButton)
    }

    private func layoutMultiplierView(with button: UIButton) {
        multiplierView.subviews.forEach { (subview) in subview.removeFromSuperview() }
        let doppelRect = multiplierView.convert(button.bounds, from: button)
        let doppelgangerKey = multiplierButtonKey(at: doppelRect, with: button.tag)

        var multiple2xRect = CGRect(origin: doppelRect.origin, size: doppelRect.size)
        var multiple3xRect = CGRect(origin: doppelRect.origin, size: doppelRect.size)
        if button.tag % 5 != 0 || button.tag == 25 && button.tag == 50 {
            multiple2xRect.origin.y -= (doppelRect.size.height + 16.0)
            multiple3xRect.origin.y -= (doppelRect.size.height - 4.0)
            multiple3xRect.origin.x += (doppelRect.size.width + 4.0)
        } else {
            multiple3xRect.origin.y -= (doppelRect.size.height + 16.0)
            multiple2xRect.origin.y -= (doppelRect.size.height - 4.0)
            multiple2xRect.origin.x -= (doppelRect.size.width + 4.0)
        }

        let multiply2xKey = multiplierKey(at: multiple2xRect, with: 2)
        let multiply3xKey = multiplierKey(at: multiple3xRect, with: 3)

        multiplierView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        multiplierView.addSubview(doppelgangerKey)
        multiplierView.addSubview(multiply2xKey)
        multiplierView.addSubview(multiply3xKey)
    }

    private func keypadButton(at frame: CGRect, with value: Int) -> UIButton {
        let buttonView: UIButton = UIButton(frame: frame)
        buttonView.layer.cornerRadius = 4.0
        buttonView.layer.borderWidth = 0.25
        buttonView.layer.borderColor = UIColor(red: 232 / 255, green: 232 / 255, blue: 232 / 255, alpha: 1.0).cgColor
        buttonView.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1.0)
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        buttonView.setTitle("\(value)", for: .normal)
        buttonView.setTitleColor(UIColor.darkText, for: .normal)
        buttonView.setTitleColor(colorForCurrentPlayer(), for: .highlighted)
        buttonView.addTarget(self, action: #selector(keypadButtonPressed(_:)), for: .touchUpInside)
        buttonView.tag = value
        return buttonView
    }

    private func multiplierKey(at frame: CGRect, with value: Int) -> UIButton {
        let buttonView: UIButton = UIButton(frame: frame)
        buttonView.backgroundColor = colorForCurrentPlayer()
        buttonView.setTitleColor(UIColor.white, for: .normal)
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        buttonView.layer.cornerRadius = 0.5 * buttonView.bounds.size.width
        buttonView.clipsToBounds = true
        buttonView.setTitle("x\(value)", for: .normal)
        buttonView.tag = value * 100;
        Utils.addShadow(to: buttonView)
        return buttonView
    }

    private func multiplierButtonKey(at frame: CGRect, with value: Int) -> UIButton {
        let buttonView: UIButton = keypadButton(at: frame, with: value)
        buttonView.backgroundColor = UIColor.white
        buttonView.setTitleColor(colorForCurrentPlayer(), for: .normal)
        Utils.addShadow(to: buttonView)
        return buttonView
    }

    private func colorForCurrentPlayer() -> UIColor {
        return (currentPlayer == player1) ? Colors.player1Color : Colors.player2Color
    }
    
    @objc private func keypadButtonPressed(_ sender: UIButton) {
        if sender.tag == -1 {
            deletePressed()
        } else {
            applyValue(sender.tag)
        }
    }
    
    private func deletePressed() {
        switch state {
        case .inputDart(2):
            scoreHelpText.isHidden = false
            dart1ScoreLabel.text = ""
            setNextState(.inputDart(1))
        case .inputDart(3):
            setNextState(.inputDart(2))
            dart2ScoreLabel.text = ""
        case .reviseDart(1):
            setNextState(.confirm)
        case .reviseDart(2):
            setNextState(.confirm)
        case .reviseDart(3):
            setNextState(.confirm)
        default:
            // OMGWTFBBQ
            break
        }
    }
    
    private func applyValue(_ value: Int) {
        switch state {
        case .inputDart(1):
            scoreHelpText.isHidden = true
            roundScore.dart1 = value
            dart1ScoreLabel.text = "\(value)"
            setNextState(.inputDart(2))
        case .inputDart(2):
            roundScore.dart2 = value
            dart2ScoreLabel.text = "\(value)"
            setNextState(.inputDart(3))
        case .inputDart(3):
            roundScore.dart3 = value
            dart3ScoreLabel.text = "\(value)"
            setNextState(.confirm)
        case .reviseDart(1):
            roundScore.dart1 = value
            dart1ScoreLabel.text = "\(value)"
            setNextState(.confirm)
        case .reviseDart(2):
            roundScore.dart2 = value
            dart2ScoreLabel.text = "\(value)"
            setNextState(.confirm)
        case .reviseDart(3):
            roundScore.dart3 = value
            dart3ScoreLabel.text = "\(value)"
            setNextState(.confirm)
        default:
            // OMGWTFBBQ
            break
        }
    }
    
    private func setNextState(_ nextState: State) {
        state = nextState
        switch state {
        case .confirm:
            keypadView.isHidden = true
            confirmButtonView.isHidden = false
            var sum: Int = roundScore.dart1!
            sum += roundScore.dart2!
            sum += roundScore.dart3!
            confirmButton.setTitle("Enter \(sum) points", for: .normal)
            dart1ScoreLabel.text = "\(roundScore.dart1!)"
            dart2ScoreLabel.text = "\(roundScore.dart2!)"
            dart3ScoreLabel.text = "\(roundScore.dart3!)"
        case .finish:
            var sum: Int = roundScore.dart1!
            sum += roundScore.dart2!
            sum += roundScore.dart3!
            currentPlayer?.adjustScore(by: sum)
            let label = (currentPlayer == player1) ? player1ScoreValueLabel : player2ScoreValueLabel
            label?.text = "\(currentPlayer!.score)"
            if currentPlayer?.score == 0 {
                performSegue(withIdentifier: Segues.victory, sender: self)
            } else {
                nextPlayer()
                keypadView.isHidden = false
                confirmButtonView.isHidden = true
                setNextState(.inputDart(1))
            }
        case .inputDart(1), .inputDart(2), .inputDart(3):
            deleteButton.setTitle("Back", for: .normal)
        case .reviseDart(1):
            dart1ScoreLabel.text = ""
            keypadView.isHidden = false
            confirmButtonView.isHidden = true
            deleteButton.setTitle("Cancel", for: .normal)
        case .reviseDart(2):
            dart2ScoreLabel.text = ""
            keypadView.isHidden = false
            confirmButtonView.isHidden = true
            deleteButton.setTitle("Cancel", for: .normal)
        case .reviseDart(3):
            dart3ScoreLabel.text = ""
            keypadView.isHidden = false
            confirmButtonView.isHidden = true
            deleteButton.setTitle("Cancel", for: .normal)
        default:
            keypadView.isHidden = false
            confirmButtonView.isHidden = true
        }
    }
    
    func reviseDart(_ sender: UITapGestureRecognizer) {
        if case .confirm = state {
            if sender.view === dart1ScoreView {
                setNextState(State.reviseDart(1))
            } else if sender.view === dart2ScoreView {
                setNextState(State.reviseDart(2))
            } else if sender.view === dart3ScoreView {
                setNextState(State.reviseDart(3))
            }
        }
    }

    func keyLongPressed(_ sender: UILongPressGestureRecognizer) {
        if let pressedKey = sender.view as? UIButton  {
            switch sender.state {
            case .began:
                layoutMultiplierView(with: pressedKey)
                multiplierView.alpha = 0.0
                multiplierView.isHidden = false
                UIView.animate(withDuration: GameViewController.multiplierAnimationDuration, animations: {
                    self.multiplierView.alpha = 1.0
                });
            case .ended:
                let touchPoint = sender.location(in: multiplierView)
                let potentialView = multiplierView.subviews.first(where: { (subview) -> Bool in
                    subview.tag > 100 && subview.frame.contains(touchPoint)
                })
                if let multiplierKey = potentialView {
                    applyValue(pressedKey.tag * multiplierKey.tag / 100)
                }
                UIView.animate(withDuration: GameViewController.multiplierAnimationDuration, animations: {
                    self.multiplierView.alpha = 0.0
                }, completion: { (complete) in
                    self.multiplierView.isHidden = true
                })
            default:
                // Do nothing
                break
            }
        }
    }

    @IBAction func confirmPressed(_ sender: UIButton) {
        setNextState(.finish)
    }
}

struct RoundScore {
    var dart1: Int?
    var dart2: Int?
    var dart3: Int?
}

enum State {
    case inputDart(Int)
    case confirm
    case reviseDart(Int)
    case finish
}

