//
//  StoryAdapter.swift
//  BeSocialRepositories
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialDataProvider
import BeSocialEntity
import StoriesFeature

protocol StoryAdaptable {
    func adapt(_ story: DTO.Stories.Story) -> Story
}

final class StoryAdapter: StoryAdaptable {
    private let pageAdapter: StoryPageAdaptable
    
    init(pageAdapter: StoryPageAdaptable) {
        self.pageAdapter = pageAdapter
    }
    
    func adapt(_ story: DTO.Stories.Story) -> Story {
        .init(
            id: story.id,
            authorId: story.author.id,
            authorDisplayName: story.author.displayName,
            authorProfilePictureURL: story.author.profilePictureURL,
            pages: story.pages.map { pageAdapter.adapt($0) }
        )
    }
}
