//
//  GetFriendsStories.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

import Foundation

public protocol GetFriendsStoriesEndpoint {
    func getStories(from storyId: String?) async throws -> GetFriendsStories.Response
}

public enum GetFriendsStories {
    
}

public extension GetFriendsStories {
    typealias Response = DTO.Common.DataResponseWithMetadata<DTO.Stories.GetFriendsStories.Response, DTO.Common.PaginationMetadata, DTO.Common.Error>
}

extension GetFriendsStories {
    final class FakeEndpoint: GetFriendsStoriesEndpoint {
        private let fileManager: FileManager
        private let jsonDecoder: JSONDecoder
        private let jsonEncoder: JSONEncoder
        private var fileName = "stories.json"

        private var generatedStories = [DTO.Stories.Story]()
        
        init(
            fileManager: FileManager = .default,
            jsonDecoder: JSONDecoder = .init(),
            jsonEncoder: JSONEncoder = .init()
        ) {
            self.fileManager = fileManager
            self.jsonDecoder = jsonDecoder
            self.jsonEncoder = jsonEncoder
        }
        
        // MARK: - GetFriendsStoriesEndpoint
        
        func getStories(from storyId: String?) async throws -> GetFriendsStories.Response {
            let stories = try readOrGenerateStories()
            let startIndex = stories.firstIndex(where: { $0.id == storyId }) ?? stories.startIndex
            let endIndex = min(startIndex + 5, stories.endIndex)
            let slice = Array(stories[startIndex..<endIndex])
            let nextStoryId = endIndex + 1 < stories.endIndex ? stories[endIndex + 1].id : nil
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            return .init(
                data: .init(stories: slice),
                metadata: .init(totalItems: stories.count, nextItemId: nextStoryId), error: nil
            )
        }
        
        // MARK: - Private functions
                
        private func readOrGenerateStories() throws -> [DTO.Stories.Story] {
            guard generatedStories.isEmpty else {
                return generatedStories
            }
            
            let fileURL = try fileURL()
            let stories = try {
                if fileManager.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    return try jsonDecoder.decode([DTO.Stories.Story].self, from: data)
                } else {
                    let stories = generateStories()
                    let data = try jsonEncoder.encode(stories)
                    try data.write(to: fileURL)
                    return stories
                }
            }()
            
            generatedStories = stories
            return stories
        }
        
        private func generateStories() -> [DTO.Stories.Story] {
            let imagesURLs = [
                "https://static01.nyt.com/images/2022/07/11/dining/ss-bulgogi-style-tofu/merlin_209335170_48189dad-00d2-46b3-8673-e540119aacf3-jumbo.jpg",
                "https://www.psychologue.net/site/articles/cf/cd/0/22334/selfi.jpg",
                "https://media.istockphoto.com/id/1471725712/fr/photo/jeune-femme-souriante-prenant-des-selfies-tout-en-se-relaxant-à-la-maison.jpg?s=612x612&w=0&k=20&c=3GH7mPircQ20kQDJT-YA4pJU7U3E31zxj8BsTgNrHkc=",
                "https://image.made-in-china.com/2f0j00KWDzAOecQogm/William-Wetmore-Story-Sculptures-Medea-Marble-Statue.webp",
                "https://res-3.cloudinary.com/jnto/image/upload/w_750,h_750,c_fill,f_auto,fl_lossy,q_auto/v1/media/filer_public/9f/cf/9fcfe145-b878-4933-bb32-10b2acf89a96/okinawa1986_3__ile_de_kume_ovek5d"
            ]
            
            let allDisplayNames = ["Neo", "Trinity", "Morpheus", "Smith", "Oracle", "Cypher", "Niobe", "Dozer", "Switch", "Tank", "Seraph", "Sati", "Merovingian", "Persephone", "Ghost", "Lock", "Rama", "Bane", "The Keymaker", "Commander Thadeus", "Kid", "Zee", "Mifune", "Roland", "Cas", "Colt", "Vector", "Sequoia", "Sentinel", "Turing"]
            
            return allDisplayNames.enumerated().map { (storyIndex, displayName) in
                let numberOfStories: Int = .random(in: 1..<4)
                return .init(
                    id: String(storyIndex),
                    author: .init(
                        id: String(storyIndex),
                        displayName: displayName,
                        profilePictureURL: URL(string: "https://i.pravatar.cc/300?u=\(storyIndex)")!,
                        createdAt: .now
                    ),
                    pages: (0..<numberOfStories).map { index in
                        .init(
                            id: "\(storyIndex)_\(index)",
                            contentType: .image,
                            contentURL: URL(string: imagesURLs.randomElement()!)!
                        )
                    }
                )
            }
        }
        
        private func fileURL() throws -> URL {
            var url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            url.appendPathComponent(fileName)
            return url
        }
    }
}
