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
        VStack(alignment: .center, spacing: 6) {
            AsyncImage(url: viewModel.authorProfilePictureURL) { image in
                image.resizable()
            } placeholder: {
                Color.purple
            }
            .clipShape(.circle)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Group {
                    if !viewModel.hasSeenAllPages {
                        Circle()
                            .stroke(.conicGradient(.init(colors: [.red, .purple, .orange, .yellow, .pink]), center: .center), lineWidth: 4)
                    } else {
                        Circle()
                            .stroke(.quaternary, lineWidth: 4)
                    }
                }
                .padding(-2)
            }
            
            Text(viewModel.authorDisplayName)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .font(.system(size: 12, weight: .medium))
        }
        .opacity(viewModel.hasSeenAllPages ? 0.6 : 1.0)
    }
}
