//
//  UserDefault+.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import Foundation

// ⚠ user defaults should be injected in view model from app, but I didn't have time to do it properly!

extension UserDefaults {
    @objc dynamic var seenStoriesPagesIds: [String] {
        get {
            return stringArray(forKey: .seenStoriesPagesIds) ?? []
        }
        set {
            set(newValue, forKey: .seenStoriesPagesIds)
        }
    }
}

extension UserDefaults {
    enum Key: String {
        case seenStoriesPagesIds = "seen_stories_pages_ids"
    }
    
    func set(_ value: Any?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func stringArray(forKey key: Key) -> [String]? {
        stringArray(forKey: key.rawValue)
    }
}
