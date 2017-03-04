//
//  VictoryViewController.swift
//  Darts301
//
//  Created by Greg Haines on 3/3/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import Alamofire
import UIImage_animatedGif
import UIKit

class VictoryViewController : UIViewController {
    private static let randomGifURL =
        "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=celebrate&rating=g&fmt=json"

    @IBOutlet weak var celebrateImageView: UIImageView!
    @IBOutlet weak var celebrateImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var victoryMessageLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!

    var winner: Player!
    var pointSpread: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(VictoryViewController.randomGifURL).responseJSON { response in
            if let json = response.result.value as? [String: Any],
                    let data = json["data"] as? [String: Any],
                    let url = data["image_url"] as? String {
                let secureUrl = url.replacingOccurrences(of: "http://", with: "https://")
                if let gif = UIImage.animatedImage(withAnimatedGIFURL: URL(string: secureUrl)) {
                    let scaledHeight = gif.size.height / gif.size.width * self.celebrateImageView.bounds.width
                    self.celebrateImageViewHeight.constant = scaledHeight
                    self.celebrateImageView.image = gif
                    self.celebrateImageView.layoutIfNeeded()
                }
            }
        }
        Utils.addShadow(to: celebrateImageView)
        playAgainButton.layer.cornerRadius = 8.0
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
}
