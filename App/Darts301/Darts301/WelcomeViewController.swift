//
//  WelcomeViewController.swift
//  Darts301
//
//  Created by Greg Haines on 3/4/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

class WelcomeViewController : UIViewController {

    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 8.0
        rulesButton.layer.cornerRadius = 8.0
        rulesButton.layer.borderColor = UIColor.white.cgColor
        rulesButton.layer.borderWidth = 2.0
        Utils.addShadow(to: startButton)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            Colors.player1Color.cgColor,
            UIColor(red:0.451, green:0.686, blue:0.729, alpha: 1).cgColor,
            UIColor(red:0.659, green:0.784, blue:0.608, alpha: 1).cgColor,
            Colors.player2Color.cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
