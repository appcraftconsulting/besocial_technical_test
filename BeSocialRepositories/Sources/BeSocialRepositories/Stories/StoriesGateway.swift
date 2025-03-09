//
//  StoriesGateway.swift
//  BeSocialRepositories
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation
import BeSocialDataProvider
import BeSocialEntity
import StoriesFeature

final class StoriesGateway {
    private let getFriendsStoriesEndpoint: GetFriendsStoriesEndpoint
    private let storyAdapter: StoryAdaptable
    
    init(
        getFriendsStoriesEndpoint: GetFriendsStoriesEndpoint,
        storyAdapter: StoryAdaptable
    ) {
        self.getFriendsStoriesEndpoint = getFriendsStoriesEndpoint
        self.storyAdapter = storyAdapter
    }
}

// MARK: - AuthenticationFetching

extension StoriesGateway: StoriesFeature.FriendsStoriesFetching {
    func getFriendsStories(startingFrom storyId: String?) async throws -> (stories: [Story], nextStoryId: String?) {
        let response = try await getFriendsStoriesEndpoint.getStories(from: storyId)
        let stories = response.data.stories.map { storyAdapter.adapt($0) }
        // handle server error here -> adapt to feature error
        return (stories, response.metadata.nextItemId)
    }
}
