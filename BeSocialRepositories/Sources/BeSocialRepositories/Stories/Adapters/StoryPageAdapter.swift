//
//  StoryPageAdapter.swift
//  BeSocialRepositories
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialDataProvider
import BeSocialEntity
import StoriesFeature

protocol StoryPageAdaptable {
    func adapt(_ storyPage: DTO.Stories.StoryPage) -> StoryPage
}

final class StoryPageAdapter: StoryPageAdaptable {
    func adapt(_ storyPage: DTO.Stories.StoryPage) -> StoryPage {
        .init(
            id: storyPage.id,
            contentType: {
                switch storyPage.contentType {
                case .image:
                        .image
                case .video:
                        .video
                }
            }(),
            contentURL: storyPage.contentURL,
            isLiked: storyPage.isLiked
        )
    }
}
