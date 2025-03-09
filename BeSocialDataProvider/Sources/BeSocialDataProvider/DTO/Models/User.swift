//
//  User.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation

public extension DTO.Stories {
    struct User: Codable {
        public let id: String
        public let displayName: String
        public let profilePictureURL: URL
        public let createdAt: Date
    }
}
