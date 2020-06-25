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
    
    //MARK:- Currency code and Symbol
    static func getDefaultCurrencyCode() -> String {
        let locale = Locale.current
        let currencyCode = locale.currencyCode!
        return currencyCode
    }
    
    static func getCurrencySymbol(with currencyCode: String) -> String {
        let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
        let locale = NSLocale(localeIdentifier: identifier) as Locale
        return locale.currencySymbol!
    }
    
    static func generateCountryCurrencyCode() -> [CountryCurrencyCode] {
        var result = [CountryCurrencyCode]()
        let countryCurrencyDict = getCountryCurrencyCodeDictionary()
        for currencyCode in countryCurrencyDict {
            let countryCurrencyCode = CountryCurrencyCode(currencyCode: currencyCode, checked: false)
            result.append(countryCurrencyCode)
        }
        result.sort {$0.currencyCode < $1.currencyCode}
        return result
    }
    
    private static func getCountryCurrencyCodeDictionary() -> [String] {
        var result = Set<String>()
        let content = readDataFromFile(file: "country-code")
        let lines = content.split(separator: "\r\n")
        for line in lines {
            result.insert(String(line.split(separator: ",")[0]))
        }
        return Array(result)
    }
    
    private static func readDataFromFile(file: String) -> String {
        guard let filePath = Bundle.main.path(forResource: file, ofType: "csv") else {fatalError("Unable to find \(file).csv")}
        do {
            let contents = try String(contentsOfFile: filePath)
            return contents
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
