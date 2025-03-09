//
//  StoriesCarouselBannerViewModel.swift
//  StoriesFeature
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialEntity
import Foundation

public final class StoriesCarouselBannerViewModel: ObservableObject {
    @Published internal var error: Error?
    @Published internal var cells = [StoriesCarouselBannerCell]()
    
    private let friendsStoriesFetcher: FriendsStoriesFetching
    
    public init(
        friendsStoriesFetcher: FriendsStoriesFetching
    ) {
        self.friendsStoriesFetcher = friendsStoriesFetcher
    }

    // MARK: - Internal functions
    
    internal func retrieveStories() -> [Story] {
        cells.compactMap { cell in
            switch cell {
            case let .story(story):
                return story
            default:
                return nil
            }
        }
    }
    
    @MainActor
    internal func fetchStories(from storyId: String? = nil) {
        guard !cells.contains(where: \.isPlaceholder) else {
            return
        }
        
        Task {
            cells.removeAll(where: \.isPagination)
            cells.append(contentsOf: (0..<3).map { .placeholder(id: $0) })
            
            do {
                let result = try await friendsStoriesFetcher.getFriendsStories(startingFrom: storyId)
                cells.removeAll(where: \.isPlaceholder)
                cells.append(contentsOf: result.stories.map { .story($0) })
                if let nextStoryId = result.nextStoryId {
                    cells.append(.pagination(nextStoryId: nextStoryId))
                }
            } catch let error {
                print(error)
                self.error = error
                cells.removeAll(where: \.isPlaceholder)
            }
        }
    }
}
