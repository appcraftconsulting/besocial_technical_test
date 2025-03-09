//
//  StoryCellViewModel.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import BeSocialEntity
import Foundation

class StoryCellViewModel: ObservableObject {
    @Published internal var hasSeenAllPages: Bool = false
    
    private let userDefaults: UserDefaults = .standard
    
    internal let authorProfilePictureURL: URL
    internal let authorDisplayName: String

    internal init(story: Story) {
        authorProfilePictureURL = story.authorProfilePictureURL
        authorDisplayName = story.authorDisplayName
        userDefaults.publisher(for: \.seenStoriesPagesIds)
            .map { seenStoriesPagesIds in
                story.pages.allSatisfy { page in
                    seenStoriesPagesIds.contains(page.id)
                }
            }
            .assign(to: &$hasSeenAllPages)
    }
}
