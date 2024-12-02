//
//  MusicTrack.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 25.11.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class MusicTrack {
    var id: UUID
    var title: String?
    var releaseDate: String?
    var artistName: String?
    var albumName: String?
    var format: String?
    var fileName: String
    var artworkData: Data?
    var isFavorite: Bool = false
    var isNowPlaying: Bool = false
    
    
    init(_ id: UUID = .init(), title: String?, releaseDate: String?, artistName: String?, albumName: String?, format: String?, fileName: String, artworkData: Data?) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.artistName = artistName
        self.albumName = albumName
        self.format = format
        self.fileName = fileName
        self.artworkData = artworkData
    }
    
//    func isEqualTo(_ other: MusicTrack) -> Bool {
//        return self.title == other.title &&
//                self.releaseDate == other.releaseDate &&
//                self.artist == other.artist &&
//                self.album == other.album &&
//                self.format == other.format &&
//                self.path == other.path
//    }
}
