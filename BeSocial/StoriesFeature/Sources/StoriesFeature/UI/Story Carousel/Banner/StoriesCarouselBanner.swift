//
//  StoriesCarouselBanner.swift
//  StoriesFeature
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialEntity
import SwiftUI

public struct StoriesCarouselBanner: View {
    @StateObject private var viewModel: StoriesCarouselBannerViewModel
    @State private var selectedStory: Story?
    
    public init(viewModel: StoriesCarouselBannerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 20) {
                ForEach(viewModel.cells) { cell in
                    Group {
                        switch cell {
                        case let .story(story):
                            Button {
                                selectedStory = story
                            } label: {
                                StoryCell(viewModel: .init(story: story))
                            }
                            .buttonStyle(.plain)
                        case .placeholder:
                            Circle()
                                .fill(.secondary)
                                .aspectRatio(1, contentMode: .fit)
                        case let .pagination(nextStoryId):
                            Circle()
                                .fill(.green) // should be clear
                                .aspectRatio(1, contentMode: .fit)
                                .onAppear {
                                    viewModel.fetchStories(from: nextStoryId)
                                }
                        }
                    }
                    .frame(width: 72)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(.background)
            .animation(.default, value: viewModel.cells)
            .onAppear {
                viewModel.fetchStories()
            }
        }
        .scrollIndicators(.hidden)
        .fullScreenCover(item: $selectedStory) { story in
            StoriesCarouselFullScreen(viewModel: StoriesCarouselFullScreenViewModel(
                stories: viewModel.retrieveStories(),
                from: story
            ))
        }
    }
}
