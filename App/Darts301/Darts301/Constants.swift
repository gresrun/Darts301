//
//  Constants.swift
//  Darts301
//
//  Created by Greg Haines on 3/3/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

struct Ads {
    private static let testAdUnitId = "ca-app-pub-3940256099942544/4411468910"
    #if DEBUG
    static let postVictoryAdUnitId = Ads.testAdUnitId
    #else
    static let postVictoryAdUnitId = Config.shared.postVictoryAdUnitId
    #endif
}

struct Colors {
    static let player1Color = UIColor(red: 71 / 255, green: 154 / 255, blue: 212 / 255, alpha: 1.0)
    static let player2Color = UIColor(red: 249 / 255, green: 192 / 255, blue: 86 / 255, alpha: 1.0)
}

struct Segues {
    static let rules = "rules"
    static let enterPlayers = "enterPlayers"
    static let startGame = "startGame"
    static let startGameSkipNames = "startGameSkipNames"
    static let victory = "victory"
    static let playAgain = "playAgain"
}
