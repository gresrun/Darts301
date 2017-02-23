//
//  ViewController.swift
//  Darts301
//
//  Created by Aly & Friends on 2/19/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private static let gutterWidth: CGFloat = 4.0
    private static let player1Color: UIColor = UIColor(red: 71 / 255, green: 154 / 255, blue: 212 / 255, alpha: 1.0)
    private static let player2Color: UIColor = UIColor(red: 249 / 255, green: 192 / 255, blue: 86 / 255, alpha: 1.0)
    
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

    private let player1: Player = Player("Greg", playerNum: 1)
    private let player2: Player = Player("Chris", playerNum: 2)
    private var currentPlayer: Player?
    private var roundScore: RoundScore = RoundScore(dart1: nil, dart2: nil, dart3: nil)
    private var state: State = State.inputDart(1)
    private var dart1ScoreRecogn: UITapGestureRecognizer = UITapGestureRecognizer()
    private var dart2ScoreRecogn: UITapGestureRecognizer = UITapGestureRecognizer()
    private var dart3ScoreRecogn: UITapGestureRecognizer = UITapGestureRecognizer()
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

        //Tap gesture reconizers
        dart1ScoreRecogn = UITapGestureRecognizer(target:self, action:#selector(ViewController.reviseDart(_:)))
        dart2ScoreRecogn = UITapGestureRecognizer(target:self, action:#selector(ViewController.reviseDart(_:)))
        dart3ScoreRecogn = UITapGestureRecognizer(target:self, action:#selector(ViewController.reviseDart(_:)))
        dart1ScoreView.addGestureRecognizer(dart1ScoreRecogn)
        dart2ScoreView.addGestureRecognizer(dart2ScoreRecogn)
        dart3ScoreView.addGestureRecognizer(dart3ScoreRecogn)

        nextPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createButtonGrid()
    }

    private func nextPlayer() {
        currentPlayer = (currentPlayer == player1) ? player2 : player1
        player1ScoreBox.layer.shadowOffset = (player1 == currentPlayer) ? CGSize(width: 8, height: 8) : CGSize.zero
        player2ScoreBox.layer.shadowOffset = (player2 == currentPlayer) ? CGSize(width: 8, height: 8) : CGSize.zero
        turnLabel.text = "\(currentPlayer!.name)'s Turn".uppercased()
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
        let buttonWidth: CGFloat = (keypadView.bounds.width - (ViewController.gutterWidth * 4)) / 5.0
        var count: Int = 1
        for row in 0...3 {
            for col in 0...4 {
                let buttonView = keypadButton(at: CGRect(x: CGFloat(col) * (ViewController.gutterWidth + buttonWidth),
                    y: CGFloat(row) * (ViewController.gutterWidth + buttonWidth), width: buttonWidth, height: buttonWidth), with: count)
                let multiplyRecogn: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(ViewController.keyLongPressed(_:)))
                buttonView.addGestureRecognizer(multiplyRecogn)
                keypadView.addSubview(buttonView)
                count += 1
            }
        }
        let row: Int = 4
        var col: Int = 0
        let button25 = keypadButton(at: CGRect(x: CGFloat(col) * (ViewController.gutterWidth + buttonWidth),
            y: CGFloat(row) * (ViewController.gutterWidth + buttonWidth), width: buttonWidth, height: buttonWidth), with: 25)
        keypadView.addSubview(button25)
        col += 1
        let button50 = keypadButton(at: CGRect(x: CGFloat(col) * (ViewController.gutterWidth + buttonWidth),
            y: CGFloat(row) * (ViewController.gutterWidth + buttonWidth), width: buttonWidth, height: buttonWidth), with: 50)
        keypadView.addSubview(button50)
        col += 1
        let button0 = keypadButton(at: CGRect(x: CGFloat(col) * (ViewController.gutterWidth + buttonWidth),
            y: CGFloat(row) * (ViewController.gutterWidth + buttonWidth), width: buttonWidth, height: buttonWidth), with: 0)
        keypadView.addSubview(button0)
        col += 1
        deleteButton = keypadButton(at: CGRect(x: CGFloat(col) * (ViewController.gutterWidth + buttonWidth),
            y: CGFloat(row) * (ViewController.gutterWidth + buttonWidth), width: buttonWidth * 2 + ViewController.gutterWidth, height: buttonWidth), with: -1)
        deleteButton.setTitle("Back", for: .normal)
        keypadView.addSubview(deleteButton)
    }

    private func layoutMultiplierView(with button: UIButton) {
        var doppelRect: CGRect = CGRect(origin: button.frame.origin, size: button.frame.size)
        doppelRect.origin.x += keypadView.frame.origin.x
        doppelRect.origin.y += keypadView.frame.origin.y
        let doppelgangerKey : UIButton = multiplyerButtonKey(at: doppelRect, with: button.tag)

        var multiple2xRect: CGRect = CGRect(origin: doppelRect.origin, size: doppelRect.size)
        var multiple3xRect: CGRect = CGRect(origin: doppelRect.origin, size: doppelRect.size)
        if button.tag % 5 != 0 || button.tag == 25 && button.tag == 50 {
            multiple2xRect.origin.y -= (doppelRect.size.height + 16.0)
            multiple3xRect.origin.y -= (doppelRect.size.height - 4.0)
            multiple3xRect.origin.x += (doppelRect.size.width + 4.0)
        } else {
            multiple3xRect.origin.y -= (doppelRect.size.height + 16.0)
            multiple2xRect.origin.y -= (doppelRect.size.height - 4.0)
            multiple2xRect.origin.x -= (doppelRect.size.width + 4.0)
        }

        let multiply2xKey : UIButton = multiplyer2xKey(at: multiple2xRect, with:200)
        let multiply3xKey : UIButton = multiplyer3xKey(at: multiple3xRect, with:300)

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
        buttonView.setTitle("\(value)", for: .normal)
        buttonView.setTitleColor(UIColor.darkText, for: .normal)
        buttonView.setTitleColor(colorForCurrentPlayer(), for: .highlighted)
        buttonView.addTarget(self, action: #selector(keypadButtonPressed(_:)), for: .touchUpInside)
        buttonView.tag = value
        return buttonView
    }

    private func multiplyer2xKey(at frame: CGRect, with value: Int) -> UIButton {
        let buttonView: UIButton = keypadButton(at:frame, with:value)
        buttonView.backgroundColor = UIColor.blue
        buttonView.setTitleColor(UIColor.white, for:UIControlState())
        buttonView.layer.cornerRadius = 0.5 * buttonView.bounds.size.width
        buttonView.clipsToBounds = true
        buttonView.setTitle("2x", for: .normal)
        buttonView.removeTarget(self, action: #selector(keypadButtonPressed(_:)), for: .touchUpInside)
        return buttonView
    }

    private func multiplyer3xKey(at frame: CGRect, with value: Int) -> UIButton {
        let buttonView: UIButton = keypadButton(at:frame, with:value)
        buttonView.backgroundColor = UIColor.blue
        buttonView.setTitleColor(UIColor.white, for:UIControlState())
        buttonView.layer.cornerRadius = 0.5 * buttonView.bounds.size.width
        buttonView.clipsToBounds = true
        buttonView.setTitle("3x", for: .normal)
        buttonView.removeTarget(self, action: #selector(keypadButtonPressed(_:)), for: .touchUpInside)
        return buttonView
    }

    private func multiplyerButtonKey(at frame: CGRect, with value: Int) -> UIButton {
        let buttonView: UIButton = keypadButton(at:frame, with:value)
        buttonView.backgroundColor = UIColor.white
        buttonView.setTitleColor(UIColor.blue, for:UIControlState())
        buttonView.removeTarget(self, action: #selector(keypadButtonPressed(_:)), for: .touchUpInside)
        return buttonView
    }

    private func colorForCurrentPlayer() -> UIColor {
        return (currentPlayer == player1) ? ViewController.player1Color : ViewController.player2Color
    }
    
    @objc private func keypadButtonPressed(_ sender: UIButton) {
        if sender.tag == -1 { // Delete
            print("DELETE")
            deletePressed()
        } else { // Real value
            print("\(sender.tag)")
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
            nextPlayer()
            keypadView.isHidden = false
            confirmButtonView.isHidden = true
            setNextState(.inputDart(1))
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
            if sender === dart1ScoreRecogn {
                setNextState(State.reviseDart(1))
            } else if sender === dart2ScoreRecogn {
                setNextState(State.reviseDart(2))
            } else if sender === dart3ScoreRecogn {
                setNextState(State.reviseDart(3))
            }
        }
    }

    func keyLongPressed(_ sender: UILongPressGestureRecognizer) {
        multiplierView.isHidden = false
        if let pressedKey = sender.view as? UIButton  {
            layoutMultiplierView(with: pressedKey)
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

