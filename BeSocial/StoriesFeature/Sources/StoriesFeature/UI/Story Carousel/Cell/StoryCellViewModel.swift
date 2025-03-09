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
    
    internal var authorProfilePictureURL: URL
    
    internal init(story: Story) {
        authorProfilePictureURL = story.authorProfilePictureURL
        userDefaults.publisher(for: \.seenStoriesPagesIds)
            .map { seenStoriesPagesIds in
                story.pages.allSatisfy { page in
                    (seenStoriesPagesIds ?? []).contains(page.id)
                }
            }
            .assign(to: &$hasSeenAllPages)
    }
}
