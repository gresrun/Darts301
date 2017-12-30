//
//  WelcomeViewController.swift
//  Darts301
//
//  Created by Greg Haines on 3/4/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

class WelcomeViewController : UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.player1Color
        startButton.layer.cornerRadius = 8.0
        rulesButton.layer.cornerRadius = 8.0
        rulesButton.layer.borderColor = UIColor.white.cgColor
        rulesButton.layer.borderWidth = 2.0
        Utils.addShadow(to: startButton)
        rulesButton.setTitle(NSLocalizedString("RULES_BUTTON",
                                               value: "Rules",
                                               comment: "Button that, when pressed, sends the user to the game rules."),
                             for: .normal)
        startButton.setTitle(NSLocalizedString("START_GAME_BUTTON",
                                               value: "Start new game",
                                               comment: "Button that, when pressed, will start a new game."),
                             for: .normal)
        gradientView.alpha = 0.0;
        rulesButton.alpha = 0.0;
        startButton.alpha = 0.0;
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.removeConstraint(self.titleLabelVerticalCenterConstraint)
        self.view.addConstraint(NSLayoutConstraint(item: self.titleLabel,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: self.topLayoutGuide,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: 120))
        UIView.animate(withDuration: 0.8) {
            self.gradientView.alpha = 1.0;
            self.rulesButton.alpha = 1.0;
            self.startButton.alpha = 1.0;
            self.view.layoutIfNeeded()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func rulesPressed() {
        // TODO(greghaines): Custom rules page.
    }
}
