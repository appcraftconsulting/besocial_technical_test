//
//  ResetSeenStoriesPagesButton.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import SwiftUI

public struct ResetSeenStoriesPagesButton: View {
    public init() {
        
    }
    
    public var body: some View {
        Button {
            UserDefaults.standard.seenStoriesPagesIds = []
        } label: {
            Text("reset_seen_stories_pages_button_title")
        }
    }
}
