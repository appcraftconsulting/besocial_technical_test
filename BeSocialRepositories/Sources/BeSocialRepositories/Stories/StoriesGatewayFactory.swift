//
//  StoriesGatewayFactory.swift
//  BeSocialRepositories
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialDataProvider
import StoriesFeature

public final class StoriesGatewayFactory: @unchecked Sendable  {
    public static let shared = StoriesGatewayFactory()
    
    private let dataProvider: DataProvider
    
    private lazy var storyPageAdapter = StoryPageAdapter()
    private lazy var storyAdapter = StoryAdapter(pageAdapter: storyPageAdapter)
  
    private lazy var gateway: StoriesGateway = .init(
        getFriendsStoriesEndpoint: dataProvider.getFriendsStories,
        storyAdapter: storyAdapter
    )
    
    private convenience init() {
        self.init(dataProvider: .shared)
    }
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    public func makeFriendsStoriesFetcher() -> FriendsStoriesFetching {
        gateway
    }
}
