//
//  StoriesFetching.swift
//  StoriesFeature
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialEntity

public protocol FriendsStoriesFetching {
    func getFriendsStories(
        startingFrom storyId: String?
    ) async throws -> (stories: [Story], nextStoryId: String?)
}
