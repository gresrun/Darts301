//
//  Utils.swift
//  Darts301
//
//  Created by Greg Haines on 3/3/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

struct Utils {
    static func addShadow(to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 0.2
    }
}
