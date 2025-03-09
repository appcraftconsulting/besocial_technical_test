//
//  StoryPage.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation

public extension DTO.Stories {
    struct StoryPage: Codable {
        public enum ContentType: String, Codable {
            case image, video
        }
        
        public let id: String
        public let contentType: ContentType
        public let contentURL: URL
        public let createdAt: Date
        
        public var isLiked: Bool = false
    }
}
