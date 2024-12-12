//
//  AlbumsBox.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 29.11.2024.
//

import SwiftUI

struct AlbumBox: View {
    var album: [MusicTrack]
    
    var body: some View {
        VStack {
            if let artworkData = album[0].artworkData, let uiImage = UIImage(data: artworkData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .cornerRadius(10)
                    .scaledToFill()
            } else {
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "music.note")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(10)
                .scaledToFill()
            }

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
        }
        .scaledToFit()
    }
}
