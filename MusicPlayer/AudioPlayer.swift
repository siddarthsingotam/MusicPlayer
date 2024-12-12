//
//  AudioPlayer.swift
//  MusicPlayer
//
//  Created by Dung Pham on 3.12.2024.
//

import Foundation
import AVFoundation

@Observable
class AudioPlayer {
    private var player: AVPlayer?
    private var audioEngine: AVAudioEngine!
    private var playerNode: AVAudioPlayerNode!
    var eqNode: AVAudioUnitEQ!
    private var audioFile: AVAudioFile?
    
    var tracks: [MusicTrack] = []
    var currentTrack: MusicTrack?
    var currentTrackIndex: Int?
    
    var isPlaying: Bool = false
    
    var displayLink: CADisplayLink?
    private var isSeeking: Bool = false
    
    var currentTime: TimeInterval = 0.0
    var totalTime: TimeInterval = 0.0
    
    private var updateTimer: Timer?
    
    var eqGains: [Float] = Array(repeating: 0.0, count: 10)
    private let freqs: [Float] = [32, 64, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    
    var isSliderEditing: Bool = false
    
    init() {
        self.player = AVPlayer()
        self.audioEngine = AVAudioEngine()
        self.playerNode = AVAudioPlayerNode()
        self.eqNode = AVAudioUnitEQ(numberOfBands: 10)
        
        configEQBands()
        
        audioEngine.attach(playerNode)
        audioEngine.attach(eqNode)
        
        audioEngine.connect(playerNode, to: eqNode, format: nil)
        audioEngine.connect(eqNode, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting Audio Engine: \(error)")
        }
        
        setupSlider()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidFinishPlaying(_:)),
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupSlider() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateSlider))
        displayLink?.add(to: .current, forMode: .default)
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 2, maximum: 3)
        displayLink?.isPaused = true
    }
    
    @objc func updateSlider() {
//        if currentTime <= totalTime {
//            self.currentTime = playerNode.currentTime
//        }
        if isPlaying {
            print("playernode current time: \(playerNode.currentTime)")
            self.currentTime = playerNode.currentTime + (displayLink?.duration ?? 0)
        }
    }
    
    func loadCurrent() {
        if let current = tracks.first(where: { $0.isNowPlaying == true }), currentTrack?.fileName != current.fileName {
            load(current)
        }
    }
    
    private func load(_ track: MusicTrack) {
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: nil) else {
            print("Track not found in bundle: \(track.fileName)")
            return
        }
        
//        let playerItem = AVPlayerItem(url: url)
//        
//        player?.replaceCurrentItem(with: playerItem)
//        currentTrack = track
//        currentTrackIndex = tracks.firstIndex(where: { $0.id == currentTrack?.id })
//        
//        totalTime = playerItem.asset.duration.seconds
        
        do {
            let file = try AVAudioFile(forReading: url)
            self.audioFile = file
            
//            updateTimer?.invalidate()
//            updateTimer = nil
            
            playerNode.stop()
            playerNode.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack)
            
            currentTrack = track
            currentTrackIndex = tracks.firstIndex(where: { $0.id == currentTrack?.id })
            
//            totalTime = Double(file.length) / file.processingFormat.sampleRate
            totalTime = audioFile?.duration ?? 0.0
            
//            displayLink?.isPaused = false
            
            if isPlaying {
                play()
            }
        } catch {
            print("Error loading audio file_ \(error)")
        }
    }
    
    func play() {
//        if !isPlaying {
//            player?.play()
        playerNode.play()
        displayLink?.isPaused = false
        
//            startUpdateTime()
            isPlaying = true
//        }
    }
    
    func pause() {
//        player?.pause()
        playerNode.pause()
        displayLink?.isPaused = true
        
//        updateTimer?.invalidate()
//        updateTimer = nil
        isPlaying = false
    }
    
    func seek(to time: TimeInterval) {
////        let timeToSeek = CMTime(seconds: time, preferredTimescale: 10)
////        player?.seek(to: timeToSeek)
////        currentTime = time
//        
//        guard let file = audioFile else { return }
//        
////        updateTimer?.invalidate()
////        updateTimer = nil
//        
//        displayLink?.isPaused = true
//        
//        let sampleTime = AVAudioFramePosition(time * Double(file.processingFormat.sampleRate))
//        
//        playerNode.stop()
//        
//        if time <= totalTime {
//            playerNode.scheduleSegment(file,
//                                       startingFrame: sampleTime,
//                                       frameCount: AVAudioFrameCount(AVAudioFramePosition(file.length - sampleTime)),
//                                       at: nil)
//        }
//        
//        
//        if isPlaying {
//            play()
//        }
//        
//        currentTime = time

        guard let audioFile = audioFile else { return }

        // Stop the player node before seeking to the new position
        playerNode.stop()

        let sampleRate = audioFile.processingFormat.sampleRate
        let sampleTime = AVAudioFramePosition(time * sampleRate)

        let audioTime = AVAudioTime(hostTime: 0, sampleTime: sampleTime, atRate: sampleRate)

        let remainingFrameCount = AVAudioFrameCount(audioFile.length - sampleTime)

        playerNode.scheduleSegment(audioFile,
                                   startingFrame: sampleTime,
                                   frameCount: remainingFrameCount,
                                   at: nil)

        playerNode.play(at: audioTime)

        currentTime = time
    }
    
    func loadNext() {
        guard let currentIndex = currentTrackIndex, currentIndex < tracks.count - 1 else { return }
        let nextTrack = tracks[currentIndex + 1]
        load(nextTrack)
    }
    
    func loadPrevious() {
        guard let currentIndex = currentTrackIndex, currentIndex > 0 else { return }
        let previousTrack = tracks[currentIndex - 1]
        load(previousTrack)
    }
    
//    private func startUpdateTime() {
////        let interval = CMTimeMake(value: 1, timescale: 10)
////        
////        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
////            guard let self = self else { return }
////            self.currentTime = time.seconds
////        }
//        
//        guard let file = audioFile else { return }
//        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            let currentSampleTime = self.playerNode.lastRenderTime?.sampleTime ?? 0
//            
//            let playbackTime = Double(currentSampleTime) / Double(file.processingFormat.sampleRate)
//            
//            if playbackTime <= totalTime {
//                self.currentTime = playbackTime
//            }
//            
//        }
//    }
    
    @objc private func playerItemDidFinishPlaying(_ notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem, playerItem == player?.currentItem {
            loadNext()
            if isPlaying {
                play()
            }
        }
    }
    
    func setEQGain(forBand bandIndex: Int,value gain: Float) {
        guard bandIndex >= 0 && bandIndex < eqNode.bands.count else { return }
        
        eqNode.bands[bandIndex].gain = gain
        eqGains[bandIndex] = gain
    }
    
    func configEQBands() {
        for (index, freq) in freqs.enumerated() {
            eqNode.bands[index].frequency = freq
            eqNode.bands[index].bypass = false
            eqNode.bands[index].filterType = .parametric
            eqNode.bands[index].gain = 0
            eqNode.bands[index].bandwidth = 1.0
        }
    }
}


extension AVAudioFile {
    var duration: TimeInterval {
        let sampleRateSong = Double(processingFormat.sampleRate)
        let lengthSongSeconds = Double(length) / sampleRateSong
        return lengthSongSeconds
    }
}

extension AVAudioPlayerNode {
    var currentTime: TimeInterval {
        if let nodeTime = lastRenderTime, let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / outputFormat(forBus: 0).sampleRate
        }
        return 0
    }
}

