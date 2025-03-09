//
//  Common.swift
//  BeSocialDataProvider
//
//  Created by François Boulais on 08/03/2025.
//

public extension DTO {
    enum Common {
        
    }
}

public extension DTO.Common {
    struct Error: Decodable {
        public let code: String
        public let message: String?
    }
    
    struct PaginationMetadata: Decodable {
        public let totalItems: Int
        public let nextItemId: String?
    }
    
    struct DataResponseWithMetadata<Data: Decodable, Metadata: Decodable, Error: Decodable>: Decodable {
        public let data: Data
        public let metadata: Metadata
        public let error: Error?
    }
    
    struct DataPartialResponse<Data: Decodable, Error: Decodable>: Decodable {
        public let data: Data
        public let errors: Error?
    }
}
