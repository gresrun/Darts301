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
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func rulesPressed() {
        // TODO(greghaines): Custom rules page.
    }
}
