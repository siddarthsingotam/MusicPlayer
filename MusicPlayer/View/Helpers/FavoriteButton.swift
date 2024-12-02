//
//  FavoriteButton.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 2.12.2024.
//

import SwiftUI
import SwiftData

struct FavoriteButton: View {
    @Environment(\.modelContext) private var context
    @Binding var isFavorite: Bool
    
    var body: some View {
        Button {
            isFavorite.toggle()
            
            do {
                try context.save()
            }
            catch {
                print("Error \(error)")
            }
        } label: {
            Label("Toggle favorite", systemImage: isFavorite ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(.yellow)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
