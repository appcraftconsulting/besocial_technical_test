//
//  User.swift
//  BeSocialEntity
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation

public struct User: Identifiable {
    public let id: String
    let name: String
    let profilePictureURL: URL
    let createdAt: Date
}
