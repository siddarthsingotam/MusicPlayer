//
//  NowPlaying.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 25.11.2024.
//

import SwiftUI
import AVKit
import SwiftData

struct NowPlaying: View {
//    let audioFile = "something.mp3"
    @Environment(AudioPlayer.self) var audioPlayer
    @Environment(\.modelContext) private var context
    @Query(sort: \MusicTrack.title) var tracks: [MusicTrack]

//    var audioFile: MusicTrack? {
//        tracks.first(where: { $0.isNowPlaying == true })
//    }
    
//    @State private var audioFileIdx: Int? {
//        didSet {
//            if let idx = audioFileIdx {
//                tracks.forEach { $0.isNowPlaying = false }
//                tracks[idx].isNowPlaying = true
//            }
//        }
//    }
    
    @Environment(\.colorScheme) var colorScheme
    
//    @State private var player: AVAudioPlayer?
//    @State private var isPlaying = false
//    @State private var totalTime: TimeInterval = 0.0
//    @State private var currentTime: TimeInterval = 0.0
    
    @State private var sliderValue = 0.0
    
    var body: some View {
//        if audioFile != nil {
        NavigationStack {
            VStack {
                ZStack {
                    HStack {
                        ModifiedButtonView(image: "arrow.left")
                        Spacer()
                        NavigationLink(destination: Equalizer(audioPlayer: audioPlayer)) {
                            ModifiedButtonView(image: "slider.vertical.3")
                        }
                    }
                    Text("Now Playing")
                        .fontWeight(.bold)
                        .foregroundColor(.primary) // Dynamic color based on system theme
                }
                .padding(.all)
                
                Image("tree")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 55)
                    .clipShape(Circle())
                    .padding(.all, 8)
                    .background(Color(UIColor.secondarySystemBackground)) // Adjusts for light/dark mode
                    .clipShape(Circle())
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 8, x: 8, y: 8)
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 10, x: -10, y: -10)
                    .padding(.top, 35)
                
