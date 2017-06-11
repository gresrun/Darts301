//
//  Config.swift
//  Darts301
//
//  Created by Greg Haines on 6/10/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import Foundation

class Config {
    static let shared = Config()

    private let configKeys: [String: AnyObject]

    private init() {
        self.configKeys = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Config", ofType: "plist")!)
            as! [String : AnyObject]
    }

    subscript(key: String) -> String {
        return self.configKeys[key] != nil ? self.configKeys[key]! as! String : ""
    }

    var adMobAppId: String {
        return self["adMobAppId"]
    }

    var postVictoryAdUnitId: String {
        return self["postVictoryAdUnitId"]
    }
}
