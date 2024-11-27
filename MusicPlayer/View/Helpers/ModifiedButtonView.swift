//
//  ModifiedButtonView.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 25.11.2024.
//

import SwiftUI

struct ModifiedButtonView: View {
    var image: String
    
    @Environment(\.colorScheme) var colorScheme // Detect current color scheme
    
    var body: some View {
        Button(action: {}, label: {
            Image(systemName: image)
                .font(.system(size: 14, weight: .bold))
                .padding(.all, 25)
                .foregroundColor(colorScheme == .dark ? .white : .black.opacity(0.8)) // Change icon color based on theme
                .background(
                    ZStack {
                        // Background color based on system theme
                        Color(colorScheme == .dark ? UIColor.systemGray : UIColor(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))) // Light gray for dark mode, custom for light mode
                        
                        // Inner circle light effect
                        Circle()
                            .foregroundColor(colorScheme == .dark ? Color.black.opacity(0.3) : .white) // Darker inner circle for dark mode
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        // Gradient for circle based on theme
                        Circle()
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [
                                    colorScheme == .dark ? Color.black : Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)),
                                    colorScheme == .dark ? Color.gray : Color.white
                                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .padding(2)
                            .blur(radius: 2)
                    }
                        .clipShape(Circle())
                        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.5), radius: 20, x: 20, y: 20)
                        .shadow(color: colorScheme == .dark ? Color.black : Color.black.opacity(0.1), radius: 20, x: -20, y: -20)
                )
        })
    }
}

#Preview {
    ModifiedButtonView(image: "pencil")
}
