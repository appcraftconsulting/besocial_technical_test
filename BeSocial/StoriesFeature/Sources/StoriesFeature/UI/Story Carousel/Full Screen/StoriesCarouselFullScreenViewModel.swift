//
//  StoriesCarouselFullScreenViewModel.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import Foundation
import BeSocialEntity
import UIKit

class StoriesCarouselFullScreenViewModel: ObservableObject {
    @Published internal var content: Content = .loader
    @Published internal var shouldDismiss = false
    @Published internal var seenStoriesPagesIds = [String]()
    
    @Published internal var nextPageTimer: Timer?
    
    enum Content {
        case loader
        case story(Story, pageIndex: Int)
    }
    
    private let userDefaults: UserDefaults = .standard
    private let stories: [Story]
    private let pageDuration: TimeInterval = 5
    
    internal init(stories: [Story], from story: Story?) {
        self.stories = stories

        userDefaults.publisher(for: \.seenStoriesPagesIds)
            .assign(to: &$seenStoriesPagesIds)
        
        if let story {
            showStory(story)
        }
    }
    
    internal var currentPageProgress: Double {
        guard let nextPageTimer else {
            return 0
        }
        
        return 1 - max(min(nextPageTimer.fireDate.timeIntervalSinceNow / pageDuration, 1), 0)
    }
    
    // MARK: - Internal functions
    
    internal func previousStory() {
        if case let .story(story, _) = content,
           let index = stories.firstIndex(where: { $0.id == story.id }),
           stories.indices.contains(index - 1) {
            showStory(stories[index - 1])
        } else {
            shouldDismiss = true
        }
    }
    
    internal func nextStory() {
        if case let .story(story, _) = content,
           let index = stories.firstIndex(where: { $0.id == story.id }),
           stories.indices.contains(index + 1) {
            showStory(stories[index + 1])
        } else {
            shouldDismiss = true
        }
    }
    
    internal func previousPage() {
        guard case let .story(story, pageIndex) = content else {
            return
        }
        
        if story.pages.indices.contains(pageIndex - 1) {
            content = .story(story, pageIndex: pageIndex - 1)
        } else {
            previousStory()
        }
    }
    
    internal func nextPage() {
        guard case let .story(story, pageIndex) = content else {
            return
        }
        
        userDefaults.seenStoriesPagesIds.append(story.pages[pageIndex].id)
        
        if story.pages.indices.contains(pageIndex + 1) {
            content = .story(story, pageIndex: pageIndex + 1)
        } else {
            nextStory()
        }
        
        scheduleNextPageTimer()
    }
    
    internal func close() {
        shouldDismiss = true
    }
    
    // MARK: - Private functions
    
    private func showStory(_ story: Story) {
        let unseenPagesIds = story.pages.map(\.id)
            .filter { !seenStoriesPagesIds.contains($0) }
        
        if let firstUnseenPageId = unseenPagesIds.first,
           let firstUnseenIndex = story.pages.firstIndex(where: { $0.id == firstUnseenPageId }) {
            content = .story(story, pageIndex: firstUnseenIndex)
        } else if let firstIndex = story.pages.indices.first {
            content = .story(story, pageIndex: firstIndex)
        }
        
        scheduleNextPageTimer()
    }
    
    private func scheduleNextPageTimer() {
        nextPageTimer?.invalidate()
        nextPageTimer = .scheduledTimer(withTimeInterval: pageDuration, repeats: false) { [weak self] _ in
            self?.nextPage()
        }
    }
}
