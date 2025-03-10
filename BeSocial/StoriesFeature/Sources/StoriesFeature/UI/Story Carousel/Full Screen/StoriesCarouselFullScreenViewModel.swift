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
    struct CarouselTab: Identifiable {
        let story: Story
        var pageIndex: Int
        
        // MARK: - Identifiable
        
        var id: String {
            story.id
        }
    }
    
    @Published internal var tabs = [CarouselTab]()
    @Published internal var selectedStoryId: String? {
        didSet {
            scheduleNextPageTimer()
        }
    }
    
    @Published internal var shouldDismiss = false
    @Published internal var seenStoriesPagesIds = [String]()
    
    @Published internal var nextPageTimer: Timer?

    private let userDefaults: UserDefaults = .standard
    private let stories: [Story]
    private let pageDuration: TimeInterval = 5
    
    internal init(stories: [Story], from story: Story?) {
        self.stories = stories

        userDefaults.publisher(for: \.seenStoriesPagesIds)
            .assign(to: &$seenStoriesPagesIds)
        
        tabs = stories.map { .init(story: $0, pageIndex: 0) }
        selectedStoryId = story?.id ?? stories.first?.id
    }
    
    internal var currentPageProgress: Double {
        guard let nextPageTimer else {
            return 0
        }
        
        return 1 - max(min(nextPageTimer.fireDate.timeIntervalSinceNow / pageDuration, 1), 0)
    }
    
    // MARK: - Internal functions
    
    internal func previousStory() {
        if let selectedTabIndex = tabs.firstIndex(where: { $0.story.id == selectedStoryId }),
           tabs.indices.contains(selectedTabIndex - 1) {
            selectedStoryId = tabs[selectedTabIndex - 1].story.id
        } else {
            shouldDismiss = true
        }
    }
    
    internal func nextStory() {
        if let selectedTabIndex = tabs.firstIndex(where: { $0.story.id == selectedStoryId }),
           tabs.indices.contains(selectedTabIndex + 1) {
            selectedStoryId = tabs[selectedTabIndex + 1].story.id
        } else {
            shouldDismiss = true
        }
    }
    
    internal func previousPage() {
        guard let selectedTabIndex = tabs.firstIndex(where: { $0.story.id == selectedStoryId }) else {
            return
        }
        
        let selectedTab = tabs[selectedTabIndex]
        
        if selectedTab.story.pages.indices.contains(selectedTab.pageIndex - 1) {
            tabs[selectedTabIndex].pageIndex = selectedTab.pageIndex - 1
            scheduleNextPageTimer()
        } else {
            previousStory()
        }
    }
    
    internal func nextPage() {
        guard let selectedTabIndex = tabs.firstIndex(where: { $0.story.id == selectedStoryId }) else {
            return
        }

        let selectedTab = tabs[selectedTabIndex]
        let seenStoryPageId = selectedTab.story.pages[selectedTab.pageIndex].id
        userDefaults.seenStoriesPagesIds.append(seenStoryPageId)

        if selectedTab.story.pages.indices.contains(selectedTab.pageIndex + 1) {
            tabs[selectedTabIndex].pageIndex = selectedTab.pageIndex + 1
            scheduleNextPageTimer()
        } else {
            nextStory()
        }
    }
    
    internal func close() {
        shouldDismiss = true
    }
    
    // MARK: - Private functions
    
//    private func showStory(_ story: Story) {
//        let unseenPagesIds = story.pages.map(\.id)
//            .filter { !seenStoriesPagesIds.contains($0) }
//        
//        if let firstUnseenPageId = unseenPagesIds.first,
//           let firstUnseenIndex = story.pages.firstIndex(where: { $0.id == firstUnseenPageId }) {
//            select = .init(storyId: story.id, pageIndex: firstUnseenIndex)
//        } else if let firstIndex = story.pages.indices.first {
//            selectedContent = .init(storyId: story.id, pageIndex: firstIndex)
//        }
//        
//        scheduleNextPageTimer()
//    }
    
    private func scheduleNextPageTimer() {
        nextPageTimer?.invalidate()
        nextPageTimer = .scheduledTimer(withTimeInterval: pageDuration, repeats: false) { [weak self] _ in
            self?.nextPage()
        }
    }
}
