//
//  Tracks.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 20.11.2024.
//

import SwiftUI
import SwiftData

struct Tracks: View {
    @Binding var tabSelection: Tab
    @Query(sort: \MusicTrack.title) var tracks: [MusicTrack]
    var isFavoriteTab = false
    @State var showFavoritesOnly = false
    
    var filteredTracks: [MusicTrack] {
        return tracks.filter { track in
            (!showFavoritesOnly || track.isFavorite)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredTracks) { track in
                TrackRow(track: track)
                    .onTapGesture {
                        tracks.forEach { $0.isNowPlaying = false }
                        track.isNowPlaying = true
                        tabSelection = Tab.nowPlaying
                    }
            }
            .animation(.default, value: filteredTracks)
            .navigationTitle(isFavoriteTab ? "Favorites" : "Tracks")
        }
    }
}
