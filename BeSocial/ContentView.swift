//
//  ContentView.swift
//  BeSocial
//
//  Created by François Boulais on 08/03/2025.
//

import BeSocialRepositories
import StoriesFeature
import SwiftUI

struct ContentView: View {
    // should be nested in home view model
    private let friendsStoriesFetcher = StoriesGatewayFactory.shared.makeFriendsStoriesFetcher()
    
    var body: some View {
        Color.orange
            .overlay {
                ResetSeenStoriesPagesButton()
            }
            .safeAreaInset(edge: .top, spacing: .zero) {
                StoriesCarouselBanner(
                    viewModel: .init(friendsStoriesFetcher: friendsStoriesFetcher)
                )
            }
            .ignoresSafeArea(edges: .bottom)
    }
}
