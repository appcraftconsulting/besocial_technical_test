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
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(story.pages.indices, id: \.self) { index in
                            if index == pageIndex {
                                TimelineView(.animation) { _ in
                                    ProgressView(value: viewModel.currentPageProgress)
                                }
                            } else if index < pageIndex {
                                ProgressView(value: 1)
                            } else {
                                ProgressView(value: 0)
                            }
                        }
                    }
                    .progressViewStyle(.linear)
                    
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(story.authorDisplayName)
                                .font(.headline)
                            
                            Text(story.pages[pageIndex].createdAt, style: .relative)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: viewModel.close) {
                            Label {
                                Text("stories_carousel_full_screen_close_button_title", bundle: .module)
                            } icon: {
                                Image(systemName: "xmark")
                            }
                            .labelStyle(.iconOnly)
                            .font(.system(size: 24, weight: .semibold))
                        }
                    }
                }
                .foregroundStyle(.white)
                .tint(.white)
                .padding(16)
                .background(LinearGradient(colors: [.black.opacity(0.75), .clear], startPoint: .top, endPoint: .bottom).ignoresSafeArea(edges: .top))
                .frame(maxHeight: .infinity, alignment: .top)
                .background {
                    GeometryReader { proxy in
                        AsyncImage(url: story.pages[pageIndex].contentURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .onTapGesture { location in
                            if location.x > proxy.frame(in: .local).midX {
                                viewModel.nextPage()
                            } else {
                                viewModel.previousPage()
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .background(.black)
        .onChange(of: viewModel.shouldDismiss) { _ in
            dismiss()
        }
    }
}
