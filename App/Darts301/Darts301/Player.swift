//
//  Player.swift
//  Darts301
//
//  Created by Aly & Friends on 2/19/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import Foundation

class Player : Equatable {
    let playerNum: Int
    let name: String
    private var _score: Int
    var score: Int {
        return _score
    }

    init(_ name: String, playerNum: Int) {
        self.name = name
        self.playerNum = playerNum
        _score = 301
    }

    func adjustScore(by value: Int) {
        if value <= _score {
            _score -= value
        }
    }
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.playerNum == rhs.playerNum
}
