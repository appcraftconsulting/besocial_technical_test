//
//  StoryCell.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import SwiftUI

struct StoryCell: View {
    @StateObject private var viewModel: StoryCellViewModel

    internal init(viewModel: StoryCellViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        AsyncImage(url: viewModel.authorProfilePictureURL) { image in
            image.resizable()
                .clipShape(.circle)
        } placeholder: {
            ProgressView()
        }
        .overlay {
            if !viewModel.hasSeenAllPages {
                Circle()
                    .stroke(.conicGradient(.init(colors: [.red, .purple, .orange, .yellow, .pink]), center: .center), lineWidth: 4)
                    .padding(-2)
            }
        }
    }
}
