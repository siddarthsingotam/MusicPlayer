//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 20.11.2024.
// fg

import SwiftUI
import SwiftData
import AVFoundation

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var selection: Tab = .favorites
    
    enum Tab {
        case favorites
        case albums
        case tracks
    }
    
    func loadMusicFiles() async {
        let fm = FileManager.default
        let path  = Bundle.main.resourcePath!
        
        do {
            let files = try fm.contentsOfDirectory(atPath: path)
            
            for file in files {
                if (file.hasSuffix("mp3") ||
                    file.hasSuffix("wav") ||
                    file.hasSuffix("m4a") ||
                    file.hasSuffix("aac")) {
                    handleAddingMusicTrack(file)
                }
            }
        }
        catch {
            print("Error: \(error)")
        }
    }

    func handleAddingMusicTrack(_ fileName: String) {
        let filePath = Bundle.main.url(forResource: fileName, withExtension: nil)!
        let asset = AVURLAsset(url: filePath)
        
        Task {
            let metadata = try await asset.load(.metadata)
            
            var title: String?
            var creationDate: String?
            var artist: String?
            var album: String?
            var format: String?
            var artworkData: Data?
            
            print(metadata)
            print()

            for item in metadata {
                do {
                    switch item.commonKey {
                        case .commonKeyTitle:
                            if let titleValue = try await item.load(.value) as? String {
                                title = titleValue
                            } else {
                                title = "???"
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
                        case .commonKeyArtwork:
                            if let artworkValue = try await item.load(.value) as? Data {
                                artworkData = artworkValue
                            }
                        default:
                            break
                    }
                }
                catch {
                    print("Error loading item: \(error)")
                }
            }
            
            let track = MusicTrack(title: title, releaseDate: creationDate, artist: artist, album: album, format: format, path: fileName, artworkData: artworkData)
            
            let trackDescriptor = FetchDescriptor<MusicTrack>(
                predicate: #Predicate { $0.title == title }
            )
            
            if try context.fetch(trackDescriptor).isEmpty {
                context.insert(track)
            }
        }
    }

    
    var body: some View {
        TabView(selection: $selection) {
            Tracks(showToggleFavorite: false, showFavoritesOnly: true)
                .tabItem({ Label("Favorites", systemImage: "star.fill" ) })
                .tag(Tab.favorites)
            Albums()
                .tabItem({ Label("Albums", systemImage: "play.square.stack" ) })
                .tag(Tab.albums)
            Tracks()
                .tabItem({ Label("Tracks", systemImage: "music.note.list" ) })
                .tag(Tab.tracks)
        }
        .onAppear {
            Task {
                await loadMusicFiles()
            }
        }
    }
}

#Preview {
    ContentView()
}
