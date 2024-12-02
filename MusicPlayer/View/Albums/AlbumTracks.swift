//
//  AlbumTrack.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 29.11.2024.
//

import SwiftUI
import SwiftData

struct AlbumTracks: View {
    @Environment(\.modelContext) private var context
    @Binding var tabSelection: Tab
    var album: [MusicTrack]
    @Query(sort: \MusicTrack.title) private var tracks: [MusicTrack]
    @State private var blurAmount: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        if let artworkData = album[0].artworkData, let uiImage = UIImage(data: artworkData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                Color.gray.opacity(0.3)
                                Image(systemName: "music.note")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .aspectRatio(1, contentMode: .fill)
                        }
                        
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black]),
                                startPoint: .top,
                                endPoint: .bottom))
                            .frame(height: 70)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                .blur(radius: blurAmount)
                .animation(.easeInOut, value: blurAmount)
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    GeometryReader { geometry in
                        Spacer().frame(height: UIScreen.main.bounds.height * 0.3)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                    
                    VStack {
                        Text(album[0].albumName ?? "Unknown Album")
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(album[0].artistName ?? "Unknown Artist")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 70)
                    
                    
                    ForEach(album, id: \.self) { track in
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
                .background(GeometryReader { geometry in
                    Color
                        .clear
                        .onChange(of: geometry.frame(in: .global).origin.y) {
                            let offset = geometry.frame(in: .global).origin.y
                            let blurIntensity = min(max(0, -offset / 2), 50)
                            self.blurAmount = blurIntensity
                        }
                })
            }
            .frame(maxWidth: .infinity)
        }
    }
}
