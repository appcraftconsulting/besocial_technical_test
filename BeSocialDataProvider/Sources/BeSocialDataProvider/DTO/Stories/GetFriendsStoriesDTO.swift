//
//  GetFriendsStories.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

public extension DTO.Stories {
    enum GetFriendsStories {
        
    }
}

public extension DTO.Stories.GetFriendsStories {
    struct Response: Decodable {
        public let stories: [DTO.Stories.Story]
    }
}
