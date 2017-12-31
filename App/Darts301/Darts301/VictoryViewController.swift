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
    @IBOutlet weak var victoryMessageLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!

    var winner: Player!
    var pointSpread: Int!

    private var interstitial: GADInterstitial?

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
            self.celebrateImageView.addConstraint(NSLayoutConstraint(item: self.celebrateImageView,
                                                                     attribute: .width,
                                                                     relatedBy: .equal,
                                                                     toItem: self.celebrateImageView,
                                                                     attribute: .height,
                                                                     multiplier: gif.size.width / gif.size.height,
                                                                     constant: 0.0))
        }
        if !IAPProducts.store.isProductPurchased(IAPProducts.noAds) {
            // Pre-load the post-victory interstitial ad.
            interstitial = GADInterstitial(adUnitID: Ads.postVictoryAdUnitId)
            interstitial!.delegate = self
            let adRequest = GADRequest()
            adRequest.testDevices = [kGADSimulatorID]
            interstitial!.load(adRequest)
        }
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
            victoryMessageLabel.text = String(format: NSLocalizedString("VICTORY_CLOSE", value: "That was a close one!\nBut %@ wins. Nice work!", comment: "Label indicating which player won and that the margin of victory was small."), winner.name)
        } else if pointSpread < 75 {
            victoryMessageLabel.text = String(format: NSLocalizedString("VICTORY_STANDARD", value: "Good game,\n%@ wins!", comment: "Label indicating which player won and that the margin of victory was nominal."), winner.name)
        } else {
            victoryMessageLabel.text = String(format: NSLocalizedString("VICTORY_HUGE", value: "%@ crushed it!\nGood win.", comment: "Label indicating which player won and that the margin of victory was large."), winner.name)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func playAgainPressed() {
        if let interstitial = interstitial, interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
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
