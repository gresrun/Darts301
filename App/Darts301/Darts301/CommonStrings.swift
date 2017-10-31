//
//  CommonStrings.swift
//  Darts301
//
//  Created by Greg Haines on 10/31/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import Foundation

struct CommonStrings {
    static let back =
        NSLocalizedString("BACK", value: "Back",
                          comment: "Label indicating the user will return to the previous screen or state.")
    static let cancel =
        NSLocalizedString("CANCEL", value: "Cancel",
                          comment: "Label indicating the user will cancel the current operation.")
    static func playerNum(_ num: Int) -> String {
        return String(format: NSLocalizedString("PLAYER_NUM", value: "Player %i",
                          comment: "Label indicating the numerical index of the player."), num)
    }
}
