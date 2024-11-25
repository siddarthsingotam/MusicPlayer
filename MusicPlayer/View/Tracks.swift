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
    @State private var showFavoritesOnly = false
    
    var filteredTracks: [MusicTrack] {
        var temp = tracks
        
        temp = temp.filter { track in
            (!showFavoritesOnly || track.isFavorite)
        }
        
        return temp
    }

    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredTracks, id:\.self) { track in
                    TrackRow(track: track)
                }
            }
            .animation(.default, value: filteredTracks)
            .navigationTitle("Tracks")
        }
    }
}
