//
//  Tracks.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 20.11.2024.
//

import SwiftUI
import SwiftData

struct Tracks: View {
    @Environment(\.modelContext) private var context
    @Binding var tabSelection: Tab
    @Query(sort: \MusicTrack.title) var tracks: [MusicTrack]
    var isFavoriteTab = false
    
    var filteredTracks: [MusicTrack] {
        return tracks.filter { track in
            (!isFavoriteTab || track.isFavorite)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(filteredTracks, id: \.self) { track in
                        HStack {
                            if track.isNowPlaying {
                                Label("Toggle favorite", systemImage: "play.fill")
                                    .labelStyle(.iconOnly)
                                    .padding(.horizontal, 10)
                            } else {
                                Text("-")
                                    .padding(.horizontal, 14)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(track.title ?? "Unknown Track")
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(track.artistName ?? "Unknown Artist")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Button {
                                track.isFavorite.toggle()
                                
                                do {
                                    try context.save()
                                }
                                catch {
                                    print("Error \(error)")
                                }
                            } label: {
                                Label("Toggle favorite", systemImage: track.isFavorite ? "heart.fill" : "heart")
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.leading, 15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            tracks.forEach { $0.isNowPlaying = false }
                            track.isNowPlaying = true
                            tabSelection = Tab.nowPlaying
                        }
                        Divider()
                            .background(.gray)
                            .padding(.horizontal, 20)
                    }
                }
                .animation(.default, value: filteredTracks)
                .navigationTitle(isFavoriteTab ? "Favorites" : "Tracks")
            }
            .frame(maxWidth: .infinity)
        }
    }
}
