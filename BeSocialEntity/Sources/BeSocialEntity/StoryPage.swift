//
//  StoryPage.swift
//  BeSocialEntity
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation

public struct StoryPage: Identifiable, Equatable, Sendable {
    public enum ContentType: String, Sendable {
        case image, video
    }
    
    public init(
        id: String,
        contentType: ContentType,
        contentURL: URL,
        createdAt: Date,
        isLiked: Bool
    ) {
        self.id = id
        self.contentType = contentType
        self.contentURL = contentURL
        self.createdAt = createdAt
        self.isLiked = isLiked
    }
    
    public let id: String
    public let contentType: ContentType
    public let contentURL: URL
    public let createdAt: Date
    
    public var isLiked: Bool = false
}
