//
//  Util.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/23/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation

class Util {
    private static var util: Util?
    private var appLaunched = false
    
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: Constansts.secretsFile, ofType: "plist") else {
            fatalError("Unable to fetch secret plist.")
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            guard let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
                as? [String: String] else {fatalError("Unable to serialize secret property list")}
            for (key, value) in plist {
                if key == Constansts.apikey {
                    return value
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        fatalError("Unable to compute apiKey")
    }
    
    static func getInstance() -> Util {
        if util == nil {
            util = Util()
        }
        return util!
    }
    
    func isAppLaunched() -> Bool {
        return appLaunched
    }
    
    func setAppLaunched(_ status: Bool) {
        appLaunched = status
    }
}
