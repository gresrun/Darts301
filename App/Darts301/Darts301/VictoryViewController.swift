//
//  VictoryViewController.swift
//  Darts301
//
//  Created by Greg Haines on 3/3/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import GoogleMobileAds
import Firebase
import UIImage_animatedGif
import UIKit

class VictoryViewController : UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var celebrateImageView: UIImageView!
    @IBOutlet weak var celebrateImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var victoryMessageLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!

    var winner: Player!
    var pointSpread: Int!
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("Images.bundle")
        let contents = try! fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [
            URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
        let randomIndex = Int(arc4random_uniform(UInt32(contents.count)))
        let imageUrl = contents[randomIndex]
        if let gif = UIImage.animatedImage(withAnimatedGIFURL: imageUrl) {
            self.celebrateImageView.image = gif
        }
        // Pre-load the post-victory interstitial ad.
        interstitial = GADInterstitial(adUnitID: Ads.postVictoryAdUnitId)
        interstitial.delegate = self
        let adRequest = GADRequest()
        adRequest.testDevices = [kGADSimulatorID]
        interstitial.load(adRequest)
        // Log that a game was finished.
        Analytics.logEvent(AnalyticsEventPostScore, parameters: [
            AnalyticsParameterLevel: "1" as NSObject,
            AnalyticsParameterCharacter: "\(winner.playerNum)" as NSObject,
            AnalyticsParameterScore: "\(pointSpread)" as NSObject
        ])
        // Finish setting up the UI.
        Utils.addShadow(to: celebrateImageView)
        playAgainButton.layer.cornerRadius = 8.0
        Utils.addShadow(to: playAgainButton)
        view.backgroundColor = (winner.playerNum == 1) ? Colors.player1Color : Colors.player2Color
        if pointSpread < 10 {
            victoryMessageLabel.text = "That was a close one!\nBut \(winner.name) wins. Nice work!"
        } else if pointSpread < 75 {
            victoryMessageLabel.text = "Good game,\n\(winner.name) wins!"
        } else {
            victoryMessageLabel.text = "\(winner.name) crushed it!\nGood win."
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let gif = self.celebrateImageView.image {
            let scaledHeight = gif.size.height / gif.size.width * self.celebrateImageView.bounds.width
            self.celebrateImageViewHeight.constant = scaledHeight
            self.celebrateImageView.layoutIfNeeded()
        }
    }

    @IBAction func playAgainPressed() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad was not ready")
            returnToWelcomeVC()
        }
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        returnToWelcomeVC()
    }

    private func returnToWelcomeVC() {
        // Perform segue to welcome VC.
        self.performSegue(withIdentifier: Segues.playAgain, sender: self)
    }
}
