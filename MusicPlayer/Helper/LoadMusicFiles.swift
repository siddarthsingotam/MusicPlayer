//
//  LoadMusicFiles.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 25.11.2024.
//

import SwiftUI
import SwiftData
import AVFoundation

@MainActor
func loadMusicFiles(_ context: ModelContext) async {
    let fm = FileManager.default
    let path  = Bundle.main.resourcePath!
    
    do {
        let items = try fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if (item.hasSuffix("mp3") ||
                item.hasSuffix("wav") ||
                item.hasSuffix("m4a") ||
                item.hasSuffix("aac")) {
                handleAddingMusicTrack(item, context)
            }
        }
    }
    catch {
        print("Error: \(error)")
    }
}

func handleAddingMusicTrack(_ fileName: String, _ context: ModelContext) {
    let filePath = Bundle.main.url(forResource: fileName, withExtension: nil)!
    let asset = AVURLAsset(url: filePath)
    
    Task {
        let metadata = try await asset.load(.metadata)
        
        var title: String?
        var creationDate: String?
        var artist: String?
        var album: String?
        var format: String?
        

        for item in metadata {
            do {
                switch item.commonKey {
                case .commonKeyTitle:
                    if let titleValue = try await item.load(.value) as? String {
                        title = titleValue 
                    }
                case .commonKeyCreationDate:
                    if let creationDateValue = try await item.load(.value) as? String {
                        creationDate = creationDateValue
                    }
                case .commonKeyArtist:
                    if let artistValue = try await item.load(.value) as? String {
                        artist = artistValue
                    }
                case .commonKeyAlbumName:
                    if let albumValue = try await item.load(.value) as? String {
                        album = albumValue
                    }
                case .commonKeyFormat:
                    if let formatValue = try await item.load(.value) as? String {
                        format = formatValue
                    }
                    //                case .commonKeyArtwork:
                    //                    if let artworkData = try await item.load(.value) as Data {
                    //                        if let image = UIImage(data: artworkData) {
                    //                            print("Artwork: \(image)")
                    //                        }
                    //                    }
                default:
                    break
                }
                
                let track = MusicTrack(title: title, releaseDate: creationDate, artist: artist, album: album, format: format, path: fileName)
                
                let trackDescriptor = FetchDescriptor<MusicTrack>(
                    predicate: #Predicate { $0.title == title! }
                )
                
                if try context.fetch(trackDescriptor).isEmpty {
                    context.insert(track)
                }
            }
            catch {
                print("Error loading item: \(error)")
            }
        }
    }
}
