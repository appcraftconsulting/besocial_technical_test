//
//  StoriesCarouselFullScreen.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import SwiftUI

struct StoriesCarouselFullScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: StoriesCarouselFullScreenViewModel

    internal init(viewModel: StoriesCarouselFullScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.content {
            case .loader:
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
            case let .story(story, pageIndex):
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(story.authorDisplayName)
                            .font(.headline)
                        
                        Text("publish date (todo)")
                            .font(.caption)
                        
                        HStack(spacing: 16) {
                            ForEach(story.pages.indices, id: \.self) { index in
                                if index == pageIndex {
                                    TimelineView(.animation) { _ in
                                        ProgressView(value: viewModel.currentPageProgress)
                                            .frame(maxWidth: .infinity)
                                            .tint(.white)
                                    }
                                } else {
                                    ProgressView(value: 0)
                                        .frame(maxWidth: .infinity)
                                        .tint(.white)
                                        .opacity(0.4)
                                }
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [.black.opacity(0.4), .clear], startPoint: .top, endPoint: .bottom))
                    .frame(maxHeight: .infinity, alignment: .top)
                    .background {
                        AsyncImage(url: story.pages[pageIndex].contentURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .ignoresSafeArea()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width < 50 {
                        viewModel.nextStory()
                    }

                    if value.translation.width > 50 {
                        viewModel.previousStory()
                    }
                })
        )
        .onChange(of: viewModel.shouldDismiss) { _ in
            dismiss()
        }
    }
}
