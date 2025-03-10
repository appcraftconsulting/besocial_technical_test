//
//  StoriesCarouselFullScreen.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import NukeUI
import SwiftUI

struct StoriesCarouselFullScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: StoriesCarouselFullScreenViewModel

    internal init(viewModel: StoriesCarouselFullScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedStoryId) {
            ForEach(viewModel.tabs) { tab in
                let isTabSelected = viewModel.selectedStoryId == tab.story.id
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(tab.story.pages.indices, id: \.self) { index in
                            if isTabSelected && index == tab.pageIndex {
                                TimelineView(.animation) { _ in
                                    ProgressView(value: viewModel.currentPageProgress)
                                }
                            } else if index < tab.pageIndex {
                                ProgressView(value: 1)
                            } else {
                                ProgressView(value: 0)
                            }
                        }
                    }
                    .progressViewStyle(.linear)
                    
                    HStack(alignment: .center, spacing: 12) {
                        LazyImage(url: tab.story.authorProfilePictureURL) { state in
                            if let image = state.image {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else if state.error != nil {
                                Color.red
                            } else {
                                Color.blue
                            }
                        }
                        .frame(width: 36, height: 36)
                        .clipShape(.circle)
                        
                        VStack(alignment: .leading) {
                            Text(tab.story.authorDisplayName)
                                .font(.headline)
                            
                            Text(tab.story.pages[tab.pageIndex].createdAt, style: .relative)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
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
                        AsyncImage(url: tab.story.pages[tab.pageIndex].contentURL) { image in
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
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .tag(tab.story.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .onChange(of: viewModel.shouldDismiss) { _ in
            dismiss()
        }
    }
}
