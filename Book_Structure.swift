//
//  Transaction_Model.swift
//  Track.io
//
//  Created by William on 12/18/23.
//

import Foundation
struct Books: Decodable{
    var items: [BookItem]
}
struct BookItem: Decodable{
    let id: String
    let volumeInfo: VolumeInfo
}
struct VolumeInfo: Decodable {
    let title: String
    let imageLinks: ImageLinks?
    let authors: [String]
    let description: String
}

struct ImageLinks: Decodable {
    let thumbnail: URL?
    let smallThumbnail: URL?

    private enum CodingKeys: String, CodingKey {
        case thumbnail, smallThumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
            .flatMap { URL(string: $0.replacingOccurrences(of: "http://", with: "https://")) }
        smallThumbnail = try container.decodeIfPresent(String.self, forKey: .smallThumbnail)
            .flatMap { URL(string: $0.replacingOccurrences(of: "http://", with: "https://")) }
    }
}
struct RatedBook{
    var volumeInfo: VolumeInfo
    var rating: Int
    var description: String?
}
