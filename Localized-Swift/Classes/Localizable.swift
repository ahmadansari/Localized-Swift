//
//  Localizable.swift
//  Localizable
//
//  Created by Ahmad Ansari on 14/01/2019.
//  Copyright © 2019 Ahmad Ansari. All rights reserved.
//

import Foundation

private let kDefaultLanguage = "en"
private let kBaseBundle = "Base"
private let kCurrentLanguageKey = "CurrentLanguageKey"

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

class Localizable {
    static let shared = Localizable()

    func currentBundle() -> Bundle {
        let bundle: Bundle = Bundle.main
        if let path = bundle.path(forResource: self.currentLanguage(), ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle
        }
        else if let path = bundle.path(forResource: kBaseBundle, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle
        }
        return Bundle.main
    }

    /**
     *  List available languages
     *  - Returns: Array of available languages.
     */
    func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.index(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }

    /**
     *  Current language
     *  - Returns: The current language. String.
     */
    func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: kCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }

    /**
     *  Change the current language
     *  - Parameter language: Desired language.
     */
    func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: kCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }

    /**
     *  Default language
     *  - Returns: The app's default language. String.
     */
    func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return kDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = kDefaultLanguage
        }
        return defaultLanguage
    }

    /**
     Resets the current language to the default
     */
    func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }

    /**
     *  Get the current language's display name for a language.
     *  - Parameter language: Desired language.
     *  - Returns: The localized string.
     */
    func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}


public extension String {
    /**
     *  Utility method for getting localized value
     */
    func localized() -> String {
        return Localizable.shared.currentBundle().localizedString(forKey: self, value: nil, table: nil)
    }

    func localized(tableName:String?, bundle:Bundle?) -> String {
        guard bundle != nil else {
            return Bundle.main.localizedString(forKey: self, value: nil, table: tableName)
        }
        return bundle!.localizedString(forKey: self, value: nil, table: tableName)
    }
}
