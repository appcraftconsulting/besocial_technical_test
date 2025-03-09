//
//  Story.swift
//  BeSocialEntity
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation

public struct Story: Identifiable, Equatable, Sendable {
    public init(
        id: String,
        authorId: String,
        authorDisplayName: String,
        authorProfilePictureURL: URL,
        pages: [StoryPage]
    ) {
        self.id = id
        self.authorId = authorId
        self.authorDisplayName = authorDisplayName
        self.authorProfilePictureURL = authorProfilePictureURL
        self.pages = pages
    }
    
    public let id: String
    public let authorId: String
    public let authorDisplayName: String
    public let authorProfilePictureURL: URL
    public let pages: [StoryPage]
}
