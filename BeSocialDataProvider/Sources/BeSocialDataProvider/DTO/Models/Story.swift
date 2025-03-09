//
//  Story.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

public extension DTO.Stories {
    struct Story: Codable {
        public let id: String
        public let author: User
        public let pages: [StoryPage]
    }
}
