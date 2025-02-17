//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 20.11.2024.
// 

import SwiftUI
import SwiftData
import AVFoundation

enum Tab {
    case nowPlaying
    case favorites
    case albums
    case tracks
}

struct ContentView: View {
    @Query var tracks: [MusicTrack]
    @Environment(AudioPlayer.self) private var audioPlayer
    @Environment(\.modelContext) private var context
    @State private var selection: Tab = .nowPlaying
    
    func loadMusicFiles() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        for track in tracks {
            let fileName = track.fileName
            let name = (fileName as NSString).deletingPathExtension
            if Bundle.main.url(forResource: name, withExtension: "mp3") == nil { context.delete(track) }
        }
        
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
            var artistName: String?
            var albumName: String?
            var format: String?
            var artworkData: Data?

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
                                artistName = artistValue
                            }
                        case .commonKeyAlbumName:
                            if let albumValue = try await item.load(.value) as? String {
                                albumName = albumValue
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
            
            let track = MusicTrack(title: title, releaseDate: creationDate, artistName: artistName, albumName: albumName, format: format, fileName: fileName, artworkData: artworkData)
            
            let trackDescriptor = FetchDescriptor<MusicTrack>(
                predicate: #Predicate { $0.title == title && $0.fileName == fileName }
            )
            
            if try context.fetch(trackDescriptor).isEmpty {
                context.insert(track)
            }
        }
    }

    
    var body: some View {
        TabView(selection: $selection) {
            NowPlaying()
                .tabItem({ Label("Now Playing", systemImage: "play.fill" ) })
                .tag(Tab.nowPlaying)
            Tracks(tabSelection: $selection, isFavoriteTab: true)
                .tabItem({ Label("Favorites", systemImage: "star.fill" ) })
                .tag(Tab.favorites)
            Albums(tabSelection: $selection)
                .tabItem({ Label("Albums", systemImage: "play.square.stack" ) })
                .tag(Tab.albums)
            Tracks(tabSelection: $selection)
                .tabItem({ Label("Tracks", systemImage: "music.note.list" ) })
                .tag(Tab.tracks)
        }
        .onAppear {
            Task {
                loadMusicFiles()
            }
            audioPlayer.loadCurrent()
        }
    }
}

#Preview {
    ContentView()
}
