//
//  GradientView.swift
//  Darts301
//
//  Created by Greg Haines on 10/4/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView : UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }

    private func configureGradient() {
        if let gradientLayer = self.layer as? CAGradientLayer {
            gradientLayer.colors = [
                Colors.player1Color.cgColor,
                UIColor(red:0.451, green:0.686, blue:0.729, alpha: 1).cgColor,
                UIColor(red:0.659, green:0.784, blue:0.608, alpha: 1).cgColor,
                Colors.player2Color.cgColor
            ]
        }
    }
}