                //            Text("\(audioFile?.title! ?? "Unknown Track")")
                Text(audioPlayer.currentTrack?.title ?? "Unknown Track")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary) // Dynamic color
                    .padding(.top, 25)
                
                Text(audioPlayer.currentTrack?.artistName ?? "Unknown Artist")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
                
                //            if let trackArtist = audioFile?.artistName {
                //                Text(trackArtist)
                //                    .font(.caption)
                //                    .foregroundColor(.secondary) // Dynamic color
                //                    .padding(.top, 2)
                //            } else {
                //                Text("Unknown Artist")
                //                    .font(.subheadline)
                //                    .foregroundColor(.gray)
                //            }
                
                VStack {
                    HStack {
                        //                    Text(timeString(time: currentTime))
                        Text(timeString(time: audioPlayer.currentTime))
                        Spacer()
                        Button {
                            audioPlayer.currentTrack?.isFavorite.toggle()
                            
                            do {
                                try context.save()
                            }
                            catch {
                                print("Error \(error)")
                            }
                        } label: {
                            Label("Toggle favorite", systemImage: audioPlayer.currentTrack?.isFavorite ?? false ? "heart.fill" : "heart")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.headline)
                        Spacer()
                        //                    Text(timeString(time: totalTime))
                        Text(timeString(time: audioPlayer.totalTime))
                    }
                    .font(.caption)
                    .foregroundColor(.primary) // Dynamic color
                    .padding([.top, .leading, .trailing], 25)
                    
                    //                Slider(value: Binding(get: { currentTime },
                    //                                      set: { newValue in audioTime(to: newValue)}
                    //                                     ), in: 0...totalTime)
                    
                    Slider(value: Binding(get: { audioPlayer.currentTime },
                                          set: { newTime in
                        audioPlayer.displayLink?.isPaused = true
                        audioPlayer.seek(to: newTime) }),
                           in: 0...audioPlayer.totalTime)
                    .padding([.top, .leading, .trailing], 20)
                    
                    //                Slider(value: $sliderValue, in: 0...audioPlayer.totalTime)
                    //                    .onReceive(viewModel.$sliderValue) { _ in
                    //                        sliderValue = viewModel.sliderValue
                    //                    }
                    
                }
                
                HStack {
                    Button(action: {
                        //                    movePrevious()
                        audioPlayer.loadPrevious()
                        if audioPlayer.isPlaying {
                            audioPlayer.play()
                        }
                        if let currentIndex = audioPlayer.currentTrackIndex {
                            tracks.forEach { $0.isNowPlaying = false }
                            tracks[currentIndex].isNowPlaying = true
                        }
                    }, label: {
                        ModifiedButtonView(image: "backward.fill")
                    })
                    
                    //                    ModifiedButtonView(image: isPlaying ? "pause.fill" : "play.fill") {
                    //                        if audioFile != nil {
                    //                            isPlaying ? stopAudio() : playAudio()
                    //                        }
                    //                    }
                    //                    ModifiedButtonView(image: audioPlayer.isPlaying ? "pause.fill" : "play.fill") {
                    //                        audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play()
                    //                    }
                    
                    Button(action: {
                        audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play()
                    }, label: {
                        ModifiedButtonView(image: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    })
                    
                    Button(action: {
                        //                    moveNext()
                        audioPlayer.loadNext()
                        if audioPlayer.isPlaying {
                            audioPlayer.play()
                        }
                        if let currentIndex = audioPlayer.currentTrackIndex {
                            tracks.forEach { $0.isNowPlaying = false }
                            tracks[currentIndex].isNowPlaying = true
                        }
                    }, label: {
                        ModifiedButtonView(image: "forward.fill")
                    })
                    //                })
                }
            }
            .background(Color(UIColor.systemBackground)) // Adjusts based on system theme
            .onAppear {
                //            if let currentIdx = tracks.firstIndex(where: { $0.isNowPlaying == true }) {
                //                audioFileIdx = currentIdx
                //            }
                //            setupAudio()
                audioPlayer.tracks = tracks
                audioPlayer.loadCurrent()
            }
        }
//        .onChange(of: audioFileIdx) {
//            let isCurrentlyPlaying = isPlaying
//            stopAudio()
//            setupAudio()
//            if isCurrentlyPlaying {
//                playAudio()
//            }
//        }
//        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
//            updateProgress()
//        }
//        } else {
//            Text("CHOOSE SOMETHING TO PLAY")
//        }
    }
    
//    private func setupAudio() {
//        guard let fileName = audioFile?.fileName else { return }
//        let name = (fileName as NSString).deletingPathExtension
//        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
//        print(url)
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.prepareToPlay()
////            currentTime = player?.currentTime ?? 0.0
//            totalTime = player?.duration ?? 0.0
//        } catch {
//            print("Error loading audio: \(error)")
//        }
//    }
//
//    private func playAudio() {
//        player?.play()
//        isPlaying = true
//    }
//
//    private func stopAudio() {
//        player?.stop()
//        isPlaying = false
//    }
//
//    private func moveNext() {
//        if let currentIdx = audioFileIdx, currentIdx < tracks.count - 1 {
//            audioFileIdx = currentIdx + 1
//        }
//    }
//
//    private func movePrevious() {
//        if let currentIdx = audioFileIdx, currentIdx > 0 {
//            audioFileIdx = currentIdx - 1
//        }
//    }
//
//    private func updateProgress() {
//        guard let player = player else { return }
//        currentTime = player.currentTime
//    }
//
//    private func audioTime(to time: TimeInterval){
//        player?.currentTime = time
//    }
    
    private func timeString(time: TimeInterval) -> String {
        guard time.isFinite, time >= 0 else {
            return "00:00"
        }
        
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    NowPlaying()
}
