//
//  StoriesCarouselBannerCell.swift
//  StoriesFeature
//
//  Created by François Boulais on 09/03/2025.
//

import BeSocialEntity

enum StoriesCarouselBannerCell: Equatable, Identifiable {
    case placeholder(id: Int)
    case story(Story)
    case pagination(nextStoryId: String)
    
    var isPagination: Bool {
        switch self {
        case .pagination:
            return true
        default:
            return false
        }
    }
    
    var isPlaceholder: Bool {
        switch self {
        case .placeholder:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Identifiable
    
    var id: String {
        switch self {
        case .placeholder(let id):
            String("placeholder_\(id)")
        case .story(let story):
            story.id
        case .pagination(let nextStoryId):
            nextStoryId
        }
    }
}
