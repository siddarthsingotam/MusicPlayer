//
//  AlbumTrack.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 29.11.2024.
//

import SwiftUI

struct AlbumTracks: View {
    var album: [MusicTrack]
    @State private var blurAmount: CGFloat = 0
    
    var body: some View {
//        ZStack(alignment: .bottomLeading) {
//            if let artworkData = album[0].artworkData, let uiImage = UIImage(data: artworkData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .cornerRadius(20)
//                    .scaledToFill()
//            } else {
//                ZStack {
//                    Color.gray.opacity(0.3)
//                    Image(systemName: "music.note")
//                        .font(.system(size: 12))
//                        .foregroundColor(.white)
//                }
//                .aspectRatio(1, contentMode: .fit)
//                .cornerRadius(20)
//                .scaledToFill()
//            }
//            
//            Rectangle()
//                .fill(LinearGradient(
//                    gradient: Gradient(colors: [Color.clear, Color.black]),
//                    startPoint: .top,
//                    endPoint: .bottom))
//                .frame(height: 56)
//            
//            VStack {
//                Text(album[0].albumName ?? "Unknown Album")
//                    .fontWeight(.bold)
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//                Text(album[0].artistName ?? "Unknown Artist")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            .padding(10)
//        }
//        .padding(.horizontal, 120)
//
//        List(album) { track in
//            Text(track.title ?? "")
//        }
        
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
                        .padding(5)
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
