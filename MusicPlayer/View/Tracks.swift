//
//  Tracks.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 20.11.2024.
//

import SwiftUI
import SwiftData

struct Tracks: View {
    @Query(sort: \MusicTrack.title) var tracks: [MusicTrack]
    var showToggleFavorite = true
    @State var showFavoritesOnly = false
    
    var filteredTracks: [MusicTrack] {
        return tracks.filter { track in
            (!showFavoritesOnly || track.isFavorite)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if (showToggleFavorite) {
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("Favorites only")
                    }
                }
                
                ForEach(filteredTracks, id:\.self) { track in
                    TrackRow(track: track)
                }
            }
            .animation(.default, value: filteredTracks)
            .navigationTitle(showFavoritesOnly ? "Favorites" : "Tracks")
        }
    }
}
