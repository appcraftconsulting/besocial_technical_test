//
//  DataProvider.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

public class DataProvider: @unchecked Sendable  {
    public static let shared: DataProvider = .init()
}

public extension DataProvider {
    var getFriendsStories: GetFriendsStoriesEndpoint {
        GetFriendsStories.FakeEndpoint()
    }
}
